import 'package:flutter/material.dart';

class AdminTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminTopAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Search Field
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search cases, users, transactions...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Notifications Bell
        IconButton(
          icon: Icon(Icons.notifications),
          tooltip: 'Notifications',
          onPressed: () {
            // Handle notification action (e.g., navigate to notifications page)
          },
        ),
        // Profile Menu
        PopupMenuButton<String>(
          icon: Icon(Icons.account_circle),
          tooltip: 'Profile Menu',
          onSelected: (value) {
            if (value == 'profile') {
              // Navigate to Profile Settings
            } else if (value == 'logout') {
              // Handle Logout
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'profile',
              child: Text('Profile Settings'),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }

  // Define a fixed height for the AppBar
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
