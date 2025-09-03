# 💕 Dating App - Ứng dụng hẹn hò trực tuyến

Ứng dụng hẹn hò trực tuyến được phát triển bằng Flutter và Node.js, giúp người dùng kết nối và tìm kiếm bạn bè hoặc đối tác tình cảm.

## 🚀 Tính năng chính

### Frontend (Flutter)
- ✅ **Onboarding Flow**: Hướng dẫn người dùng mới
- ✅ **Authentication**: Đăng ký/đăng nhập với email và SĐT
- ✅ **Profile Setup**: Tạo hồ sơ cá nhân với ảnh và sở thích
- ✅ **Discovery**: Swipe cards để tìm kiếm người phù hợp
- ✅ **Matching**: Thuật toán gợi ý thông minh
- 🔄 **Real-time Chat**: Trò chuyện trực tiếp với Socket.io
- 🔄 **Push Notifications**: Thông báo đẩy
- 🔄 **Video Call**: Gọi video trực tiếp

### Backend (Node.js + Express)
- ✅ **RESTful API**: API endpoints đầy đủ
- ✅ **Authentication**: JWT-based authentication
- ✅ **Real-time Communication**: Socket.io integration
- ✅ **Database**: Firebase Firestore
- ✅ **File Upload**: Cloudinary integration
- ✅ **Security**: Rate limiting, CORS, Helmet
- ✅ **Validation**: Joi validation schemas

## 🛠️ Công nghệ sử dụng

### Frontend
- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Go Router**: Navigation
- **Firebase**: Authentication, Firestore, Storage
- **Socket.io Client**: Real-time communication
- **Image Picker**: Photo selection
- **Cached Network Image**: Image caching

### Backend
- **Node.js**: Runtime environment
- **Express.js**: Web framework
- **Socket.io**: Real-time communication
- **Firebase Admin**: Backend Firebase integration
- **JWT**: Authentication tokens
- **Joi**: Data validation
- **Cloudinary**: Image storage and processing
- **Bcrypt**: Password hashing

## 📱 Cài đặt và chạy ứng dụng

### Yêu cầu hệ thống
- Flutter SDK >= 3.0.0
- Node.js >= 16.0.0
- Firebase project
- Cloudinary account (optional)

### 1. Clone repository
```bash
git clone <repository-url>
cd dating_app
```

### 2. Setup Backend
```bash
cd backend
npm install
cp env.example .env
# Cấu hình các biến môi trường trong .env
npm run dev
```

### 3. Setup Frontend
```bash
# Từ thư mục gốc
flutter pub get
flutter run
```

## 🔧 Cấu hình

### Firebase Setup
1. Tạo Firebase project
2. Enable Authentication (Email/Password, Phone)
3. Tạo Firestore database
4. Tạo Storage bucket
5. Download service account key
6. Cấu hình trong backend/.env

### Environment Variables
```env
# Backend
PORT=3000
JWT_SECRET=your-jwt-secret
FIREBASE_PROJECT_ID=your-project-id
# ... (xem env.example)

# Frontend
# Cấu hình trong lib/firebase_options.dart
```

## 📊 Cấu trúc dự án

```
dating_app/
├── lib/                    # Flutter source code
│   ├── models/            # Data models
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable widgets
│   ├── services/          # API services
│   ├── providers/         # State management
│   └── utils/             # Utility functions
├── backend/               # Node.js backend
│   ├── routes/           # API routes
│   ├── controllers/      # Route controllers
│   ├── middleware/       # Custom middleware
│   ├── models/           # Data models
│   ├── socket/           # Socket.io handlers
│   └── utils/            # Utility functions
└── assets/               # Images, fonts, etc.
```

## 🎯 API Endpoints

### Authentication
- `POST /api/auth/register` - Đăng ký tài khoản
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/refresh` - Làm mới token
- `POST /api/auth/logout` - Đăng xuất

### Users
- `GET /api/users/profile` - Lấy thông tin hồ sơ
- `PUT /api/users/profile` - Cập nhật hồ sơ
- `GET /api/users/matches` - Lấy danh sách matches
- `POST /api/users/swipe` - Swipe người dùng

### Chat
- `GET /api/chat/messages/:matchId` - Lấy tin nhắn
- `POST /api/chat/messages` - Gửi tin nhắn
- Socket events: `join_chat`, `send_message`, `typing_start`, etc.

## 🔒 Bảo mật

- JWT authentication với refresh tokens
- Rate limiting để chống spam
- Input validation với Joi
- CORS configuration
- Helmet security headers
- Password hashing với bcrypt

## 🚀 Deployment

### Backend (Heroku/Railway)
```bash
# Cấu hình environment variables
# Deploy với Git
git push heroku main
```

### Frontend (Google Play Store/App Store)
```bash
# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 📈 Roadmap

### Phase 1 (MVP) ✅
- [x] Authentication system
- [x] Profile creation
- [x] Swipe interface
- [x] Basic matching

### Phase 2 (Enhanced) 🔄
- [ ] Real-time chat
- [ ] Push notifications
- [ ] Advanced filters
- [ ] Photo verification

### Phase 3 (Premium) 📋
- [ ] Video calling
- [ ] Premium features
- [ ] Analytics dashboard
- [ ] AI-powered matching

## 🤝 Đóng góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👥 Team

- **Nguyễn Thị Hoàng Phúc** - 2213795@dlu.edu.vn
- **Hoàng Long** - 2212407@dlu.edu.vn  
- **Nguyễn Hoàng Sang** - 2212451@dlu.edu.vn

**Giảng viên hướng dẫn**: ThS. Đoàn Minh Khuê

## 📞 Liên hệ

Nếu có câu hỏi hoặc góp ý, vui lòng liên hệ qua email hoặc tạo issue trên GitHub.

---

**Lưu ý**: Đây là dự án đồ án chuyên ngành, chỉ dành cho mục đích học tập và nghiên cứu.
