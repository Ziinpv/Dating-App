import 'package:flutter/material.dart';
import 'auth_screen_simple.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Tìm kiếm tình yêu",
      description: "Khám phá những người phù hợp với bạn trong khu vực",
      image: Icons.favorite,
      color: const Color(0xFFFF6B6B),
    ),
    OnboardingData(
      title: "Kết nối thật",
      description: "Trò chuyện và tạo mối quan hệ ý nghĩa",
      image: Icons.chat,
      color: const Color(0xFF4ECDC4),
    ),
    OnboardingData(
      title: "Bắt đầu ngay",
      description: "Tạo hồ sơ và bắt đầu hành trình tìm kiếm tình yêu",
      image: Icons.rocket_launch,
      color: const Color(0xFF45B7D1),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.image,
              size: 100,
              color: data.color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF7F8C8D),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildDot(index),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                  );
                }
              },
              child: Text(
                _currentPage < _pages.length - 1 ? "Tiếp theo" : "Bắt đầu",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthScreen()),
            ),
            child: const Text(
              "Bỏ qua",
              style: TextStyle(
                color: Color(0xFF7F8C8D),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? const Color(0xFFFF6B6B)
            : const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
