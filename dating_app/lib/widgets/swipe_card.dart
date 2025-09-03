import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  late Animation<Offset> _positionAnimation;

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
      end: 0.95,
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

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
            child: Transform.rotate(
              angle: _rotationAnimation.value * (_currentX / 100),
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildCardContent(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    return Stack(
      children: [
        // Photo carousel
        _buildPhotoCarousel(),
        
        // Gradient overlay
        _buildGradientOverlay(),
        
        // User info
        _buildUserInfo(),
        
        // Photo indicators
        _buildPhotoIndicators(),
        
        // Swipe indicators
        _buildSwipeIndicators(),
      ],
    );
  }

  Widget _buildPhotoCarousel() {
    return PageView.builder(
      onPageChanged: (index) {
        setState(() {
          _currentPhotoIndex = index;
        });
      },
      itemCount: widget.user.photos.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: widget.user.photos[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(
                Icons.person,
                size: 80,
                color: Colors.grey,
              ),
            ),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black54,
              Colors.black87,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${widget.user.name}, ${widget.user.age}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.user.isVerified) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.verified,
                    color: Colors.blue,
                    size: 24,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 16,
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
            const SizedBox(height: 12),
            _buildInterests(),
          ],
        ),
      ),
    );
  }

  Widget _buildInterests() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.user.interests.take(4).map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            interest,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhotoIndicators() {
    if (widget.user.photos.length <= 1) return const SizedBox.shrink();

    return Positioned(
      top: 24,
      left: 24,
      right: 24,
      child: Row(
        children: List.generate(
          widget.user.photos.length,
          (index) => Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                right: index < widget.user.photos.length - 1 ? 4 : 0,
              ),
              decoration: BoxDecoration(
                color: index == _currentPhotoIndex
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeIndicators() {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        children: [
          // Left indicator (Pass)
          Expanded(
            child: AnimatedOpacity(
              opacity: _currentX < -50 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        'PASS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Right indicator (Like)
          Expanded(
            child: AnimatedOpacity(
              opacity: _currentX > 50 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text(
                        'LIKE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
    const double velocityThreshold = 500;

    // Check horizontal swipe
    if (_currentX.abs() > threshold || 
        details.velocity.pixelsPerSecond.dx.abs() > velocityThreshold) {
      if (_currentX > 0) {
        widget.onSwipeRight();
      } else {
        widget.onSwipeLeft();
      }
    }
    // Check vertical swipe up (Super Like)
    else if (_currentY < -threshold || 
             details.velocity.pixelsPerSecond.dy < -velocityThreshold) {
      widget.onSwipeUp();
    }
    // Return to center
    else {
      setState(() {
        _currentX = 0;
        _currentY = 0;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
