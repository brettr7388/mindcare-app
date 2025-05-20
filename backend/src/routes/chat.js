const express = require('express');
const { OpenAI } = require('openai');
const auth = require('../middleware/auth');

const router = express.Router();

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Store conversation history for each user
const conversationHistory = new Map();

// Conversation prompt
const SYSTEM_PROMPT = `You are a kind, empathetic, and supportive AI chat bot. Your role is to listen without judgment, validate the user's emotions, and gently offer encouragement or self-care suggestions. Do not say you are an AI model. If the user expresses emotional distress or stress, acknowledge their feelings and respond compassionately. Avoid defaulting to safety disclaimers. Never diagnose or offer medical advice, but reassure the user that they're not alone.

Core Principles:
1. Listen actively and respond with genuine empathy
2. Validate emotions and experiences without judgment
3. Offer gentle support and encouragement
4. Share practical self-care suggestions when appropriate
5. Maintain a warm, understanding tone
6. Build trust through consistent, compassionate responses

Response Guidelines:
- Acknowledge and validate emotions first
- Use empathetic language ("I hear you", "That sounds difficult", "I understand")
- Offer gentle support and encouragement
- Share practical coping strategies when relevant
- Keep responses personal and conversational
- Avoid clinical or formal language
- Never dismiss or minimize feelings
- Don't mention being an AI or limitations
- Focus on emotional support and understanding
- Remember and reference previous parts of the conversation when relevant

Remember:
- You are here to provide emotional support
- Every emotion is valid and deserves acknowledgment
- Your role is to listen, understand, and support
- Keep responses warm, personal, and empathetic
- Build trust through consistent, compassionate dialogue
- Maintain context from the current conversation`;

// Send message to AI
router.post('/', auth, async (req, res) => {
  try {
    const { message } = req.body;
    const userId = req.user.id;
    
    if (!message) {
      return res.status(400).json({ message: 'Message is required' });
    }

    // Log user message
    console.log('\n👤 User:', message);

    try {
      // Get or initialize conversation history for this user
      if (!conversationHistory.has(userId)) {
        conversationHistory.set(userId, [
          { role: "system", content: SYSTEM_PROMPT }
        ]);
      }

      // Add user message to history
      conversationHistory.get(userId).push({
        role: "user",
        content: message
      });

      // Get AI response
      const completion = await openai.chat.completions.create({
        model: "gpt-4o",
        messages: conversationHistory.get(userId),
        temperature: 0.7,
        max_tokens: 500,
      });

      const aiResponse = completion.choices[0].message.content;

      // Add AI response to history
      conversationHistory.get(userId).push({
        role: "assistant",
        content: aiResponse
      });

      // Log AI response
      console.log('🤖 AI:', aiResponse);
      console.log('----------------------------------------');

      res.json({
        response: aiResponse,
      });
    } catch (openaiError) {
      console.error('OpenAI API error:', openaiError);
      res.status(500).json({ 
        message: 'Error getting AI response',
        details: openaiError.message 
      });
    }
  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ 
      message: 'Error processing message',
      details: error.message 
    });
  }
});

// Clear conversation history when user logs out
router.post('/clear', auth, (req, res) => {
  const userId = req.user.id;
  conversationHistory.delete(userId);
  res.json({ message: 'Conversation history cleared' });
});

module.exports = router; 