import 'package:flutter/material.dart';
import '../data/sample_data.dart';
import 'main_navigation_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedGender = 'Nam';
  String _selectedLookingFor = 'Nữ';
  List<String> _selectedInterests = [];

  final List<String> _interests = SampleData.sampleInterests;
  final List<String> _locations = SampleData.sampleLocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thiết lập hồ sơ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildBasicInfo(),
              const SizedBox(height: 30),
              _buildInterests(),
              const SizedBox(height: 40),
              _buildContinueButton(),
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
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF6B6B),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person_add,
            size: 60,
            color: Color(0xFFFF6B6B),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Tạo hồ sơ của bạn',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Chia sẻ thông tin về bản thân để tìm được người phù hợp',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7F8C8D),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin cơ bản',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Họ và tên',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập họ và tên';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Tuổi',
            prefixIcon: Icon(Icons.cake),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tuổi';
            }
            if (int.tryParse(value) == null) {
              return 'Tuổi phải là số';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Giới tính',
                  prefixIcon: Icon(Icons.person),
                ),
                items: ['Nam', 'Nữ', 'Khác'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedLookingFor,
                decoration: const InputDecoration(
                  labelText: 'Tìm kiếm',
                  prefixIcon: Icon(Icons.search),
                ),
                items: ['Nam', 'Nữ', 'Tất cả'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLookingFor = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _locationController.text.isNotEmpty ? _locationController.text : null,
          decoration: const InputDecoration(
            labelText: 'Vị trí',
            prefixIcon: Icon(Icons.location_on),
          ),
          items: _locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _locationController.text = newValue ?? '';
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng chọn vị trí';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bioController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Giới thiệu về bản thân',
            prefixIcon: Icon(Icons.description),
            hintText: 'Hãy chia sẻ một chút về bản thân...',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng viết giới thiệu về bản thân';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sở thích',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInterests.add(interest);
                  } else {
                    _selectedInterests.remove(interest);
                  }
                });
              },
              selectedColor: const Color(0xFFFF6B6B).withOpacity(0.2),
              checkmarkColor: const Color(0xFFFF6B6B),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleContinue,
        child: const Text(
          'Hoàn thành',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất một sở thích'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate saving profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hồ sơ đã được lưu thành công!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to discovery screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
