const express = require('express');
const Mood = require('../models/Mood');
const auth = require('../middleware/auth');

const router = express.Router();

// Create a new mood entry
router.post('/', auth, async (req, res) => {
  try {
    const { rating, note } = req.body;

    const mood = new Mood({
      user: req.user._id,
      rating,
      note,
    });

    await mood.save();
    res.status(201).json(mood);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update a mood entry
router.put('/:id', auth, async (req, res) => {
  try {
    const { rating, note } = req.body;
    const mood = await Mood.findOne({ _id: req.params.id, user: req.user._id });

    if (!mood) {
      return res.status(404).json({ message: 'Mood not found' });
    }

    mood.rating = rating;
    mood.note = note;
    await mood.save();

    res.json(mood);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get user's moods
router.get('/', auth, async (req, res) => {
  try {
    const moods = await Mood.find({ user: req.user._id })
      .sort({ createdAt: -1 })
      .limit(30); // Get last 30 days of moods

    res.json(moods);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get today's mood
router.get('/today', auth, async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const mood = await Mood.findOne({
      user: req.user._id,
      createdAt: {
        $gte: today,
      },
    });

    res.json(mood || { message: 'No mood recorded today' });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Get mood statistics
router.get('/stats', auth, async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const moods = await Mood.find({
      user: req.user._id,
      createdAt: { $gte: thirtyDaysAgo },
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
    res.status(400).json({ message: error.message });
  }
});

module.exports = router; 