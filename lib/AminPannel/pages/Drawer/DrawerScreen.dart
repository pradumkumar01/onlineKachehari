import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/AminPannel/pages/TopAppBar/AdminTopAppBar.dart';

void main() {
  runApp(AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      home: AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  // List of sidebar items
  final List<_SidebarItem> _sidebarItems = [
    _SidebarItem(
        icon: Icons.dashboard,
        label: "Dashboard",
        tooltip: "Overview of key statistics"),
    _SidebarItem(
        icon: Icons.people,
        label: "Users Management",
        tooltip: "List, approve, suspend users"),
    _SidebarItem(
        icon: Icons.balance,
        label: "Cases Management",
        tooltip: "View, update, assign cases"),
    _SidebarItem(
        icon: Icons.calendar_today,
        label: "Appointments",
        tooltip: "Schedule, manage hearings"),
    _SidebarItem(
        icon: Icons.document_scanner,
        label: "Documents Verification",
        tooltip: "Approve/reject uploads"),
    _SidebarItem(
        icon: Icons.payment,
        label: "Payments & Transactions",
        tooltip: "Monitor fees, refunds"),
    _SidebarItem(
        icon: Icons.bar_chart,
        label: "Reports & Analytics",
        tooltip: "View trends, user feedback"),
    _SidebarItem(
        icon: Icons.settings,
        label: "Settings",
        tooltip: "Permissions, profile management"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation or updating the main content accordingly
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      appBar: AdminTopAppBar(),
      drawer: isLargeScreen ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isLargeScreen) _buildNavigationRail(),
          // Main Content Area - replace with your dashboard or selected page content
          Expanded(
            child: Center(
              child: Text(
                "Selected: ${_sidebarItems[_selectedIndex].label}",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer for Mobile
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ..._sidebarItems.map((item) {
            int index = _sidebarItems.indexOf(item);
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              subtitle: Text(item.tooltip),
              selected: index == _selectedIndex,
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _onItemTapped(index);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  /// NavigationRail for larger screens
  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      labelType: NavigationRailLabelType.all,
      destinations: _sidebarItems.map((item) {
        return NavigationRailDestination(
          icon: Icon(item.icon),
          selectedIcon: Icon(item.icon, color: Colors.blue),
          label: Text(item.label),
        );
      }).toList(),
    );
  }
}

/// Helper class for sidebar items
class _SidebarItem {
  final IconData icon;
  final String label;
  final String tooltip;
  _SidebarItem(
      {required this.icon, required this.label, required this.tooltip});
}
