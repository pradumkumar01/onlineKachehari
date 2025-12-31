import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_online_kachehari/models/ticket_model.dart';

/// Service for managing support tickets
class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a new support ticket
  Future<String> createTicket({
    required String title,
    required String reason,
    required String message,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Validate inputs
      if (title.trim().isEmpty) {
        throw Exception('Title cannot be empty');
      }
      if (reason.trim().isEmpty) {
        throw Exception('Reason cannot be empty');
      }
      if (message.trim().isEmpty) {
        throw Exception('Message cannot be empty');
      }

      // Fetch user data
      final userDoc = await _firestore.collection('Users').doc(user.uid).get();
      final userName = userDoc.data()?['name'] ?? 'Unknown User';
      final userEmail = user.email ?? '';

      // Create ticket
      final ticketData = {
        'userId': user.uid,
        'userName': userName,
        'userEmail': userEmail,
        'title': title.trim(),
        'reason': reason.trim(),
        'message': message.trim(),
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore.collection('Tickets').add(ticketData);

      // Send notification to user
      await _createTicketNotification(
        userId: user.uid,
        ticketId: docRef.id,
        title: title,
      );

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create ticket: $e');
    }
  }

  /// Get all tickets for current user
  Stream<List<TicketModel>> getUserTickets() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Tickets')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TicketModel.fromFirestore(doc);
      }).toList();
    });
  }

  /// Get all tickets (admin view)
  Stream<List<TicketModel>> getAllTickets() {
    return _firestore
        .collection('Tickets')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TicketModel.fromFirestore(doc);
      }).toList();
    });
  }

  /// Get tickets by status
  Stream<List<TicketModel>> getTicketsByStatus(String status) {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('Tickets')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TicketModel.fromFirestore(doc);
      }).toList();
    });
  }

  /// Update ticket status
  Future<void> updateTicketStatus(String ticketId, String newStatus) async {
    try {
      if (!['Pending', 'In Progress', 'Resolved'].contains(newStatus)) {
        throw Exception('Invalid status');
      }

      await _firestore.collection('Tickets').doc(ticketId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get ticket details for notification
      final ticketDoc =
          await _firestore.collection('Tickets').doc(ticketId).get();
      final ticketData = ticketDoc.data();
      if (ticketData != null) {
        await _createStatusUpdateNotification(
          userId: ticketData['userId'],
          ticketId: ticketId,
          title: ticketData['title'],
          newStatus: newStatus,
        );
      }
    } catch (e) {
      throw Exception('Failed to update ticket status: $e');
    }
  }

  /// Delete a ticket
  Future<void> deleteTicket(String ticketId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Verify ticket belongs to user
      final ticketDoc =
          await _firestore.collection('Tickets').doc(ticketId).get();
      if (!ticketDoc.exists) {
        throw Exception('Ticket not found');
      }

      final ticketData = ticketDoc.data();
      if (ticketData?['userId'] != user.uid) {
        throw Exception('Unauthorized to delete this ticket');
      }

      await _firestore.collection('Tickets').doc(ticketId).delete();
    } catch (e) {
      throw Exception('Failed to delete ticket: $e');
    }
  }

  /// Get ticket count by status
  Future<Map<String, int>> getTicketStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      return {'Pending': 0, 'In Progress': 0, 'Resolved': 0};
    }

    try {
      final querySnapshot = await _firestore
          .collection('Tickets')
          .where('userId', isEqualTo: user.uid)
          .get();

      final stats = {'Pending': 0, 'In Progress': 0, 'Resolved': 0};

      for (var doc in querySnapshot.docs) {
        final status = doc.data()['status'] ?? 'Pending';
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('Error fetching ticket stats: $e');
      return {'Pending': 0, 'In Progress': 0, 'Resolved': 0};
    }
  }

  /// Create notification when ticket is created
  Future<void> _createTicketNotification({
    required String userId,
    required String ticketId,
    required String title,
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .add({
        'title': 'Support Ticket Created',
        'message': 'Your ticket "$title" has been submitted successfully.',
        'type': 'ticket',
        'ticketId': ticketId,
        'date': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('Error creating ticket notification: $e');
    }
  }

  /// Create notification when ticket status changes
  Future<void> _createStatusUpdateNotification({
    required String userId,
    required String ticketId,
    required String title,
    required String newStatus,
  }) async {
    try {
      await _firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .add({
        'title': 'Ticket Status Updated',
        'message': 'Your ticket "$title" status changed to: $newStatus',
        'type': 'ticket_update',
        'ticketId': ticketId,
        'status': newStatus,
        'date': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print('Error creating status update notification: $e');
    }
  }
}
