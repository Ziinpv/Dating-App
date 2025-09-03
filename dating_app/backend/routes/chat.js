const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');

// Get chat messages
router.get('/messages/:matchId', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Chat messages endpoint - Firebase not configured',
    data: {
      messages: [],
      message: 'Configure Firebase to get chat messages'
    }
  });
});

// Send a message
router.post('/messages', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Send message endpoint - Firebase not configured',
    data: {
      message: 'Configure Firebase to send messages'
    }
  });
});

// Get chat list
router.get('/list', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Chat list endpoint - Firebase not configured',
    data: {
      chats: [],
      message: 'Configure Firebase to get chat list'
    }
  });
});

module.exports = router;
