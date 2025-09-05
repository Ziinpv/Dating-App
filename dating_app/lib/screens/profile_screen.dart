import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SampleData.currentUser;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(user),
            _buildProfileInfo(user),
            _buildInterests(user),
            _buildPersonality(),
            _buildLifestyle(),
            _buildGoals(),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFF8E8E),
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: const Color(0xFFFF6B6B),
                  child: Text(
                    user.name.split(' ').last[0],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${user.age} tuổi • ${user.location}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          if (user.isVerified) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 20,
                ),
                SizedBox(width: 4),
                Text(
                  'Đã xác thực',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileInfo(user) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.bio,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Giới tính', user.gender),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Tìm kiếm', user.lookingFor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Chiều cao', SampleData.demoProfileDetails['height']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Cung hoàng đạo', SampleData.demoProfileDetails['zodiac']),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Nghề nghiệp', SampleData.demoProfileDetails['job']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Học vấn', SampleData.demoProfileDetails['education']),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard('Hút thuốc', SampleData.demoProfileDetails['smoking']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard('Uống rượu', SampleData.demoProfileDetails['drinking']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterests(user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sở thích',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonality() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tính cách',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (SampleData.demoProfileDetails['personality'] as List<String>).map<Widget>((trait) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Text(
                  trait,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyle() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lối sống',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildLifestyleItem('Thức dậy', SampleData.demoProfileDetails['lifestyle']['wakeUpTime']),
          _buildLifestyleItem('Đi ngủ', SampleData.demoProfileDetails['lifestyle']['bedTime']),
          _buildLifestyleItem('Tập thể dục', SampleData.demoProfileDetails['lifestyle']['workoutFrequency']),
          _buildLifestyleItem('Mạng xã hội', SampleData.demoProfileDetails['lifestyle']['socialMedia']),
          _buildLifestyleItem('Phong cách hẹn hò', SampleData.demoProfileDetails['lifestyle']['datingStyle']),
        ],
      ),
    );
  }

  Widget _buildLifestyleItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGoals() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mục tiêu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...(SampleData.demoProfileDetails['goals'] as List<String>).map<Widget>((goal) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFFF6B6B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showEditProfile(context);
              },
              icon: const Icon(Icons.edit),
              label: const Text('Chỉnh sửa hồ sơ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showSettings(context);
              },
              icon: const Icon(Icons.settings),
              label: const Text('Cài đặt'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B6B),
                side: const BorderSide(color: Color(0xFFFF6B6B)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa hồ sơ'),
        content: const Text('Tính năng chỉnh sửa hồ sơ sẽ được phát triển trong phiên bản tiếp theo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cài đặt'),
        content: const Text('Tính năng cài đặt sẽ được phát triển trong phiên bản tiếp theo.'),
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
