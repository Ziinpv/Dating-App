import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.sampleUsers.length,
        itemBuilder: (context, index) {
          final user = SampleData.sampleUsers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: _getColorForUser(user.id),
                child: Text(
                  user.name.split(' ').last[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.age} tuổi • ${user.location}'),
                  const SizedBox(height: 4),
                  Text(
                    user.bio,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: user.isVerified
                  ? const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 20,
                    )
                  : null,
              onTap: () {
                _showUserDetail(context, user);
              },
            ),
          );
        },
      ),
    );
  }

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

  void _showUserDetail(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${user.age} tuổi • ${user.location}'),
            const SizedBox(height: 8),
            Text('Giới tính: ${user.gender}'),
            Text('Tìm kiếm: ${user.lookingFor}'),
            const SizedBox(height: 8),
            Text('Sở thích: ${user.interests.join(', ')}'),
            const SizedBox(height: 8),
            Text('Giới thiệu: ${user.bio}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to chat
            },
            child: const Text('Nhắn tin'),
          ),
        ],
      ),
    );
  }
}
