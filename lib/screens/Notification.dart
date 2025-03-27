import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/screens/FeedsPage.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/UserProfile.dart';
import 'package:flutter_online_kachehari/services/notification_service.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> notifications = [];
  int _selectedIndex = 3;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
    fetchNotifications();
  }

  /// Fetch notifications for the authenticated user
  Future<void> fetchNotifications() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in");
      setState(() => isLoading = false);
      return;
    }
    try {
      final fetchedNotifications = await notificationService
          .fetchNotificationsFromFirebase(userId: user.uid);
      setState(() {
        notifications = fetchedNotifications;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching notifications: $error");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Stack(
          children: [
            const Text("Notifications", style: TextStyle(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: const Icon(
                    Icons.notification_add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
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
                  notifications.length.toString(), // Dynamic count
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(child: Text("No Notifications"))
              : Container(
                  color: themeData.isDarkMode
                      ? Colors.black
                      : Colors.white.withOpacity(0.8),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.notifications_active,
                            color: Colors.deepPurple),
                        title: Text(notifications[index]['title'] ?? "No Title",
                            style: TextStyle(
                                color: themeData.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notifications[index]['body'] ?? "No Content",
                                style: TextStyle(
                                    color: themeData.isDarkMode
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.black)),
                            const SizedBox(height: 4),
                            Text(
                              notifications[index]['date'] ?? "Unknown Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: themeData.isDarkMode
                                    ? Colors.white.withOpacity(0.7)
                                    : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          switch (index) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
              break;
            case 1:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FeedsPage()));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()));
              break;
            case 4:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feeds'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
