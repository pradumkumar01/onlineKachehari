import 'dart:convert'; // Import this for JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for rootBundle
import 'package:flutter_online_kachehari/components/TopAdvocate/TopAdvocate.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class TopAdvocates extends StatefulWidget {
  const TopAdvocates({super.key});

  @override
  State<TopAdvocates> createState() => _TopAdvocatesState();
}

class _TopAdvocatesState extends State<TopAdvocates> {
  List<Map<String, dynamic>> liveAdvocates =
      []; // Updated to hold advocate data

  @override
  void initState() {
    super.initState();
    _loadAdvocates(); // Load advocates data on initialization
  }

  Future<void> _loadAdvocates() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/advocate.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        // Map the advocate data to a list of maps containing name and image
        liveAdvocates = jsonData
            .map((item) => {
                  'name': item['name'],
                  'image': item['profileImage'],
                  'specialization': item['specialization']
                })
            .toList();
      });
    } catch (e) {
      print("Error loading advocates data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return SizedBox(
      height: 161,
      child: liveAdvocates.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: liveAdvocates.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return SizedBox(
                  // width: 20,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const TopAdvocate()),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple[100],
                            child: ClipOval(
                              child: Image.asset(
                                liveAdvocates[index]['image'],
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        liveAdvocates[index]['name'],
                        style: TextStyle(
                          fontSize: 14,
                          color: themeData.isDarkMode
                              ? Colors.deepPurpleAccent
                              : Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 95,
                        child: Text(
                          liveAdvocates[index]['specialization'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //           builder: (context) => TopAdvocate()),
                      //     );
                      //   },
                      //   child: const Text('View Details'),
                      // ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
