import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> with SingleTickerProviderStateMixin {
  // Policy data initialized
  final List<Map<String, String>> policies = [
    {
      'title': 'Privacy Policy',
      'content':
          'Your privacy is of utmost importance to us. We ensure that all personal data collected through the platform is protected and not shared with third parties without consent.'
    },
    {
      'title': 'User Agreement',
      'content':
          'By using the Online Kachehari platform, users agree to abide by the terms and conditions, ensuring respectful communication and compliance with legal requirements.'
    },
    {
      'title': 'Confidentiality',
      'content':
          'All consultations and interactions between users and legal experts are confidential. We use encryption to protect sensitive information exchanged on the platform.'
    },
    {
      'title': 'Payment Policy',
      'content':
          'Payments for legal services are processed through secure gateways. Users must agree to the fee structure before engaging in any paid services.'
    },
    {
      'title': 'Terms of Service',
      'content':
          'Online Kachehari reserves the right to modify its terms of service at any time. Users are responsible for staying updated with the latest terms and conditions.'
    },
    {
      'title': 'Dispute Resolution',
      'content':
          'In case of disputes between users and legal experts, Online Kachehari provides a dispute resolution mechanism to ensure fair and transparent resolution.'
    },
    {
      'title': 'Contact Us',
      'content':
          'For any inquiries or complaints, users can reach out to our support team via email or phone, and we will respond within 24-48 hours.'
    },
  ];

  // Initialize AnimationController and Animations directly
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

    // Start the animation immediately
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the controller when no longer needed to avoid memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Policies",
          style: TextStyle(
            fontFamily: "serif",
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.deepPurple),
        ),
      ),
      body: Container(
        color: theme.isDarkMode ? Colors.black : Colors.white,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: policies.length,
                  itemBuilder: (context, index) {
                    final policy = policies[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        leading: const Icon(Icons.policy,
                            color: Colors.deepPurpleAccent),
                        title: Text(
                          policy['title']!,
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
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.blue[50]!],
                              ),
                            ),
                            child: Text(
                              policy['content']!,
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
