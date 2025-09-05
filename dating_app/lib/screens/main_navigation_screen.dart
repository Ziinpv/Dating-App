import 'package:flutter/material.dart';
import 'discovery_screen_simple.dart';
import 'matches_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const DiscoveryScreen(),
      const MatchesScreen(),
      const ChatScreen(),
      const ProfileScreen(),
    ];
  }

  AppBar? _getAppBar() {
    switch (_currentIndex) {
      case 0: // Khám phá
        return AppBar(
          title: const Text('Khám phá'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Add filter functionality
              },
            ),
          ],
        );
      case 1: // Matches
        return AppBar(
          title: const Text('Matches'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
        );
      case 2: // Chat
        return AppBar(
          title: const Text('Tin nhắn'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
        );
      case 3: // Hồ sơ
        return AppBar(
          title: const Text('Hồ sơ'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFF6B6B),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Add edit profile functionality
              },
            ),
          ],
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFFF6B6B),
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            activeIcon: Icon(Icons.explore),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
      ),
    );
  }
}
