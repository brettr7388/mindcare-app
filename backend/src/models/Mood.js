const mongoose = require('mongoose');

const moodSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
    },
    timestamp: {
      type: Date,
      default: Date.now
    }
  },
  {
    timestamps: true,
  }
);

// Index for efficient querying of user's moods
moodSchema.index({ user: 1, createdAt: -1 });

const Mood = mongoose.model('Mood', moodSchema);

module.exports = Mood; 