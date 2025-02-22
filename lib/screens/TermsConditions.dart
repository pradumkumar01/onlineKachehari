import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions>
    with SingleTickerProviderStateMixin {
  // Terms & Conditions data initialized
  final List<Map<String, String>> terms = [
    {
      'title': 'Acceptance of Terms',
      'content':
          'By accessing or using the Online Kachehari platform, users agree to comply with and be bound by these Terms and Conditions. If you do not agree with these terms, you are advised not to use the platform.'
    },
    {
      'title': 'User Responsibilities',
      'content':
          'Users are required to provide accurate information during registration and are responsible for maintaining the confidentiality of their login credentials. Any misuse or unauthorized access should be reported immediately.'
    },
    {
      'title': 'Consultation Services',
      'content':
          'The platform allows users to consult legal professionals. The advice provided by legal experts is based on the information given by users. Online Kachehari is not liable for any decisions made by users based on such advice.'
    },
    {
      'title': 'Payment and Refund Policy',
      'content':
          'All payments for consultations and services must be made in advance. Refunds will only be issued if a legal expert fails to provide the agreed-upon service, subject to the discretion of Online Kachehari.'
    },
    {
      'title': 'Privacy Policy',
      'content':
          'Online Kachehari is committed to protecting the privacy of its users. Personal data will not be shared with third parties without consent, except where required by law.'
    },
    {
      'title': 'Termination of Use',
      'content':
          'Online Kachehari reserves the right to terminate or suspend user accounts if there is a breach of these Terms and Conditions or any misuse of the platform.'
    },
    {
      'title': 'Limitation of Liability',
      'content':
          'Online Kachehari and its legal experts are not liable for any indirect or consequential damages arising from the use of the platform or the advice given by legal professionals.'
    },
    {
      'title': 'Amendments to Terms',
      'content':
          'Online Kachehari reserves the right to modify or update these Terms and Conditions at any time. Users are responsible for reviewing these terms periodically to stay informed of any changes.'
    },
    {
      'title': 'Governing Law',
      'content':
          'These Terms and Conditions shall be governed by and construed in accordance with the laws of the jurisdiction in which Online Kachehari operates.'
    },
  ];

  // Animation controller and animations
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose of animation controller when no longer needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text(
          "Terms & Conditions",
          style: TextStyle(
            fontFamily: "serif",
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
          ),
        ),
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: terms.length,
                  itemBuilder: (context, index) {
                    final term = terms[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        leading: const Icon(Icons.article,
                            color: Colors.deepPurpleAccent),
                        title: Text(
                          term['title']!,
                          style: const TextStyle(
                            fontFamily: "serif",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: const Border.symmetric(
                                  vertical: BorderSide.none,
                                  horizontal: BorderSide.none),
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.blue[50]!],
                              ),
                            ),
                            child: Text(
                              term['content']!,
                              style: const TextStyle(
                                fontFamily: "serif",
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
