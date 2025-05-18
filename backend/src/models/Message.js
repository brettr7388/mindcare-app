const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    content: {
      type: String,
      required: true,
      trim: true,
    },
    isUser: {
      type: Boolean,
      required: true,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Index for efficient querying of user's messages
messageSchema.index({ user: 1, createdAt: -1 });

const Message = mongoose.model('Message', messageSchema);

module.exports = Message; 