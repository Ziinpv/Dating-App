import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/onboarding_screen_simple.dart';
import 'screens/main_navigation_screen.dart';
import 'services/auth_service_simple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const DatingApp());
}

class DatingApp extends StatelessWidget {
  const DatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Dating App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: const Color(0xFFFF6B6B),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF2C3E50),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isLoggedIn) {
          return const MainNavigationScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}