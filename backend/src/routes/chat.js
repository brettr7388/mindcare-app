const express = require('express');
const { OpenAI } = require('openai');
const Message = require('../models/Message');
const auth = require('../middleware/auth');

const router = express.Router();

// Initialize OpenAI
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

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

    // Get AI response
    const completion = await openai.chat.completions.create({
      model: "gpt-4",
      messages: [
        {
          role: "system",
          content: "You are a supportive mental health companion. Provide empathetic, helpful responses while maintaining professional boundaries. Focus on active listening, validation, and gentle guidance. Never provide medical advice or diagnosis."
        },
        {
          role: "user",
          content: message
        }
      ],
      temperature: 0.7,
      max_tokens: 150,
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