const express = require('express');
const Mood = require('../models/Mood');
const auth = require('../middleware/auth');

const router = express.Router();

// Create a new mood entry
router.post('/', auth, async (req, res) => {
  try {
    const { rating } = req.body;

    // Check if user already has a mood entry for today
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const existingMood = await Mood.findOne({
      user: req.user.id,
      timestamp: {
        $gte: today,
        $lt: tomorrow
      }
    });

    if (existingMood) {
      return res.status(400).json({ message: 'You have already set your mood for today' });
    }

    const mood = new Mood({
      user: req.user.id,
      rating,
      timestamp: new Date()
    });

    await mood.save();
    res.status(201).json(mood);
  } catch (error) {
    console.error('Error creating mood:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Update a mood entry
router.put('/:id', auth, async (req, res) => {
  try {
    const { rating } = req.body;
    const mood = await Mood.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      { $set: { rating: rating } },
      { new: true }
    );

    if (!mood) {
      return res.status(404).json({ message: 'Mood not found' });
    }

    res.json(mood);
  } catch (error) {
    console.error('Error updating mood:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get all moods for the authenticated user (last 30 days)
router.get('/', auth, async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
    thirtyDaysAgo.setHours(0, 0, 0, 0);

    const moods = await Mood.find({
      user: req.user.id,
      timestamp: { $gte: thirtyDaysAgo }
    }).sort({ timestamp: -1 });

    res.json(moods);
  } catch (error) {
    console.error('Error fetching moods:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get today's mood for the authenticated user
router.get('/today', auth, async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const mood = await Mood.findOne({
      user: req.user.id,
      timestamp: {
        $gte: today,
        $lt: tomorrow
      }
    });

    res.json(mood);
  } catch (error) {
    console.error('Error fetching today\'s mood:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get mood statistics
router.get('/stats', auth, async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const moods = await Mood.find({
      user: req.user.id,
      timestamp: { $gte: thirtyDaysAgo }
    });

    const stats = {
      average: moods.reduce((acc, mood) => acc + mood.rating, 0) / moods.length || 0,
      total: moods.length,
      distribution: {
        1: moods.filter(m => m.rating === 1).length,
        2: moods.filter(m => m.rating === 2).length,
        3: moods.filter(m => m.rating === 3).length,
        4: moods.filter(m => m.rating === 4).length,
        5: moods.filter(m => m.rating === 5).length,
      },
    };

    res.json(stats);
  } catch (error) {
    console.error('Error fetching mood stats:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 