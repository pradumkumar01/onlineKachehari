import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for Support Ticket
class TicketModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String title;
  final String reason;
  final String message;
  final String status; // 'Pending', 'In Progress', 'Resolved'
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.title,
    required this.reason,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from Firestore document
  factory TicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TicketModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userEmail: data['userEmail'] ?? '',
      title: data['title'] ?? '',
      reason: data['reason'] ?? '',
      message: data['message'] ?? '',
      status: data['status'] ?? 'Pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'title': title,
      'reason': reason,
      'message': message,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  TicketModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? title,
    String? reason,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TicketModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      title: title ?? this.title,
      reason: reason ?? this.reason,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get status color
  String getStatusColor() {
    switch (status) {
      case 'Resolved':
        return 'green';
      case 'In Progress':
        return 'orange';
      default:
        return 'red';
    }
  }
}
