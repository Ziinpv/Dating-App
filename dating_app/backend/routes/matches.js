const express = require('express');
const router = express.Router();
const { authenticateToken } = require('../middleware/auth');

// Get user matches
router.get('/', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Matches endpoint - Firebase not configured',
    data: {
      matches: [],
      message: 'Configure Firebase to get user matches'
    }
  });
});

// Like a user
router.post('/like', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Like user endpoint - Firebase not configured',
    data: {
      message: 'Configure Firebase to like users'
    }
  });
});

// Dislike a user
router.post('/dislike', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Dislike user endpoint - Firebase not configured',
    data: {
      message: 'Configure Firebase to dislike users'
    }
  });
});

// Super like a user
router.post('/superlike', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Super like endpoint - Firebase not configured',
    data: {
      message: 'Configure Firebase to super like users'
    }
  });
});

module.exports = router;
