import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';
import '../widgets/swipe_card.dart';
import '../widgets/custom_button.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  List<UserModel> _potentialMatches = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPotentialMatches();
  }

  Future<void> _loadPotentialMatches() async {
    // TODO: Load from DatingService
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    
    setState(() {
      _potentialMatches = _generateMockUsers();
      _isLoading = false;
    });
  }

  List<UserModel> _generateMockUsers() {
    return [
      UserModel(
        id: '1',
        name: 'Anna',
        email: 'anna@example.com',
        age: 24,
        location: 'Đà Lạt, Lâm Đồng',
        bio: 'Yêu thích du lịch và nấu ăn. Tìm kiếm người bạn đồng hành trong cuộc sống.',
        photos: [
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400',
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
        ],
        interests: ['🎵 Âm nhạc', '✈️ Du lịch', '🍳 Nấu ăn'],
        gender: 'Nữ',
        lookingFor: 'Nam',
        latitude: 11.9404,
        longitude: 108.4583,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        id: '2',
        name: 'Minh',
        email: 'minh@example.com',
        age: 26,
        location: 'TP.HCM',
        bio: 'Lập trình viên, thích chơi game và xem phim. Tìm kiếm người bạn tâm sự.',
        photos: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
        interests: ['🎮 Game', '🎬 Phim', '☕ Cà phê'],
        gender: 'Nam',
        lookingFor: 'Nữ',
        latitude: 10.8231,
        longitude: 106.6297,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      UserModel(
        id: '3',
        name: 'Linh',
        email: 'linh@example.com',
        age: 23,
        location: 'Hà Nội',
        bio: 'Sinh viên, yêu thích đọc sách và yoga. Tìm kiếm người bạn chia sẻ sở thích.',
        photos: [
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        ],
        interests: ['📚 Đọc sách', '🧘‍♀️ Yoga', '🎨 Nghệ thuật'],
        gender: 'Nữ',
        lookingFor: 'Nam',
        latitude: 21.0285,
        longitude: 105.8542,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Khám phá',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF2C3E50)),
            onPressed: _showFilters,
          ),
          IconButton(
            icon: const Icon(Icons.diamond, color: Color(0xFFFF6B6B)),
            onPressed: _showPremium,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            )
          : _potentialMatches.isEmpty
              ? _buildEmptyState()
              : _buildSwipeInterface(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSwipeInterface() {
    return Stack(
      children: [
        // Swipe cards
        if (_currentIndex < _potentialMatches.length)
          Positioned.fill(
            child: SwipeCard(
              user: _potentialMatches[_currentIndex],
              onSwipeLeft: () => _handleSwipe(false),
              onSwipeRight: () => _handleSwipe(true),
              onSwipeUp: () => _handleSuperLike(),
            ),
          ),
        
        // Action buttons
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: _buildActionButtons(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Pass button
        GestureDetector(
          onTap: () => _handleSwipe(false),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.close,
              color: Colors.red,
              size: 30,
            ),
          ),
        ),
        
        // Super like button
        GestureDetector(
          onTap: _handleSuperLike,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.star,
              color: Colors.blue,
              size: 25,
            ),
          ),
        ),
        
        // Like button
        GestureDetector(
          onTap: () => _handleSwipe(true),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.green,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 60,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không còn ai để khám phá',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Hãy thử điều chỉnh bộ lọc hoặc kiểm tra lại sau',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Điều chỉnh bộ lọc',
              onPressed: _showFilters,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.explore, 'Khám phá', true),
              _buildNavItem(Icons.favorite, 'Matches', false),
              _buildNavItem(Icons.chat, 'Chat', false),
              _buildNavItem(Icons.person, 'Hồ sơ', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Matches':
            context.go('/matches');
            break;
          case 'Chat':
            context.go('/chat');
            break;
          case 'Hồ sơ':
            context.go('/profile');
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFFF6B6B) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFFF6B6B) : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSwipe(bool isLike) {
    if (_currentIndex < _potentialMatches.length) {
      // TODO: Send swipe to backend
      print('Swiped ${isLike ? 'like' : 'pass'} on ${_potentialMatches[_currentIndex].name}');
      
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _handleSuperLike() {
    if (_currentIndex < _potentialMatches.length) {
      // TODO: Send super like to backend
      print('Super liked ${_potentialMatches[_currentIndex].name}');
      
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFiltersSheet(),
    );
  }

  Widget _buildFiltersSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Bộ lọc tìm kiếm',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
          ),
          // TODO: Implement filters UI
          const Expanded(
            child: Center(
              child: Text('Filters coming soon...'),
            ),
          ),
        ],
      ),
    );
  }

  void _showPremium() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium'),
        content: const Text('Nâng cấp lên Premium để có thêm tính năng!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nâng cấp'),
          ),
        ],
      ),
    );
  }
}
