import 'package:flutter/material.dart';
import '../data/sample_data.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.sampleUsers.length,
        itemBuilder: (context, index) {
          final user = SampleData.sampleUsers[index];
          final lastMessage = _getLastMessage(user.name);
          final timeAgo = _getTimeAgo(user.lastSeen ?? DateTime.now());
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: _getColorForUser(user.id),
                child: Text(
                  user.name.split(' ').last[0],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (user.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ],
              ),
              subtitle: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (index < 3) // Simulate unread messages
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B6B),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                _showChatDetail(context, user);
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

  String _getLastMessage(String userName) {
    final messages = [
      'Xin chào! Bạn có khỏe không?',
      'Hôm nay thời tiết đẹp quá nhỉ!',
      'Bạn có muốn đi cafe không?',
      'Cảm ơn bạn đã match với mình 😊',
      'Bạn thích loại nhạc gì?',
      'Tôi cũng thích du lịch lắm!',
    ];
    return messages[userName.hashCode % messages.length];
  }

  String _getTimeAgo(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  void _showChatDetail(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: _getColorForUser(user.id),
              child: Text(
                user.name.split(' ').last[0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Đang hoạt động',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildMessage('Xin chào! Bạn có khỏe không?', true),
                    _buildMessage('Mình khỏe, cảm ơn bạn! Bạn thế nào?', false),
                    _buildMessage('Mình cũng khỏe, hôm nay thời tiết đẹp quá nhỉ!', true),
                    _buildMessage('Đúng rồi, có muốn đi cafe không?', false),
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFFF6B6B) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
