import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleAdvocate extends StatefulWidget {
  final Map<String, dynamic> advocate;

  const SingleAdvocate({required this.advocate, super.key});

  @override
  State<SingleAdvocate> createState() => _SingleAdvocateState();
}

class _SingleAdvocateState extends State<SingleAdvocate> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var themeData = Provider.of<ThemeProviderState>(context);
    final advocate = widget.advocate;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          advocate['name'] ?? 'Advocate',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Profile Image
              Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 27, 9, 31),
                      const Color.fromARGB(255, 58, 5, 150)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: size.width * 0.15,
                        backgroundImage: AssetImage(
                          advocate['profileImage'] ?? '',
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    // Name
                    Text(
                      advocate['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.008),
                    // Specialization
                    Text(
                      advocate['specialization'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    // Online Status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.height * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: advocate['isOnline'] == true
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            advocate['isOnline'] == true ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatCard(
                          context,
                          advocate['cases']?.toString() ?? 'N/A',
                          'Cases',
                        ),
                        _buildStatCard(
                          context,
                          advocate['clients']?.toString() ?? 'N/A',
                          'Clients',
                        ),
                        _buildStatCard(
                          context,
                          advocate['details']?[1]['content'] ?? 'N/A',
                          'Experience',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.02,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchWhatsApp(
                          advocate['details']?.firstWhere(
                                (d) => d['title'] == 'Phone',
                                orElse: () => {'content': '+6392293279'},
                              )['content'] ??
                              '+6392293279',
                        ),
                        icon: const Icon(Icons.chat),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchPhone(
                          advocate['details']?.firstWhere(
                                (d) => d['title'] == 'Phone',
                                orElse: () => {'content': '+6392293279'},
                              )['content'] ??
                              '+6392293279',
                        ),
                        icon: const Icon(Icons.call),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Details Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        color:
                            themeData.isDarkMode ? Colors.white : Colors.black,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    if (advocate['details'] != null)
                      ...List.generate(
                        (advocate['details'] as List).length,
                        (index) {
                          final detail = advocate['details'][index];
                          return _buildDetailCard(
                            context,
                            detail['title'] ?? 'N/A',
                            detail['content'] ?? 'N/A',
                            themeData.isDarkMode,
                          );
                        },
                      ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: size.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    String content,
    bool isDarkMode,
  ) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.deepPurple.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            content,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: size.width * 0.035,
            ),
          ),
        ],
      ),
    );
  }

  void _launchWhatsApp(String phone) {
    // Remove non-numeric characters and ensure proper format
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    String url = 'whatsapp://send?phone=$cleanPhone';
    launchUrl(Uri.parse(url));
  }

  void _launchPhone(String phone) {
    String url = 'tel:$phone';
    launchUrl(Uri.parse(url));
  }
}
