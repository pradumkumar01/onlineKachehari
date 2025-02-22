/// A Flutter widget that represents the profile screen of a lawyer.
///
/// This screen displays various details about the lawyer, including their
/// profile picture, name, specialization, and other personal and professional
/// information. The profile details are displayed in a card with a rounded
/// border and elevation.
///
/// The profile details include:
/// - ID Number
/// - Bar License
/// - License Expiry
/// - Experience
/// - Contact Email
/// - Phone Number
/// - Address
/// - Education
/// - Languages
/// - Achievements
/// - Memberships
/// - Date of Birth
/// - Aadhaar Number
///
/// The screen also includes an AppBar with a back button to navigate back to
/// the previous screen.
///
///
///
library;
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<Map<String, dynamic>> lawyers = [
    {
      'name': 'Rajesh Kumar',
      'specialization': 'Criminal Law Specialist',
      'profileImage': 'assets/lawyer/lawyer1.jpeg',
      'details': [
        {'title': 'ID Number', 'content': '1234567890'},
        {'title': 'Experience', 'content': '15 years'},
        {'title': 'Email', 'content': 'rajeshkumar@example.com'},
        {'title': 'Date of Birth', 'content': '01 Jan 1980'},
        {'title': 'Aadhaar Number', 'content': '1234 5678 9012'},
        {'title': 'Phone', 'content': '+919876543210'},
        {'title': 'Address', 'content': '456 MG Road, Mumbai, India'},
        {
          'title': 'Education',
          'content': 'National Law School of India University'
        },
        {'title': 'Languages', 'content': 'Hindi, English'},
        {'title': 'Achievements', 'content': 'Best Lawyer Award 2018'},
        {'title': 'Memberships', 'content': 'Bar Council of India'},
        {'title': 'Bar License', 'content': 'BCI123456'},
        {'title': 'License Expiry', 'content': '31 Dec 2025'},
      ],
    },
    {
      'name': 'Anita Sharma',
      'specialization': 'Corporate Law Specialist',
      'profileImage': 'assets/lawyer/lawyer2.jpg',
      'details': [
        {'title': 'ID Number', 'content': '9876543210'},
        {'title': 'Experience', 'content': '10 years'},
        {'title': 'Email', 'content': 'anitasharma@example.com'},
        {'title': 'Date of Birth', 'content': '15 Mar 1985'},
        {'title': 'Aadhaar Number', 'content': '9876 5432 1098'},
        {'title': 'Phone', 'content': '+919876543211'},
        {'title': 'Address', 'content': '123 Marine Drive, Mumbai, India'},
        {'title': 'Education', 'content': 'Symbiosis Law School'},
        {'title': 'Languages', 'content': 'English, Marathi'},
        {'title': 'Achievements', 'content': 'Top Corporate Lawyer 2019'},
        {'title': 'Memberships', 'content': 'Corporate Lawyers Association'},
        {'title': 'Bar License', 'content': 'BCI654321'},
        {'title': 'License Expiry', 'content': '31 Dec 2023'},
      ],
    },
    {
      'name': 'Vikram Singh',
      'specialization': 'Family Law Specialist',
      'profileImage': 'assets/lawyer/lawyer3.jpg',
      'details': [
        {'title': 'ID Number', 'content': '1122334455'},
        {'title': 'Experience', 'content': '12 years'},
        {'title': 'Email', 'content': 'vikramsingh@example.com'},
        {'title': 'Date of Birth', 'content': '20 Feb 1982'},
        {'title': 'Aadhaar Number', 'content': '1122 3344 5566'},
        {'title': 'Phone', 'content': '+919876543212'},
        {'title': 'Address', 'content': '789 Park Street, Delhi, India'},
        {'title': 'Education', 'content': 'Delhi University'},
        {'title': 'Languages', 'content': 'Hindi, Punjabi'},
        {'title': 'Achievements', 'content': 'Family Lawyer of the Year 2020'},
        {'title': 'Memberships', 'content': 'Family Law Association'},
        {'title': 'Bar License', 'content': 'BCI112233'},
        {'title': 'License Expiry', 'content': '31 Dec 2024'},
      ],
    },
    {
      'name': 'Sanjana Rao',
      'specialization': 'Intellectual Property Law Specialist',
      'profileImage': 'assets/lawyer/lawyer4.jpg',
      'details': [
        {'title': 'ID Number', 'content': '2233445566'},
        {'title': 'Experience', 'content': '8 years'},
        {'title': 'Email', 'content': 'sanjanarao@example.com'},
        {'title': 'Date of Birth', 'content': '10 Oct 1987'},
        {'title': 'Aadhaar Number', 'content': '2233 4455 6677'},
        {'title': 'Phone', 'content': '+919876543213'},
        {'title': 'Address', 'content': '456 Residency Road, Bangalore, India'},
        {'title': 'Education', 'content': 'Bangalore University'},
        {'title': 'Languages', 'content': 'Kannada, English'},
        {'title': 'Achievements', 'content': 'IP Lawyer of the Year 2019'},
        {'title': 'Memberships', 'content': 'IP Law Association'},
        {'title': 'Bar License', 'content': 'BCI223344'},
        {'title': 'License Expiry', 'content': '31 Dec 2026'},
      ],
    },
    {
      'name': 'Amitabh Verma',
      'specialization': 'Tax Law Specialist',
      'profileImage': 'assets/lawyer/lawyer5.jpg',
      'details': [
        {'title': 'ID Number', 'content': '3344556677'},
        {'title': 'Experience', 'content': '20 years'},
        {'title': 'Email', 'content': 'amitabhverma@example.com'},
        {'title': 'Date of Birth', 'content': '05 May 1975'},
        {'title': 'Aadhaar Number', 'content': '3344 5566 7788'},
        {'title': 'Phone', 'content': '+919876543214'},
        {'title': 'Address', 'content': '123 Connaught Place, Delhi, India'},
        {'title': 'Education', 'content': 'Indian Law Institute'},
        {'title': 'Languages', 'content': 'Hindi, English'},
        {'title': 'Achievements', 'content': 'Best Tax Lawyer 2017'},
        {'title': 'Memberships', 'content': 'Tax Law Association'},
        {'title': 'Bar License', 'content': 'BCI334455'},
        {'title': 'License Expiry', 'content': '31 Dec 2027'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: lawyers.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            'Top Advocates',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            tabs: lawyers.map((lawyer) => Tab(text: lawyer['name'])).toList(),
            labelColor: Colors.white,
            isScrollable: true,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: TabBarView(
          children: lawyers.map((lawyer) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    child: Image.asset(lawyer['profileImage']),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: screenWidth *
                                0.15, // Adjusting size based on screen width
                            backgroundImage: AssetImage(lawyer['profileImage']),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          lawyer['name'],
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.06, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          lawyer['specialization'],
                          style: TextStyle(
                            fontSize:
                                screenWidth * 0.045, // Responsive font size
                            color: Colors.grey[700],
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        ...lawyer['details']
                            .map<Widget>((detail) => buildProfileDetail(
                                detail['title'],
                                detail['content'],
                                screenWidth))
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildProfileDetail(String title, String content, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                  fontSize: screenWidth * 0.04), // Responsive font size
            ),
          ),
        ],
      ),
    );
  }
}
