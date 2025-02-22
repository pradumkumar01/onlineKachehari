import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/ChatScreen/ChatScreen.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TopAdvocate extends StatefulWidget {
  const TopAdvocate({super.key});

  @override
  _TopAdvocateState createState() => _TopAdvocateState();
}

class _TopAdvocateState extends State<TopAdvocate> {
  List<Map<String, dynamic>> advocates = [];
  int? tappedIndex; // Track the tapped index for animation

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/advocate.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        advocates =
            jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  void _onCardTap(int index) {
    setState(() {
      tappedIndex = index; // Set the tapped index
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        tappedIndex = null; // Reset the animation
      });

      // Navigate to the lawyer's profile
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          'Top Advocates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
        child: advocates.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: advocates.length,
                itemBuilder: (context, index) {
                  final advocate = advocates[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: size.height * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.width * 0.05),
                    ),
                    elevation: 5,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                        onTap: () => _onCardTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(size.width * 0.05),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.05),
                            gradient: LinearGradient(
                              colors: themeData.isDarkMode
                                  ? [
                                      const Color.fromARGB(255, 27, 9, 31),
                                      const Color.fromARGB(255, 58, 5, 150)
                                    ]
                                  : [
                                      const Color.fromARGB(255, 27, 9, 31),
                                      const Color.fromARGB(255, 58, 5, 150)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: tappedIndex == index
                                    ? Colors.purple.withOpacity(0.8)
                                    : Colors.transparent,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: themeData.isDarkMode
                                    ? Colors.deepPurpleAccent
                                    : Colors.deepPurple.withOpacity(0.0),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: size.width * 0.08,
                                          backgroundImage: AssetImage(
                                              advocate['profileImage'] ?? ''),
                                        ),
                                        SizedBox(width: size.width * 0.04),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                advocate['name'] ??
                                                    'Unknown Name',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: size.width * 0.045,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.005),
                                              Text(
                                                advocate['specialization'] ??
                                                    'No Specialization',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: size.width * 0.035,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchWhatsApp();
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => ChatScreen(
                                      //       advocate: advocate,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.03,
                                        vertical: size.height * 0.015,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Contact',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: size.width * 0.04,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ProfileStat(
                                    title: 'Experience',
                                    value: advocate['details']?[1]['content'] ??
                                        'N/A',
                                  ),
                                  ProfileStat(
                                    title: 'Cases',
                                    value:
                                        advocate['cases']?.toString() ?? 'N/A',
                                  ),
                                  ProfileStat(
                                    title: 'Clients',
                                    value: advocate['clients']?.toString() ??
                                        'N/A',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const ProfileStat({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: size.height * 0.005),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: size.width * 0.035,
          ),
        ),
      ],
    );
  }
}

void _launchWhatsApp() {
  String url = 'whatsapp://send?phone=+6392293279';
  launchUrl(Uri.parse(url));
}
