const { Server } = require('socket.io');
const jwt = require('jsonwebtoken');
const admin = require('firebase-admin');

let io;

const initializeSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: process.env.FRONTEND_URL || "http://localhost:3000",
      methods: ["GET", "POST"]
    }
  });

  // Authentication middleware for Socket.IO
  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token;
      
      if (!token) {
        return next(new Error('Authentication error: No token provided'));
      }

      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      
      if (decoded.type !== 'access') {
        return next(new Error('Authentication error: Invalid token type'));
      }

      // Verify user exists
      const userDoc = await admin.firestore().collection('users').doc(decoded.userId).get();
      if (!userDoc.exists) {
        return next(new Error('Authentication error: User not found'));
      }

      socket.userId = decoded.userId;
      socket.userData = userDoc.data();
      next();
    } catch (error) {
      next(new Error('Authentication error: Invalid token'));
    }
  });

  io.on('connection', (socket) => {
    console.log(`User ${socket.userId} connected`);

    // Join user to their personal room
    socket.join(`user_${socket.userId}`);

    // Update user online status
    updateUserOnlineStatus(socket.userId, true);

    // Handle joining chat room
    socket.on('join_chat', async (data) => {
      try {
        const { matchId } = data;
        
        // Verify user is part of this match
        const matchDoc = await admin.firestore().collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
          socket.emit('error', { message: 'Match not found' });
          return;
        }

        const matchData = matchDoc.data();
        if (matchData.userId1 !== socket.userId && matchData.userId2 !== socket.userId) {
          socket.emit('error', { message: 'Unauthorized access to chat' });
          return;
        }

        // Join the chat room
        socket.join(`chat_${matchId}`);
        socket.currentChat = matchId;

        // Mark messages as read
        await markMessagesAsRead(matchId, socket.userId);

        socket.emit('joined_chat', { matchId });
      } catch (error) {
        console.error('Join chat error:', error);
        socket.emit('error', { message: 'Failed to join chat' });
      }
    });

    // Handle sending messages
    socket.on('send_message', async (data) => {
      try {
        const { matchId, content, type = 'text', replyToMessageId } = data;

        if (!socket.currentChat || socket.currentChat !== matchId) {
          socket.emit('error', { message: 'Not in this chat room' });
          return;
        }

        // Verify match exists and user is part of it
        const matchDoc = await admin.firestore().collection('matches').doc(matchId).get();
        if (!matchDoc.exists) {
          socket.emit('error', { message: 'Match not found' });
          return;
        }

        const matchData = matchDoc.data();
        const otherUserId = matchData.userId1 === socket.userId ? matchData.userId2 : matchData.userId1;

        // Create message document
        const messageData = {
          matchId,
          senderId: socket.userId,
          receiverId: otherUserId,
          content,
          type,
          replyToMessageId: replyToMessageId || null,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
          isRead: false
        };

        const messageRef = await admin.firestore().collection('messages').add(messageData);
        const messageId = messageRef.id;

        // Update match with last message
        await admin.firestore().collection('matches').doc(matchId).update({
          lastMessage: content,
          lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
          hasUnreadMessages: true,
          unreadCount: admin.firestore.FieldValue.increment(1)
        });

        // Emit message to chat room
        io.to(`chat_${matchId}`).emit('new_message', {
          id: messageId,
          ...messageData,
          timestamp: new Date().toISOString()
        });

        // Send push notification to other user if they're not online
        const otherUserSocket = await findUserSocket(otherUserId);
        if (!otherUserSocket) {
          // TODO: Send push notification
          console.log(`Sending push notification to user ${otherUserId}`);
        }

      } catch (error) {
        console.error('Send message error:', error);
        socket.emit('error', { message: 'Failed to send message' });
      }
    });

    // Handle typing indicators
    socket.on('typing_start', (data) => {
      const { matchId } = data;
      if (socket.currentChat === matchId) {
        socket.to(`chat_${matchId}`).emit('user_typing', {
          userId: socket.userId,
          isTyping: true
        });
      }
    });

    socket.on('typing_stop', (data) => {
      const { matchId } = data;
      if (socket.currentChat === matchId) {
        socket.to(`chat_${matchId}`).emit('user_typing', {
          userId: socket.userId,
          isTyping: false
        });
      }
    });

    // Handle message read status
    socket.on('mark_messages_read', async (data) => {
      try {
        const { matchId } = data;
        await markMessagesAsRead(matchId, socket.userId);
      } catch (error) {
        console.error('Mark messages read error:', error);
      }
    });

    // Handle disconnect
    socket.on('disconnect', () => {
      console.log(`User ${socket.userId} disconnected`);
      updateUserOnlineStatus(socket.userId, false);
    });
  });

  return io;
};

// Helper functions
const updateUserOnlineStatus = async (userId, isOnline) => {
  try {
    await admin.firestore().collection('users').doc(userId).update({
      isOnline,
      lastSeen: admin.firestore.FieldValue.serverTimestamp()
    });
  } catch (error) {
    console.error('Update online status error:', error);
  }
};

const markMessagesAsRead = async (matchId, userId) => {
  try {
    const messagesQuery = await admin.firestore()
      .collection('messages')
      .where('matchId', '==', matchId)
      .where('receiverId', '==', userId)
      .where('isRead', '==', false)
      .get();

    const batch = admin.firestore().batch();
    messagesQuery.docs.forEach(doc => {
      batch.update(doc.ref, { isRead: true });
    });

    await batch.commit();

    // Update match unread count
    await admin.firestore().collection('matches').doc(matchId).update({
      hasUnreadMessages: false,
      unreadCount: 0
    });

  } catch (error) {
    console.error('Mark messages as read error:', error);
  }
};

const findUserSocket = async (userId) => {
  const sockets = await io.fetchSockets();
  return sockets.find(socket => socket.userId === userId);
};

// Function to send notification to specific user
const sendNotificationToUser = (userId, notification) => {
  io.to(`user_${userId}`).emit('notification', notification);
};

module.exports = {
  initializeSocket,
  sendNotificationToUser
};
