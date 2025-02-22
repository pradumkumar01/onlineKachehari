import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_online_kachehari/components/LiveAdvoactes/ChatScreen/ChatScreen.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveWakeels extends StatefulWidget {
  const LiveWakeels({super.key});

  @override
  State<LiveWakeels> createState() => _LiveWakeelsState();
}

class _LiveWakeelsState extends State<LiveWakeels> {
  List<Map<String, dynamic>> _lawyers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLawyerData();
  }

  Future<void> _loadLawyerData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/advocate.json');
      final data = json.decode(response) as List;
      setState(() {
        _lawyers = data.map((json) => json as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load data: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var themeData = Provider.of<ThemeProviderState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Live Advocates",
          style: TextStyle(
            fontFamily: "serif",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : Container(
                  color: themeData.isDarkMode ? Colors.black : Colors.white,
                  child: ListView.builder(
                    itemCount: _lawyers.length,
                    itemBuilder: (context, index) {
                      final item = _lawyers[index];
                      return Card(
                        shadowColor: Colors.deepPurpleAccent,
                        // borderOnForeground: true,
                        color: themeData.isDarkMode
                            ? Colors.grey[900]
                            : Colors.white,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            backgroundImage: item['profileImage'] != null
                                ? AssetImage(item['profileImage'])
                                : const AssetImage(
                                    'assets/images/default_profile.png'), // Default image if null
                          ),
                          title: Text(
                            item['name'] ?? 'Unknown Name',
                            style: TextStyle(
                              fontFamily: "serif",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeData.isDarkMode
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.6, // Adaptive width
                                child: Text(
                                  item['specialization'] ?? 'No Specialization',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeData.isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                  maxLines:
                                      2, // Limit lines for long specializations
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                item['subtitle'] ?? '',
                                style: TextStyle(
                                  color: item['isOnline']
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            item['chatStatus'] ?? 'Offline',
                            style: TextStyle(
                              fontFamily: "serif",
                              fontSize: 16,
                              color:
                                  item['isOnline'] ? Colors.blue : Colors.grey,
                            ),
                          ),
                          onTap: () {
                            if (item['isOnline'] == true) {
                              _launchWhatsApp();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ChatScreen(
                              //       advocate: item,
                              //     ),
                              //   ),
                              // );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }

//add whatsapp method
  void _launchWhatsApp() {
    String url = 'whatsapp://send?phone=+6392293279';
    launchUrl(Uri.parse(url));
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> lawyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lawyer['name'] ?? 'Advocate Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (lawyer['details'] as List?)
                  ?.map<Widget>((detail) => ListTile(
                        title: Text(detail['title'] ?? 'No Title'),
                        subtitle: Text(detail['content'] ?? 'No Content'),
                      ))
                  .toList() ??
              [const Text("No additional details available.")],
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
