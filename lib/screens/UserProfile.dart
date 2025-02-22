import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/screens/AdvocateProfile.dart';
import 'package:flutter_online_kachehari/services/auth_service.dart';
import 'package:flutter_online_kachehari/screens/LoginScreen.dart';
import 'package:flutter_online_kachehari/screens/Settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final Authservices _authService = Authservices();
  Map<String, dynamic> user = {};
  bool isLoading = true;
  bool status = true;
  bool usertype = true;

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
      _redirectToLogin();
    }
  }

  void _redirectToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  void _logout() async {
    await _authService.signOut();
    _redirectToLogin();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title:
            const Text('User Profile', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user.isEmpty
              ? const Center(child: Text("No user data available"))
              : Container(
                  color: themeData.isDarkMode ? Colors.black : Colors.grey[100],
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      // Profile Header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(
                                      user['profileImage'] ??
                                          'assets/profile/profile.jpg'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user['name'] ?? 'User Name',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.verified,
                                            color: Colors.yellowAccent,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.email,
                                            color: Colors.white70,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            user['email'] ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.white70,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            user['address'] ?? 'N/A',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SectionHeader(title: 'Activity & Status'),
                      ProfileItem(
                        icon: Icons.circle,
                        color: Colors.green,
                        title: 'Status',
                        subtitle: status ? 'Online' : 'Offline',
                      ),
                      ProfileItem(
                          icon: Icons.person_pin_rounded,
                          color: Colors.blue,
                          title: 'User Type',
                          subtitle: usertype ? 'CUSTOMER' : 'ADVOCATE',
                          onTap: () {}
                          // Implement user type change functionality

                          ),
                      const SizedBox(height: 20),
                      const SectionHeader(title: 'Preferences'),
                      ProfileItem(
                        icon: Icons.settings,
                        color: Colors.grey,
                        title: 'Account Settings',
                        subtitle: 'Change password, privacy settings, etc.',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                        },
                      ),
                      const SizedBox(height: 20),
                      const SectionHeader(title: 'Social Profiles'),
                      ProfileItem(
                        icon: FontAwesomeIcons.instagram,
                        color: Colors.red,
                        title: 'Instagram',
                        subtitle: user['instagram'] ?? 'N/A',
                        onTap: () {},
                      ),
                      ProfileItem(
                        icon: FontAwesomeIcons.linkedin,
                        color: Colors.blue,
                        title: 'LinkedIn',
                        subtitle: user['linkedin'] ?? 'N/A',
                        onTap: () {},
                      ),
                      ProfileItem(
                        icon: FontAwesomeIcons.facebook,
                        color: Colors.blue,
                        title: 'LinkedIn',
                        subtitle: user['linkedin'] ?? 'N/A',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
    );
  }
}

// Section Header Widget
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Profile Item Widget
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              color: themeData.isDarkMode ? Colors.white : Colors.black)),
      subtitle: Text(subtitle,
          style: TextStyle(
              fontSize: 14,
              color: themeData.isDarkMode ? Colors.white70 : Colors.black54)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: themeData.isDarkMode ? Colors.deepPurpleAccent : Colors.black,
      ),
      onTap: onTap,
    );
  }
}
