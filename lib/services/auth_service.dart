import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create User with details and save to Firestore
  /// Validates passwords match before creating user
  Future<User?> createUserWithDetails(
    String name,
    String email,
    String password,
    String mobile,
    String cnfPassword,
    String gender,
  ) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (email.trim().isEmpty || !_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }
    if (mobile.trim().isEmpty || mobile.length < 10) {
      throw Exception('Please enter a valid mobile number');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }
    if (password != cnfPassword) {
      throw Exception('Passwords do not match');
    }

    try {
      // Create user with email and password
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (cred.user == null) {
        throw Exception('Failed to create user account');
      }

      // Save user details in Firestore (use consistent collection name)
      await _firestore.collection('Users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'name': name.trim(),
        'nameLower': name.trim().toLowerCase(), // For case-insensitive search
        'email': email.trim().toLowerCase(),
        'mobile': mobile.trim(),
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // Update display name
      await cred.user!.updateDisplayName(name.trim());

      return cred.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        default:
          errorMessage = 'Registration failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error in user creation: $e');
    }
  }

  /// Login User with email and password
  /// Verifies user exists in Firestore after authentication
  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Validate inputs
    if (email.trim().isEmpty) {
      throw Exception('Please enter your email');
    }
    if (password.isEmpty) {
      throw Exception('Please enter your password');
    }

    try {
      // Authenticate user with Firebase Authentication
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (cred.user == null) {
        throw Exception('Login failed');
      }

      // Check if the user exists in Firestore
      final userDoc =
          await _firestore.collection('Users').doc(cred.user!.uid).get();

      if (!userDoc.exists) {
        // User authenticated but no Firestore record
        // Create the record from auth data
        await _firestore.collection('Users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'name': cred.user!.displayName ?? 'User',
          'nameLower': (cred.user!.displayName ?? 'user').toLowerCase(),
          'email': cred.user!.email!.toLowerCase(),
          'mobile': '',
          'gender': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isActive': true,
        });
      } else {
        // Update last login time
        await _firestore.collection('Users').doc(cred.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return cred.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  /// Sign out the user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error during sign out: $e');
    }
  }

  /// Check if a user is already logged in
  Future<User?> checkUserLoginStatus() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Reload user to get fresh data
        await user.reload();
        return _auth.currentUser;
      }
      return null;
    } catch (e) {
      throw Exception('Error checking login status: $e');
    }
  }

  /// Fetch authenticated user's data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      DocumentSnapshot doc =
          await _firestore.collection('Users').doc(user.uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Add updated timestamp
      data['updatedAt'] = FieldValue.serverTimestamp();

      // Update name in lowercase for search
      if (data.containsKey('name')) {
        data['nameLower'] = data['name'].toString().toLowerCase();
      }

      await _firestore.collection('Users').doc(user.uid).update(data);

      // Update display name if changed
      if (data.containsKey('name')) {
        await user.updateDisplayName(data['name']);
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      if (email.trim().isEmpty) {
        throw Exception('Please enter your email');
      }
      if (!_isValidEmail(email)) {
        throw Exception('Please enter a valid email address');
      }

      await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'Password reset failed: ${e.message}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Error sending password reset email: $e');
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
