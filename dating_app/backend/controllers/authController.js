const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const admin = require('firebase-admin');

// Get Firestore instance (will be null if Firebase not initialized)
const getDb = () => {
  try {
    return admin.firestore();
  } catch (error) {
    console.warn('Firebase not initialized:', error.message);
    return null;
  }
};

// Generate JWT tokens
const generateTokens = (userId) => {
  const accessToken = jwt.sign(
    { userId, type: 'access' },
    process.env.JWT_SECRET,
    { expiresIn: '15m' }
  );
  
  const refreshToken = jwt.sign(
    { userId, type: 'refresh' },
    process.env.JWT_REFRESH_SECRET,
    { expiresIn: '7d' }
  );
  
  return { accessToken, refreshToken };
};

// Register new user
const register = async (req, res) => {
  try {
    const db = getDb();
    if (!db) {
      return res.status(503).json({
        success: false,
        message: 'Database service unavailable. Please configure Firebase.'
      });
    }

    const { name, email, password, phoneNumber } = req.body;

    // Check if user already exists
    const existingUser = await db.collection('users').where('email', '==', email).get();
    if (!existingUser.empty) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email'
      });
    }

    // Hash password
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    // Create user document
    const userData = {
      name,
      email,
      password: hashedPassword,
      phoneNumber: phoneNumber || null,
      age: 0,
      location: '',
      bio: '',
      photos: [],
      interests: [],
      gender: '',
      lookingFor: '',
      isVerified: false,
      isOnline: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };

    const userRef = await db.collection('users').add(userData);
    const userId = userRef.id;

    // Generate tokens
    const { accessToken, refreshToken } = generateTokens(userId);

    // Store refresh token
    await db.collection('refreshTokens').doc(userId).set({
      token: refreshToken,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        user: {
          id: userId,
          name,
          email,
          phoneNumber,
          isVerified: false
        },
        accessToken,
        refreshToken
      }
    });

  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Login user
const login = async (req, res) => {
  try {
    const db = getDb();
    if (!db) {
      return res.status(503).json({
        success: false,
        message: 'Database service unavailable. Please configure Firebase.'
      });
    }

    const { email, password } = req.body;

    // Find user by email
    const userQuery = await db.collection('users').where('email', '==', email).get();
    
    if (userQuery.empty) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }

    const userDoc = userQuery.docs[0];
    const userData = userDoc.data();
    const userId = userDoc.id;

    // Verify password
    const isValidPassword = await bcrypt.compare(password, userData.password);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Invalid email or password'
      });
    }

    // Update last login
    await db.collection('users').doc(userId).update({
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
      isOnline: true
    });

    // Generate tokens
    const { accessToken, refreshToken } = generateTokens(userId);

    // Store refresh token
    await db.collection('refreshTokens').doc(userId).set({
      token: refreshToken,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // Remove password from response
    const { password: _, ...userWithoutPassword } = userData;

    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: {
          id: userId,
          ...userWithoutPassword
        },
        accessToken,
        refreshToken
      }
    });

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Verify token
const verifyToken = async (req, res) => {
  try {
    const db = getDb();
    if (!db) {
      return res.status(503).json({
        success: false,
        message: 'Database service unavailable. Please configure Firebase.'
      });
    }

    const userId = req.user.userId;
    
    const userDoc = await db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    const userData = userDoc.data();
    const { password, ...userWithoutPassword } = userData;

    res.json({
      success: true,
      data: {
        user: {
          id: userId,
          ...userWithoutPassword
        }
      }
    });

  } catch (error) {
    console.error('Token verification error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

// Refresh token
const refreshToken = async (req, res) => {
  try {
    const db = getDb();
    if (!db) {
      return res.status(503).json({
        success: false,
        message: 'Database service unavailable. Please configure Firebase.'
      });
    }

    const { refreshToken } = req.body;

    if (!refreshToken) {
      return res.status(401).json({
        success: false,
        message: 'Refresh token required'
      });
    }

    // Verify refresh token
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    
    if (decoded.type !== 'refresh') {
      return res.status(401).json({
        success: false,
        message: 'Invalid token type'
      });
    }

    const userId = decoded.userId;

    // Check if refresh token exists in database
    const tokenDoc = await db.collection('refreshTokens').doc(userId).get();
    if (!tokenDoc.exists || tokenDoc.data().token !== refreshToken) {
      return res.status(401).json({
        success: false,
        message: 'Invalid refresh token'
      });
    }

    // Generate new tokens
    const { accessToken, refreshToken: newRefreshToken } = generateTokens(userId);

    // Update refresh token in database
    await db.collection('refreshTokens').doc(userId).set({
      token: newRefreshToken,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    res.json({
      success: true,
      data: {
        accessToken,
        refreshToken: newRefreshToken
      }
    });

  } catch (error) {
    console.error('Token refresh error:', error);
    res.status(401).json({
      success: false,
      message: 'Invalid refresh token'
    });
  }
};

// Logout
const logout = async (req, res) => {
  try {
    const db = getDb();
    if (!db) {
      return res.status(503).json({
        success: false,
        message: 'Database service unavailable. Please configure Firebase.'
      });
    }

    const userId = req.user.userId;

    // Remove refresh token
    await db.collection('refreshTokens').doc(userId).delete();

    // Update user online status
    await db.collection('users').doc(userId).update({
      isOnline: false,
      lastSeen: admin.firestore.FieldValue.serverTimestamp()
    });

    res.json({
      success: true,
      message: 'Logout successful'
    });

  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

module.exports = {
  register,
  login,
  verifyToken,
  refreshToken,
  logout
};
