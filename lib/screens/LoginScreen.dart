import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/screens/AdvocateProfile.dart';
import 'package:flutter_online_kachehari/screens/ForgotScreen.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/SignUpScreen.dart';
import 'package:flutter_online_kachehari/screens/alert.dart';
import 'package:flutter_online_kachehari/services/auth_service.dart';
import 'package:flutter_online_kachehari/services/notification_service.dart';
import 'package:flutter_online_kachehari/toaster/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'WaveClipper.dart'; // Make sure this references your WaveClipper code

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = Authservices();
  final NotificationService notificationService = NotificationService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _rememberMe = false; // For "Remember me" checkbox

  final LinearGradient socialGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 60, 4, 213),
      Color.fromARGB(255, 37, 6, 105),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use a SingleChildScrollView to handle smaller screens
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top wave gradient area
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 60, 4, 213),
                          Color.fromARGB(255, 37, 6, 105)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Center the logo & brand name
                SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Online Kachehari',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'आपका अधिकार, आपकी आवाज़',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 2. White container with login form
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Welcome back !"
                  // "Welcome!"
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 60, 4, 213),
                        Color.fromARGB(255, 37, 6, 105),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      'Welcome Back !',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // This color will be masked by the gradient
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Username field
                  _buildTextField(
                    controller: _usernameController,
                    hint: 'Username',
                    icon: Icons.person,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  _buildTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 8),

                  // Row with "Remember me" and "Forgot password?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? val) {
                              setState(() {
                                _rememberMe = val ?? false;
                              });
                            },
                          ),
                          const Text('Remember me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ForgotScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(0),
                        // ),
                        // // Set background to transparent and use Ink widget for gradient
                        // backgroundColor: Colors.transparent,
                        // shadowColor: Colors.transparent,
                        // elevation: 2,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 60, 4, 213),
                              Color.fromARGB(255, 37, 6, 105)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minHeight: 50),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // child: const Text(
                      //   "Login",
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ),
                  ),
                  const SizedBox(height: 0),

                  // "New user? Sign up"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New user? ',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xFF7C4DFF)),
                        ),
                      ),
                    ],
                  ),
                  // OR text in between line
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 60, 4, 213),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color.fromARGB(255, 60, 4, 213),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Twitter
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.twitter,
                        iconSize: 26,
                        onPressed: () {
                          // TODO: Twitter sign-in
                        },
                      ),
                      const SizedBox(width: 12),
                      // LinkedIn
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.linkedinIn,
                        iconSize: 24,
                        onPressed: () {
                          // TODO: LinkedIn sign-in
                        },
                      ),
                      const SizedBox(width: 12),
                      // Facebook
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.facebookF,
                        iconSize: 25,
                        onPressed: () {
                          // TODO: Facebook sign-in
                        },
                      ),
                      const SizedBox(width: 12),
                      // Google
                      _buildSocialIconButton(
                        icon: FontAwesomeIcons.google,
                        iconSize: 25,
                        onPressed: () {
                          // TODO: Google sign-in
                        },
                      ),
                    ],
                  ),

                  // Advocate Register (if needed)
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context).pushReplacement(
                  //           MaterialPageRoute(
                  //             builder: (context) => AdvocateRegistration(),
                  //           ),
                  //         );
                  //       },
                  //       child: const Text(
                  //         'Advocate Register',
                  //         style: TextStyle(color: Color(0xFF7C4DFF)),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_showPassword : false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildSocialIconButton({
    required IconData icon,
    required double iconSize,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: socialGradient,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }

  /// The same login logic from your code
  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty) {
      showAlert(context, "Username (email) is required.");
      return;
    }

    if (password.isEmpty) {
      showAlert(context, "Password is required.");
      return;
    }

    try {
      // Attempt to sign in the user with Firebase Authentication
      User? user = await auth.loginUserWithEmailAndPassword(username, password);

      if (user != null) {
        // Check if the user exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          showToaster("Login successful!");

          DateTime dateNow = DateTime.now();
          await notificationService.notify(
            userId: user.uid,
            title: "Login Successful",
            body: "Welcome back, $username!",
            date: dateNow.toIso8601String(),
          );

          // Navigate to HomePage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // User is authenticated but not in Firestore
          await auth.signOut();
          showAlert(context, "User not found in our records. Please sign up.");
        }
      } else {
        showAlert(context, "Invalid email or password.");
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred.";

      if (e.code == 'user-not-found') {
        errorMessage = "No user found for this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address.";
      }

      showAlert(context, errorMessage);
    } catch (e) {
      showAlert(context, "An unexpected error occurred: $e");
    }
  }
}

// import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.lineTo(0, size.height * 0.8);

    // First curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.9,
    );
    // Second curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height,
    );

    // Close the path (top-right corner)
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
