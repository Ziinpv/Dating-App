const express = require('express');
const { register, login, verifyToken, refreshToken, logout } = require('../controllers/authController');
const { validateRegister, validateLogin } = require('../middleware/validation');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// Public routes
router.post('/register', validateRegister, register);
router.post('/login', validateLogin, login);
router.post('/refresh', refreshToken);

// Protected routes
router.post('/verify', authenticateToken, verifyToken);
router.post('/logout', authenticateToken, logout);

module.exports = router;
