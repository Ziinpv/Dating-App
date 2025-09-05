import 'package:flutter/material.dart';
import '../models/user_model.dart';

class SwipeCard extends StatefulWidget {
  final UserModel user;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeUp;

  const SwipeCard({
    super.key,
    required this.user,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onSwipeUp,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  double _dragStartX = 0;
  double _dragStartY = 0;
  double _currentX = 0;
  double _currentY = 0;
  int _currentPhotoIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_currentX, _currentY),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        _buildPhotoStack(),
                        _buildGradientOverlay(),
                        _buildUserInfo(),
                        _buildActionButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoStack() {
    return PageView.builder(
      onPageChanged: (index) {
        setState(() {
          _currentPhotoIndex = index;
        });
      },
      itemCount: widget.user.photos.length,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person,
            size: 100,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.user.name}, ${widget.user.age}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                widget.user.location,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.user.bio,
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
            children: widget.user.interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: widget.onSwipeLeft,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            onPressed: widget.onSwipeUp,
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.pink,
            onPressed: widget.onSwipeRight,
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
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartX = details.globalPosition.dx;
    _dragStartY = details.globalPosition.dy;
    _animationController.forward();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentX = details.globalPosition.dx - _dragStartX;
      _currentY = details.globalPosition.dy - _dragStartY;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _animationController.reverse();

    const double threshold = 100;
    if (_currentX.abs() > threshold) {
      if (_currentX > 0) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    } else if (_currentY < -threshold) {
      widget.onSwipeUp();
    } else {
      setState(() {
        _currentX = 0;
        _currentY = 0;
      });
    }
  }
}
