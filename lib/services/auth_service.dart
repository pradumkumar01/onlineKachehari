import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create User with details and save to Firestore
  Future<User?> createUserWithDetails(String name, String email,
      String password, String mobile, String cnfPassword, String gender) async {
    if (password != cnfPassword) {
      throw Exception('Passwords do not match');
    }
    try {
      // Create user with email and password
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Save user details in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(cred.user?.uid)
          .set({
        'uid': cred.user?.uid,
        'name': name,
        'email': email,
        'mobile': mobile,
        'gender': gender,
      });

      return cred.user;
    } catch (e) {
      throw Exception('Error in user creation: $e');
    }
  }

  // Login User with email and password
  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // Authenticate user with Firebase Authentication
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Check if the user exists in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(cred.user?.uid)
          .get();

      if (userDoc.exists) {
        return cred.user;
      } else {
        // User does not exist in Firestore; sign out the user
        await _auth.signOut();
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error during sign out: $e');
    }
  }

  // Check if a user is already logged in
  Future<User?> checkUserLoginStatus() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // User is logged in, return the user
        return user;
      }
      // User is not logged in, return null
      return null;
    } catch (e) {
      throw Exception('Error checking login status: $e');
    }
  }

  // Fetch authenticated user's data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('Users').doc(user.uid).get();
        return doc.exists ? doc.data() as Map<String, dynamic> : null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
    return null;
  }
}
