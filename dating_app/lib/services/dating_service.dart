import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/match_model.dart';

class DatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get potential matches for a user
  Future<List<UserModel>> getPotentialMatches(String userId) async {
    try {
      // Get current user data
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) return [];

      UserModel currentUser = UserModel.fromJson(
          userDoc.data() as Map<String, dynamic>);

      // Get users that haven't been swiped on yet
      QuerySnapshot swipedUsers = await _firestore
          .collection('swipes')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> swipedUserIds = swipedUsers.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) => data['swipedUserId'] as String)
          .toList();

      // Add current user to the list
      swipedUserIds.add(userId);

      // Query for potential matches
      Query query = _firestore.collection('users');

      // Filter by gender preference
      if (currentUser.lookingFor.isNotEmpty) {
        query = query.where('gender', isEqualTo: currentUser.lookingFor);
      }

      // Filter by age range (example: ±5 years)
      int minAge = currentUser.age - 5;
      int maxAge = currentUser.age + 5;
      query = query.where('age', isGreaterThanOrEqualTo: minAge);
      query = query.where('age', isLessThanOrEqualTo: maxAge);

      QuerySnapshot snapshot = await query.get();

      List<UserModel> potentialMatches = [];

      for (DocumentSnapshot doc in snapshot.docs) {
        if (!swipedUserIds.contains(doc.id)) {
          UserModel user = UserModel.fromJson(
              doc.data() as Map<String, dynamic>);
          potentialMatches.add(user);
        }
      }

      return potentialMatches;
    } catch (e) {
      print('Error getting potential matches: $e');
      return [];
    }
  }

  // Swipe on a user (like or pass)
  Future<void> swipeUser({
    required String userId,
    required String swipedUserId,
    required bool isLike,
  }) async {
    try {
      // Record the swipe
      await _firestore.collection('swipes').add({
        'userId': userId,
        'swipedUserId': swipedUserId,
        'isLike': isLike,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // If it's a like, check for mutual match
      if (isLike) {
        await _checkForMatch(userId, swipedUserId);
      }
    } catch (e) {
      print('Error swiping user: $e');
      rethrow;
    }
  }

  // Check if two users have matched
  Future<void> _checkForMatch(String userId1, String userId2) async {
    try {
      // Check if the other user has also liked this user
      QuerySnapshot mutualLike = await _firestore
          .collection('swipes')
          .where('userId', isEqualTo: userId2)
          .where('swipedUserId', isEqualTo: userId1)
          .where('isLike', isEqualTo: true)
          .get();

      if (mutualLike.docs.isNotEmpty) {
        // Create a match
        await _createMatch(userId1, userId2);
      }
    } catch (e) {
      print('Error checking for match: $e');
    }
  }

  // Create a match between two users
  Future<void> _createMatch(String userId1, String userId2) async {
    try {
      String matchId = '${userId1}_$userId2';
      if (userId1.compareTo(userId2) > 0) {
        matchId = '${userId2}_$userId1';
      }

      await _firestore.collection('matches').doc(matchId).set({
        'id': matchId,
        'userId1': userId1,
        'userId2': userId2,
        'matchedAt': FieldValue.serverTimestamp(),
        'isActive': true,
        'hasUnreadMessages': false,
        'unreadCount': 0,
      });
    } catch (e) {
      print('Error creating match: $e');
    }
  }

  // Get all matches for a user
  Future<List<MatchModel>> getUserMatches(String userId) async {
    try {
      QuerySnapshot matches = await _firestore
          .collection('matches')
          .where('userId1', isEqualTo: userId)
          .get();

      QuerySnapshot matches2 = await _firestore
          .collection('matches')
          .where('userId2', isEqualTo: userId)
          .get();

      List<MatchModel> allMatches = [];

      // Process matches where user is userId1
      for (DocumentSnapshot doc in matches.docs) {
        MatchModel match = MatchModel.fromJson(
            doc.data() as Map<String, dynamic>);
        allMatches.add(match);
      }

      // Process matches where user is userId2
      for (DocumentSnapshot doc in matches2.docs) {
        MatchModel match = MatchModel.fromJson(
            doc.data() as Map<String, dynamic>);
        allMatches.add(match);
      }

      // Sort by most recent match
      allMatches.sort((a, b) => b.matchedAt.compareTo(a.matchedAt));

      return allMatches;
    } catch (e) {
      print('Error getting user matches: $e');
      return [];
    }
  }

  // Get user data for a match
  Future<UserModel?> getMatchUserData(String matchId, String currentUserId) async {
    try {
      DocumentSnapshot matchDoc = await _firestore
          .collection('matches')
          .doc(matchId)
          .get();

      if (!matchDoc.exists) return null;

      MatchModel match = MatchModel.fromJson(
          matchDoc.data() as Map<String, dynamic>);

      String otherUserId = match.userId1 == currentUserId 
          ? match.userId2 
          : match.userId1;

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(otherUserId)
          .get();

      if (userDoc.exists) {
        return UserModel.fromJson(
            userDoc.data() as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      print('Error getting match user data: $e');
      return null;
    }
  }

  // Update user location
  Future<void> updateUserLocation({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user location: $e');
      rethrow;
    }
  }

  // Get nearby users
  Future<List<UserModel>> getNearbyUsers({
    required String userId,
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    try {
      // This is a simplified version. In production, you'd use GeoFirestore
      // or implement a more sophisticated geospatial query
      
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('latitude', isGreaterThan: latitude - 0.1)
          .where('latitude', isLessThan: latitude + 0.1)
          .get();

      List<UserModel> nearbyUsers = [];

      for (DocumentSnapshot doc in snapshot.docs) {
        if (doc.id != userId) {
          UserModel user = UserModel.fromJson(
              doc.data() as Map<String, dynamic>);
          
          // Calculate distance (simplified)
          if (user.latitude != null && user.longitude != null) {
            double distance = _calculateDistance(
              latitude, longitude,
              user.latitude!, user.longitude!,
            );
            
            if (distance <= radiusInKm) {
              nearbyUsers.add(user);
            }
          }
        }
      }

      return nearbyUsers;
    } catch (e) {
      print('Error getting nearby users: $e');
      return [];
    }
  }

  // Calculate distance between two points (Haversine formula)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    
    double a = (dLat / 2).sin() * (dLat / 2).sin() +
        (lat1 * 3.14159265359 / 180).cos() *
        (lat2 * 3.14159265359 / 180).cos() *
        (dLon / 2).sin() * (dLon / 2).sin();
    
    double c = 2 * (a.sqrt()).asin();
    
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
