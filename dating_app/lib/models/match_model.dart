class MatchModel {
  final String id;
  final String userId1;
  final String userId2;
  final DateTime matchedAt;
  final bool isActive;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final bool hasUnreadMessages;
  final int unreadCount;

  MatchModel({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.matchedAt,
    this.isActive = true,
    this.lastMessage,
    this.lastMessageAt,
    this.hasUnreadMessages = false,
    this.unreadCount = 0,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] ?? '',
      userId1: json['userId1'] ?? '',
      userId2: json['userId2'] ?? '',
      matchedAt: DateTime.parse(json['matchedAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      lastMessage: json['lastMessage'],
      lastMessageAt: json['lastMessageAt'] != null 
          ? DateTime.parse(json['lastMessageAt']) 
          : null,
      hasUnreadMessages: json['hasUnreadMessages'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId1': userId1,
      'userId2': userId2,
      'matchedAt': matchedAt.toIso8601String(),
      'isActive': isActive,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'hasUnreadMessages': hasUnreadMessages,
      'unreadCount': unreadCount,
    };
  }
}
