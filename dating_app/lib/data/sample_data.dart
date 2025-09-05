import '../models/user_model.dart';

class SampleData {
  static final List<UserModel> sampleUsers = [
    UserModel(
      id: '1',
      name: 'Nguyễn Thị Mai',
      email: 'mai.nguyen@example.com',
      age: 25,
      location: 'Hà Nội',
      bio: 'Yêu thích du lịch và khám phá những điều mới mẻ. Tìm kiếm người bạn đồng hành trong cuộc sống.',
      photos: [
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      ],
      interests: ['Du lịch', 'Nhiếp ảnh', 'Nấu ăn', 'Đọc sách'],
      gender: 'Nữ',
      lookingFor: 'Nam',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserModel(
      id: '2',
      name: 'Trần Văn Nam',
      email: 'nam.tran@example.com',
      age: 28,
      location: 'TP.HCM',
      bio: 'Kỹ sư phần mềm, yêu thích thể thao và âm nhạc. Mong muốn tìm được người bạn tâm giao.',
      photos: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      ],
      interests: ['Thể thao', 'Âm nhạc', 'Công nghệ', 'Chạy bộ'],
      gender: 'Nam',
      lookingFor: 'Nữ',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    UserModel(
      id: '3',
      name: 'Lê Thị Hương',
      email: 'huong.le@example.com',
      age: 23,
      location: 'Đà Nẵng',
      bio: 'Sinh viên ngành thiết kế, sáng tạo và đam mê nghệ thuật. Tìm kiếm tình yêu chân thành.',
      photos: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      ],
      interests: ['Vẽ', 'Thiết kế', 'Xem phim', 'Mua sắm'],
      gender: 'Nữ',
      lookingFor: 'Nam',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      isVerified: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    UserModel(
      id: '4',
      name: 'Phạm Minh Tuấn',
      email: 'tuan.pham@example.com',
      age: 30,
      location: 'Hải Phòng',
      bio: 'Bác sĩ, yêu thích đọc sách và chạy bộ. Tìm kiếm người bạn đời để chia sẻ cuộc sống.',
      photos: [
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
      ],
      interests: ['Đọc sách', 'Chạy bộ', 'Y học', 'Du lịch'],
      gender: 'Nam',
      lookingFor: 'Nữ',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(days: 1)),
    ),
    UserModel(
      id: '5',
      name: 'Hoàng Thị Linh',
      email: 'linh.hoang@example.com',
      age: 26,
      location: 'Cần Thơ',
      bio: 'Giáo viên tiếng Anh, năng động và yêu thích giao lưu. Tìm kiếm mối quan hệ nghiêm túc.',
      photos: [
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400',
        'https://images.unsplash.com/photo-1531123897727-8f129e168dce?w=400',
      ],
      interests: ['Giáo dục', 'Ngôn ngữ', 'Khiêu vũ', 'Du lịch'],
      gender: 'Nữ',
      lookingFor: 'Nam',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      isVerified: true,
      lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    UserModel(
      id: '6',
      name: 'Vũ Đức Anh',
      email: 'anh.vu@example.com',
      age: 29,
      location: 'Nha Trang',
      bio: 'Chủ nhà hàng, đam mê ẩm thực và du lịch. Tìm kiếm người bạn đồng hành trong cuộc sống.',
      photos: [
        'https://images.unsplash.com/photo-1507591064344-4c6ce005b128?w=400',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      ],
      interests: ['Ẩm thực', 'Du lịch', 'Kinh doanh', 'Thể thao'],
      gender: 'Nam',
      lookingFor: 'Nữ',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      isVerified: false,
      lastSeen: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  static final UserModel currentUser = UserModel(
    id: 'current_user',
    name: 'Nguyễn Văn Demo',
    email: 'demo@datingapp.com',
    age: 26,
    location: 'TP.HCM',
    bio: 'Kỹ sư phần mềm với 3 năm kinh nghiệm, đam mê công nghệ và du lịch. Tìm kiếm người bạn đồng hành để chia sẻ những chuyến phiêu lưu và tạo ra những kỷ niệm đẹp trong cuộc sống. Yêu thích nấu ăn, chơi guitar và khám phá những quán cafe mới.',
    photos: [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
    ],
    interests: [
      'Công nghệ', 'Du lịch', 'Nấu ăn', 'Âm nhạc', 'Chơi guitar',
      'Đọc sách', 'Chạy bộ', 'Xem phim', 'Cafe', 'Nhiếp ảnh'
    ],
    gender: 'Nam',
    lookingFor: 'Nữ',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
    isVerified: true,
    lastSeen: DateTime.now(),
  );

  static final List<String> sampleInterests = [
    'Du lịch', 'Âm nhạc', 'Thể thao', 'Nấu ăn', 'Đọc sách',
    'Xem phim', 'Khiêu vũ', 'Nhiếp ảnh', 'Vẽ', 'Chạy bộ',
    'Yoga', 'Bơi lội', 'Công nghệ', 'Kinh doanh', 'Nghệ thuật',
    'Thiên nhiên', 'Mua sắm', 'Học ngoại ngữ', 'Chơi game', 'Tình nguyện'
  ];

  static final List<String> sampleLocations = [
    'Hà Nội', 'TP.HCM', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ',
    'Nha Trang', 'Huế', 'Vũng Tàu', 'Quảng Ninh', 'Bình Dương'
  ];

  // Thông tin bổ sung cho hồ sơ demo
  static final Map<String, dynamic> demoProfileDetails = {
    'height': '175 cm',
    'education': 'Đại học Bách Khoa TP.HCM',
    'job': 'Kỹ sư phần mềm',
    'company': 'TechCorp Vietnam',
    'salary': '15-20 triệu',
    'smoking': 'Không hút thuốc',
    'drinking': 'Thỉnh thoảng',
    'religion': 'Không',
    'zodiac': 'Cự Giải',
    'languages': ['Tiếng Việt', 'Tiếng Anh', 'Tiếng Nhật'],
    'hobbies': [
      'Chơi guitar acoustic',
      'Nấu các món ăn Việt Nam',
      'Chạy bộ công viên',
      'Đọc sách self-help',
      'Khám phá quán cafe mới',
      'Chụp ảnh phong cảnh'
    ],
    'personality': [
      'Hài hước',
      'Lãng mạn',
      'Chân thành',
      'Năng động',
      'Sáng tạo',
      'Tích cực'
    ],
    'lookingFor': [
      'Người chân thành',
      'Có sở thích tương đồng',
      'Thích du lịch',
      'Có mục tiêu trong cuộc sống',
      'Tôn trọng lẫn nhau'
    ],
    'dealBreakers': [
      'Không chân thành',
      'Thiếu tôn trọng',
      'Không có mục tiêu',
      'Quá tiêu cực'
    ],
    'favoritePlaces': [
      'Quán cafe ẩn',
      'Bãi biển Vũng Tàu',
      'Phố cổ Hội An',
      'Công viên Tao Đàn',
      'Nhà hàng Nhật Bản'
    ],
    'favoriteMovies': [
      'The Pursuit of Happyness',
      'La La Land',
      'Your Name',
      'Inception',
      'The Social Network'
    ],
    'favoriteMusic': [
      'Acoustic',
      'Indie',
      'Jazz',
      'Pop',
      'EDM'
    ],
    'favoriteFoods': [
      'Phở',
      'Sushi',
      'Pizza',
      'Bún bò Huế',
      'Bánh mì'
    ],
    'travelExperiences': [
      'Đã đi 15 tỉnh thành Việt Nam',
      'Tham quan Nhật Bản 2 lần',
      'Du lịch Thái Lan',
      'Khám phá Đà Lạt',
      'Nghỉ dưỡng Phú Quốc'
    ],
    'goals': [
      'Học thêm tiếng Nhật',
      'Du lịch châu Âu',
      'Mua nhà riêng',
      'Phát triển sự nghiệp',
      'Tìm được người yêu lý tưởng'
    ],
    'lifestyle': {
      'wakeUpTime': '6:30 AM',
      'bedTime': '11:00 PM',
      'workoutFrequency': '3-4 lần/tuần',
      'socialMedia': 'Instagram, Facebook',
      'datingStyle': 'Truyền thống kết hợp hiện đại'
    }
  };
}
