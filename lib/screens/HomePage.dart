import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/LiveAdvoates.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/OurServices.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/SocialMediaIcons.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/TopAdvocates.dart';

import 'package:flutter_online_kachehari/features/Customer/components/HomePage/TopLegalTrends.dart';
import 'package:flutter_online_kachehari/features/Customer/components/LiveAdvoactes/LiveWakeels.dart';
import 'package:flutter_online_kachehari/features/Customer/components/TopAdvocate/TopAdvocate.dart';

import 'package:flutter_online_kachehari/features/Customer/components/TopLegalTrends/TopLegal.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/BottomNaviagtion.dart';
import 'package:flutter_online_kachehari/features/Customer/components/HomePage/DrawerHomePage.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';

import 'package:flutter_online_kachehari/screens/Notification.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isHindi = false; // Flag to toggle between Hindi and English

  // Translation function
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  //fake notification
  // final List<Map<String, String>> notifications = [];
  //  // Stream to fetch notifications from Firebase Firestore
  // Stream<QuerySnapshot> fetchNotifications() {
  //   return FirebaseFirestore.instance
  //       .collection('notifications') // Collection name in Firestore
  //       .orderBy('date', descending: true) // Sort notifications by date
  //       .snapshots();
  // }

  // Fake data for search suggestions
  final List<String> searchSuggestions = [
    'Advocate A',
    'Legal News',
    'Law Updates',
    'Court Hearings',
    'Case Studies',
    'Arbitration',
    'Mediation',
    'Legal Advice',
    'Legal Consultation',
    'Notary Services',
    'Legal Drafting',
    'Legal Representation',
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to toggle language
  void _toggleLanguage() {
    setState(() {
      _isHindi = !_isHindi;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    User? user = _auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Matching app bar color
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 60, 4, 213),
                Color.fromRGBO(37, 6, 105, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Stack(
          children: [
            Text(translate('Online Kachaheri', 'ऑनलाइन कचहरी'),
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu, color: Colors.white));
        }),
        actions: [
          if (user != null)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .collection('Notifications')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.notifications,
                        color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                    },
                  );
                }

                int notificationCount = snapshot.data!.docs.length;

                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NotificationPage()));
                      },
                    ),
                    Positioned(
                      right: 7,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
        ],
      ),
      //Drawer of the page

      drawer: const DrawerHomePage(),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar with fake suggestions
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return searchSuggestions.where((String suggestion) {
                      return suggestion
                          .contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    print('You selected: $selection');
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: translate('Search...', 'खोजें...'),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: themeData.isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[200],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                // Top Trending Section
                Row(
                  children: [
                    Text(translate('Top Legal Trends', 'टॉप कानूनी ट्रेंड्स'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeData.isDarkMode
                              ? Colors.deepPurpleAccent
                              : Colors.black,
                        )),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TopLegal()));
                      },
                      child: Text(translate('View All', 'सभी देखें'),
                          style: TextStyle(
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ],
                ),
                const TopLegalTrends(),

                // Top Advocates
                const SizedBox(height: 0),
                Row(
                  children: [
                    Text(
                        translate(
                          'Top Advocates',
                          'टॉप वकील',
                        ),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeData.isDarkMode
                              ? Colors.deepPurpleAccent
                              : Colors.black,
                        )),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TopAdvocate()));
                      },
                      child: Text(translate('View All', 'सभी देखें'),
                          style: TextStyle(
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ],
                ),
                const TopAdvocates(),
                SizedBox(
                  height: 20,
                ),
                // Vakil Logo Section
                Text(translate(' Banner', 'वकील लोगो'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeData.isDarkMode
                          ? Colors.deepPurpleAccent
                          : Colors.black,
                    )),
                const SizedBox(height: 10),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    elevation: 4,
                    child: Container(
                      height: 250,
                      width: 450,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/online.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Live Advocate Section
                Row(
                  children: [
                    Text(translate('Live Advocates', 'लाइव वकील'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeData.isDarkMode
                              ? Colors.deepPurpleAccent
                              : Colors.black,
                        )),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LiveWakeels()));
                      },
                      child: Text(translate('View All', 'सभी देखें'),
                          style: TextStyle(
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const LiveAdvocates(),
                const SizedBox(height: 10),

                // Other Services Section with Cards
                Text(translate('Our Services', 'अन्य सेवाएं'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeData.isDarkMode
                          ? Colors.deepPurpleAccent
                          : Colors.black,
                    )),
                const SizedBox(height: 10),
                const OurServices(),

                const SizedBox(height: 20),

                // Add social media icons with their links
                SocialMediaIcons(isHindi: _isHindi),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNaviagtion(),
    );
  }
}
