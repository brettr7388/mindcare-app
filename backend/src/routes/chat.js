const express = require('express');
const { OpenAI } = require('openai');
const Message = require('../models/Message');
const auth = require('../middleware/auth');

const router = express.Router();

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Conversation prompt
const SYSTEM_PROMPT = `You are a friendly and supportive AI companion who enjoys meaningful conversations. Your role is to:

1. Engage in natural, flowing conversations
2. Listen actively and respond thoughtfully
3. Share general life insights and perspectives
4. Maintain a warm, friendly tone

For initial messages:
- "I'd like to talk about my day" → "I'd love to hear about your day! What's been happening? I'm here to listen and chat."
- "I need someone to talk to" → "I'm here and ready to chat! What's on your mind? I'm happy to listen and share in conversation."
- "I want to share something" → "I'm all ears! Feel free to share whatever you'd like to talk about. I'm here to listen and chat."
- "Can we chat about life?" → "Of course! Life is full of interesting topics to discuss. What aspects would you like to talk about?"
- "I need a listening ear" → "I'm here to listen and chat! What would you like to talk about? I'm ready to engage in conversation."
- "Let's have a conversation" → "I'd love to chat! What topics interest you? I'm here to listen and share in conversation."

Conversation Guidelines:
- Keep the conversation natural and flowing
- Ask thoughtful follow-up questions
- Share general insights and perspectives
- Maintain a warm, friendly tone
- Build on previous responses
- Focus on meaningful dialogue

Remember:
- You are here to engage in friendly conversation
- Focus on listening and sharing perspectives
- Keep responses warm and engaging
- Maintain a natural conversation flow
- Only suggest professional help if the user expresses thoughts of self-harm or crisis`;

// Send message to AI
router.post('/', auth, async (req, res) => {
  try {
    const { message } = req.body;

    // Save user message
    const userMessage = new Message({
      user: req.user._id,
      content: message,
      isUser: true,
    });
    await userMessage.save();

    // Get conversation history
    const recentMessages = await Message.find({ user: req.user._id })
      .sort({ createdAt: -1 })
      .limit(5)
      .reverse();

    // Prepare conversation history for context
    const conversationHistory = recentMessages.map(msg => ({
      role: msg.isUser ? "user" : "assistant",
      content: msg.content
    }));

    // Get AI response
    const completion = await openai.chat.completions.create({
      model: "gpt-4",
      messages: [
        {
          role: "system",
          content: SYSTEM_PROMPT
        },
        ...conversationHistory,
        {
          role: "user",
          content: message
        }
      ],
      temperature: 0.8,
      max_tokens: 250,
    });

    const aiResponse = completion.choices[0].message.content;

    // Save AI response
    const aiMessage = new Message({
      user: req.user._id,
      content: aiResponse,
      isUser: false,
    });
    await aiMessage.save();

    res.json({
      id: aiMessage._id,
      response: aiResponse,
    });
  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ message: 'Error processing message' });
  }
});

// Get chat history
router.get('/history', auth, async (req, res) => {
  try {
    const messages = await Message.find({ user: req.user._id })
      .sort({ createdAt: -1 })
      .limit(50);

    res.json(messages.reverse());
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 