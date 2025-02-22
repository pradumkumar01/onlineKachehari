import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:flutter_online_kachehari/components/LiveAdvoactes/LiveWakeels.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'dart:convert';

import 'package:provider/provider.dart'; // For json decoding

class LiveAdvocates extends StatefulWidget {
  const LiveAdvocates({super.key});

  @override
  State<LiveAdvocates> createState() => _LiveAdvocatesState();
}

class _LiveAdvocatesState extends State<LiveAdvocates> {
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

  void _onImageTap(String advocateName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveWakeels(),
      ),
    );
    print('Tapped on $advocateName');
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return SizedBox(
      height: 150,
      child: liveAdvocates.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: liveAdvocates.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              _onImageTap(liveAdvocates[index]['name']),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 3),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.green[0],
                              child: ClipOval(
                                child: Image.asset(
                                  liveAdvocates[index]['image'],
                                  fit: BoxFit.cover,
                                  width: 75,
                                  height: 75,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const BlinkingText(
                                text: 'Live',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      width: 94,
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
                  ],
                );
              },
            ),
    );
  }
}

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const BlinkingText({super.key, required this.text, required this.style});

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}
