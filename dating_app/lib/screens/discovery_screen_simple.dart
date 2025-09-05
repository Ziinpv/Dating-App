import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  late final List<ProfileCard> _profiles;

  Color _getColorForUser(String userId) {
    final colors = [
      Colors.pink,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];
    return colors[int.parse(userId) % colors.length];
  }

  @override
  void initState() {
    super.initState();
    _profiles = SampleData.sampleUsers.map((user) => ProfileCard(
      name: user.name,
      age: user.age,
      location: user.location,
      bio: user.bio,
      interests: user.interests,
      imageColor: _getColorForUser(user.id),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: _profiles.length,
              itemBuilder: (context, index) {
                return _buildProfileCard(_profiles[index]);
              },
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileCard(ProfileCard profile) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    profile.imageColor.withOpacity(0.8),
                    profile.imageColor.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${profile.name}, ${profile.age}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 20,
                        ),
                        Text(
                          profile.location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.bio,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: profile.interests.map((interest) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            interest,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: _handlePass,
          ),
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            onPressed: _handleSuperLike,
          ),
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.pink,
            onPressed: _handleLike,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  void _handlePass() {
    _nextProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã bỏ qua'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleSuperLike() {
    _nextProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Super Like!'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _handleLike() {
    _nextProfile();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thích!'),
        backgroundColor: Colors.pink,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _nextProfile() {
    if (_currentIndex < _profiles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // No more profiles
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không còn hồ sơ nào để xem. Hãy thử lại sau!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bộ lọc'),
        content: const Text('Tính năng bộ lọc sẽ được phát triển trong phiên bản tiếp theo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}

class ProfileCard {
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final Color imageColor;

  ProfileCard({
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.imageColor,
  });
}
