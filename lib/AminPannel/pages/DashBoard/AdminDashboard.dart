import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<_DashboardItem> dashboardItems = [
    _DashboardItem(
      title: "Total Active Users",
      icon: Icons.people,
      value: "1,500",
      color: Colors.blue,
      tooltip: "Overview of all active users",
    ),
    _DashboardItem(
      title: "Pending & Resolved Cases",
      icon: Icons.balance,
      value: "Pending: 120\nResolved: 980",
      color: Colors.green,
      tooltip: "Cases status overview",
    ),
    _DashboardItem(
      title: "Upcoming Appointments",
      icon: Icons.calendar_today,
      value: "25",
      color: Colors.orange,
      tooltip: "Appointments scheduled",
    ),
    _DashboardItem(
      title: "Pending Document Verifications",
      icon: Icons.document_scanner,
      value: "15",
      color: Colors.red,
      tooltip: "Documents awaiting verification",
    ),
    _DashboardItem(
      title: "Recent Transactions",
      icon: Icons.payment,
      value: "₹75,000",
      color: Colors.purple,
      tooltip: "Transactions overview",
    ),
    _DashboardItem(
      title: "User Feedback & Reports",
      icon: Icons.feedback,
      value: "30 new",
      color: Colors.teal,
      tooltip: "Feedback and user reports",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AdminTopAppBar can be reused here as the AppBar.
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          // Adjust the crossAxisCount to show more or fewer cards per row
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: dashboardItems.map((item) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Handle tap if you need to navigate to detailed view
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tapped on ${item.title}")),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tooltip(
                        message: item.tooltip,
                        child: Icon(
                          item.icon,
                          size: 48,
                          color: item.color,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: item.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Helper class to store dashboard item details
class _DashboardItem {
  final String title;
  final IconData icon;
  final String value;
  final Color color;
  final String tooltip;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.value,
    required this.color,
    required this.tooltip,
  });
}
