import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/screens/LoginScreen.dart';
import 'package:flutter_online_kachehari/screens/SignUpScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// 1. WaveClipper for the wave-shaped header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.lineTo(0, size.height * 0.75);

    // Create a curved wave
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.95,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.75,
      size.width,
      size.height * 0.9,
    );

    // Close the path: top-right corner back to top-left
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 2. Main screen
class OnlineKachehariLoginScreen extends StatelessWidget {
  const OnlineKachehariLoginScreen({Key? key}) : super(key: key);

  // Define the gradient to use for the social icons' background
  final LinearGradient socialGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 60, 4, 213),
      Color.fromARGB(255, 37, 6, 105),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White background
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Wave-shaped gradient header
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

              const SizedBox(height: 30),

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
                  'Welcome !',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .white, // This color will be masked by the gradient
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // "Create Account" and "Login" buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    // Create Account (gradient) button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                        },
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Login (outlined) button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Navigate to login flow
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Colors.deepPurple),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Social icons row using Font Awesome icons with gradient circular background
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

              const SizedBox(height: 10),
              const Text(
                'Sign in with another account',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a circular social icon button with the specified gradient background.
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
}
