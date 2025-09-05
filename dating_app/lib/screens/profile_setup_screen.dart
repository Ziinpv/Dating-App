
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  // Image picker removed - using simple version

  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();

  // Form data
  final List<File> _photos = [];
  final List<String> _selectedInterests = [];
  String _selectedGender = '';
  String _lookingFor = '';

  final List<String> _interests = [
    '🎵 Âm nhạc',
    '📚 Đọc sách',
    '⚽ Thể thao',
    '🎮 Game',
    '🍳 Nấu ăn',
    '✈️ Du lịch',
    '🎨 Nghệ thuật',
    '🎬 Phim',
    '🐕 Thú cưng',
    '☕ Cà phê',
    '🏃‍♀️ Chạy bộ',
    '🧘‍♀️ Yoga',
    '🎯 Bắn cung',
    '🏊‍♀️ Bơi lội',
    '🎤 Karaoke',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bước ${_currentStep + 1}/4'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
            ),
          ),
          
          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                _buildPhotoStep(),
                _buildBasicInfoStep(),
                _buildInterestsStep(),
                _buildPreferencesStep(),
              ],
            ),
          ),
          
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: CustomButton(
                      text: 'Quay lại',
                      backgroundColor: Colors.white,
                      textColor: const Color(0xFF2C3E50),
                      borderColor: Colors.grey.shade300,
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: _currentStep == 3 ? 'Hoàn thành' : 'Tiếp tục',
                    onPressed: _canProceed() ? _handleNext : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thêm ảnh của bạn',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ảnh đại diện giúp tăng 10x khả năng được like',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          
          // Photo grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                if (index < _photos.length) {
                  return _buildPhotoCard(_photos[index], index);
                } else {
                  return _buildAddPhotoCard();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(File photo, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: FileImage(photo),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _photos.removeAt(index);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          if (index == 0)
            const Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                'Ảnh chính',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Thêm ảnh',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu về bản thân',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 32),
          
          CustomTextField(
            controller: _nameController,
            label: 'Tên',
            icon: Icons.person_outline,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _ageController,
            label: 'Tuổi',
            icon: Icons.cake_outlined,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _locationController,
            label: 'Vị trí',
            icon: Icons.location_on_outlined,
          ),
          
          const SizedBox(height: 16),
          
          CustomTextField(
            controller: _bioController,
            label: 'Giới thiệu ngắn (Tối đa 500 ký tự)',
            icon: Icons.edit_outlined,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sở thích của bạn',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chọn ít nhất 3 sở thích: ${_selectedInterests.length}/3',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: _interests.length,
              itemBuilder: (context, index) {
                final interest = _interests[index];
                final isSelected = _selectedInterests.contains(interest);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else if (_selectedInterests.length < 10) {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? const Color(0xFFFF6B6B) 
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? const Color(0xFFFF6B6B) 
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tùy chọn tìm kiếm',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 32),
          
          const Text(
            'Giới tính của bạn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildGenderOption('Nam', '👨'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGenderOption('Nữ', '👩'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            'Tìm kiếm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildLookingForOption('Nam', '👨'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLookingForOption('Nữ', '👩'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLookingForOption('Tất cả', '👥'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, String emoji) {
    final isSelected = _selectedGender == gender;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFFFF6B6B) 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFFFF6B6B) 
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLookingForOption(String option, String emoji) {
    final isSelected = _lookingFor == option;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _lookingFor = option;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF4ECDC4) 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF4ECDC4) 
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              option,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _photos.isNotEmpty;
      case 1:
        return _nameController.text.isNotEmpty &&
               _ageController.text.isNotEmpty &&
               _locationController.text.isNotEmpty;
      case 2:
        return _selectedInterests.length >= 3;
      case 3:
        return _selectedGender.isNotEmpty && _lookingFor.isNotEmpty;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeProfile();
    }
  }

  Future<void> _pickImage() async {
    try {
      // Image picking removed - using simple version
      // Simulate adding a photo
      setState(() {
        // _photos.add(File('placeholder'));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn ảnh: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _completeProfile() async {
    // TODO: Implement profile completion logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hồ sơ đã được tạo thành công!'),
        backgroundColor: Colors.green,
      ),
    );
    
    if (mounted) {
      context.go('/discovery');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
