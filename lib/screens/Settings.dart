import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool isDarkMode = false; // Local state to manage dark mode
  bool isTwoFactorAuthEnabled = false;

  final Authservices _authService = Authservices();
  Map<String, dynamic> user = {};
  bool isLoading = true;
  bool status = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await _authService.getUserData();
    if (userData != null) {
      setState(() {
        user = userData;
        isLoading = false;
      });
    } else {
      // _redirectToLogin();
    }
  }

  // void _redirectToLogin() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Navigator.pushReplacement(
  //         context, MaterialPageRoute(builder: (context) => LoginScreen()));
  //   });
  // }

  // void _logout() async {
  //   await _authService.signOut();
  //   _redirectToLogin();
  // }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: "serif",
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            themeData.isDarkMode ? Colors.black : Colors.deepPurpleAccent,
      ),
      backgroundColor: themeData.isDarkMode
          ? Colors.black
          : Colors.white, // Set background color based on dark mode
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          // User Info Card
          _buildUserInfoCard(),

          const SizedBox(height: 20.0),

          // Account Management Section
          _buildSectionHeader('Account Management'),
          _buildListTile(
            leadingIcon: Icons.person,
            title: 'Switch Account',
            onTap: () {
              // Implement switch account functionality
            },
          ),
          _buildListTile(
            leadingIcon: Icons.lock,
            title: 'Account Privacy',
            subtitle: 'Control who can see your profile',
            onTap: () {
              // Implement privacy settings functionality
            },
          ),

          const SizedBox(height: 20.0),

          // Security Section
          _buildSectionHeader('Security'),
          _buildListTile(
            leadingIcon: Icons.shield,
            title: 'Two-Factor Authentication',
            subtitle: 'Add extra security to your account',
            trailing: Switch(
              value: isTwoFactorAuthEnabled,
              onChanged: (bool value) {
                setState(() {
                  isTwoFactorAuthEnabled = value;
                });
              },
            ),
          ),
          _buildListTile(
            leadingIcon: Icons.login,
            title: 'Login Alerts',
            onTap: () {
              // Implement login alert functionality
            },
          ),

          const SizedBox(height: 20.0),

          // Data and Activity Section
          _buildSectionHeader('Data and Activity'),
          _buildListTile(
            leadingIcon: Icons.download,
            title: 'Download Your Data',
            onTap: () {
              // Implement data download functionality
            },
          ),
          _buildListTile(
            leadingIcon: Icons.history,
            title: 'Activity Log',
            onTap: () {
              // Implement activity log functionality
            },
          ),

          const SizedBox(height: 20.0),

          // Display Settings
          _buildSectionHeader('Display Settings'),
          _buildListTile(
            leadingIcon: Icons.dark_mode,
            title: 'Dark Mode',
            trailing: InkWell(
              onTap: () => themeData.changeTheme(),
              child: themeData.isDarkMode
                  ? const Icon(Icons.brightness_2)
                  : const Icon(Icons.brightness_6),
            ),
          ),
          _buildListTile(
            leadingIcon: Icons.brightness_6,
            title: 'Theme',
            onTap: () {},
          ),

          const SizedBox(height: 20.0),

          // Help and Support Section
          _buildSectionHeader('Help and Support'),
          _buildListTile(
            leadingIcon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {
              // Implement navigation to help center
            },
          ),
          _buildListTile(
            leadingIcon: Icons.report,
            title: 'Report a Problem',
            onTap: () {
              // Implement problem report functionality
            },
          ),

          const SizedBox(height: 20.0),

          // About Section
          _buildSectionHeader('About'),
          _buildListTile(
            leadingIcon: Icons.info_outline,
            title: 'App Version 1.0.0',
            onTap: () {
              // Show app version or other about info
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create the user info card
  Widget _buildUserInfoCard() {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeData.isDarkMode
            ? Colors.white10
            : Colors.deepPurpleAccent, // Adjusted color for better contrast
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(user['profileImage'] ??
                'assets/profile/profile1.jpeg'), // Replace with actual profile image asset
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      user['name'] ??
                          'Rajesh Kumar', // Replace with the actual user's name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.verified,
                      color: Colors.yellowAccent,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'View or Edit Profile',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Implement edit profile functionality
            },
          ),
        ],
      ),
    );
  }

  // Helper method to create section headers
  Widget _buildSectionHeader(String title) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: themeData.isDarkMode
              ? Colors.deepPurpleAccent
              : Colors.deepPurple, // Change text color based on mode
        ),
      ),
    );
  }

  // Helper method to create list tiles
  Widget _buildListTile({
    required IconData leadingIcon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Function()? onTap,
  }) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: themeData.isDarkMode
            ? Colors.deepPurpleAccent
            : Colors.deepPurple, // Change icon color based on mode
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: themeData.isDarkMode
              ? Colors.white
              : Colors.black, // Change text color based on mode
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: themeData.isDarkMode
                    ? Colors.white70
                    : Colors.black54, // Change subtitle color based on mode
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
