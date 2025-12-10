import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/ChatScreen/ChatScreen.dart';
import 'package:flutter_online_kachehari/components/TopAdvocate/SingleAdvocate.dart';
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
  int? tappedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    super.dispose();
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
      tappedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        tappedIndex = null;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleAdvocate(
            advocate: advocates[index],
          ),
        ),
      );
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
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeData.isDarkMode
                ? [Colors.black87, Colors.black]
                : [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: advocates.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.02,
                ),
                itemCount: advocates.length,
                itemBuilder: (context, index) {
                  final advocate = advocates[index];
                  return _buildAdvocateCard(
                      context, index, advocate, size, themeData);
                },
              ),
      ),
    );
  }

  Widget _buildAdvocateCard(
    BuildContext context,
    int index,
    Map<String, dynamic> advocate,
    Size size,
    ThemeProviderState themeData,
  ) {
    return Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.02),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _onCardTap(index),
            child: AnimatedScale(
              scale: tappedIndex == index ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(
                        tappedIndex == index ? 0.5 : 0.2,
                      ),
                      blurRadius: tappedIndex == index ? 20 : 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
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
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Column(children: [
                        // Top Section - Profile Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Section
                            Expanded(
                              child: Row(
                                children: [
                                  // Avatar with Online Status
                                  Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.deepPurple
                                                  .withOpacity(0.5),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: size.width * 0.08,
                                          backgroundImage: AssetImage(
                                            advocate['profileImage'] ?? '',
                                          ),
                                        ),
                                      ),
                                      if (advocate['isOnline'] == true)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: Colors.greenAccent,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: size.width * 0.04),
                                  // Name and Specialization
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          advocate['name'] ?? 'Unknown Name',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.048,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.3,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.02,
                                            vertical: size.height * 0.004,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color:
                                                  Colors.white.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Text(
                                            advocate['specialization'] ??
                                                'No Specialization',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: size.width * 0.032,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Contact Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _launchWhatsApp();
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.035,
                                      vertical: size.height * 0.012,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          color: Colors.deepPurple,
                                          size: size.width * 0.045,
                                        ),
                                        SizedBox(height: size.height * 0.003),
                                        Text(
                                          'Chat',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontSize: size.width * 0.028,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        // Stats Section
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.012,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                context,
                                advocate['details']?[1]['content'] ?? 'N/A',
                                'Experience',
                                Icons.trending_up,
                              ),
                              Container(
                                width: 1,
                                height: size.height * 0.04,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              _buildStatItem(
                                context,
                                advocate['cases']?.toString() ?? 'N/A',
                                'Cases',
                                Icons.gavel,
                              ),
                              Container(
                                width: 1,
                                height: size.height * 0.04,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              _buildStatItem(
                                context,
                                advocate['clients']?.toString() ?? 'N/A',
                                'Clients',
                                Icons.people,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        // CTA Button
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.shade400,
                                Colors.amber.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onCardTap(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.012,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: size.width * 0.04,
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    Text(
                                      'View Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.width * 0.036,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.amber.shade300,
            size: size.width * 0.05,
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.042,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: size.height * 0.003),
          Text(
            label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: size.width * 0.03,
            ),
          ),
        ],
      ),
    );
  }
}

void _launchWhatsApp() {
  String url = 'whatsapp://send?phone=+6392293279';
  launchUrl(Uri.parse(url));
}
