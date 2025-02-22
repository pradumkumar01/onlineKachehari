import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Organization Title Section
                const Text(
                  'Our Organization',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We are a dedicated team providing solutions through our online platform. Our mission is to ensure seamless legal and consultation services for everyone.',
                  style: TextStyle(
                      fontSize: 16,
                      color:
                          themeData.isDarkMode ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 20),

                // Contact Details Section Title
                const Text(
                  'Contact Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),

                // Contact Person 1
                _buildContactCard(
                  name: 'Saurabh Rai',
                  role: 'Legal Consultant',
                  phone: '+91 987 654 3210',
                  email: 'saurabh.rai@organization.com',
                ),
                const SizedBox(height: 20),

                // Contact Person 2
                _buildContactCard(
                  name: 'Shailendra Sahani',
                  role: 'Customer Support',
                  phone: '+91 912 345 6789',
                  email: 'sahani.shailendra@organization.com',
                ),
                const SizedBox(height: 20),

                // Contact Person 3
                _buildContactCard(
                  name: 'Pradum Yadav',
                  role: 'Operations Manager',
                  phone: '+91 998 765 4321',
                  email: 'pradum.yadav@organization.com',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build each contact card
  Widget _buildContactCard({
    required String name,
    required String role,
    required String phone,
    required String email,
  }) {
    return Card(
      color: Colors.blueGrey[50],
      shadowColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              role,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text(phone, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(email, style: const TextStyle(fontSize: 16))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
