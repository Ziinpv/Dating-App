import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service_simple.dart';
import 'profile_setup_screen_simple.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildForm(),
              const SizedBox(height: 30),
              _buildToggleAuth(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFFFF6B6B),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 50,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isLogin ? "Chào mừng trở lại!" : "Tạo tài khoản mới",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          _isLogin 
            ? "Đăng nhập để tiếp tục hành trình tìm kiếm tình yêu"
            : "Điền thông tin để bắt đầu tìm kiếm người phù hợp",
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              const Text(
                '🎉 Tài khoản Demo có sẵn:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Email: demo@datingapp.com\nMật khẩu: 123456',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C3E50),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Hoặc nhập bất kỳ email/password nào để đăng nhập!',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7F8C8D),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (!_isLogin) ...[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Họ và tên",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập họ và tên";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập email";
              }
              if (!value.contains('@')) {
                return "Email không hợp lệ";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Mật khẩu",
              prefixIcon: Icon(Icons.lock),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập mật khẩu";
              }
              if (value.length < 6) {
                return "Mật khẩu phải có ít nhất 6 ký tự";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleAuth,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isLogin ? "Đăng nhập" : "Đăng ký",
                      style: const TextStyle(fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isLogin ? "Chưa có tài khoản? " : "Đã có tài khoản? ",
          style: const TextStyle(color: Color(0xFF7F8C8D)),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin ? "Đăng ký ngay" : "Đăng nhập",
            style: const TextStyle(
              color: Color(0xFFFF6B6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      bool success;

      if (_isLogin) {
        success = await authService.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        success = await authService.signUp(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      if (success) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _isLogin 
                  ? "Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin."
                  : "Đăng ký thất bại. Vui lòng thử lại.",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Có lỗi xảy ra: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
