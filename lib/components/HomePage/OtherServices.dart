import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online_kachehari/components/OtherServices/ArbitrationScreen/ArbitrationScreen.dart';
import 'package:flutter_online_kachehari/components/OtherServices/Drafting.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalCaseFiling.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalDocumentAttestation.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalDocumentCertification.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalDocumentReview.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalDocumentVerification.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalNotice.dart';
import 'package:flutter_online_kachehari/components/OtherServices/LegalRepresentation.dart';
import 'package:flutter_online_kachehari/components/OtherServices/MediationScreen/MediationScreen.dart';
import 'package:flutter_online_kachehari/components/OtherServices/NotaryScreeen/NotaryScreen.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class OtherServices extends StatefulWidget {
  const OtherServices({super.key});

  @override
  State<OtherServices> createState() => _OtherServicesState();
}

class _OtherServicesState extends State<OtherServices> {
  // This will hold the loaded services data
  List<Map<String, dynamic>> otherServices = [];

  // Function to load the JSON data
  Future<void> loadServices() async {
    final String response =
        await rootBundle.loadString('assets/json/services.json');
    final List<dynamic> data = json.decode(response);

    // Map each item to a desired format
    setState(() {
      otherServices = data.map((service) {
        return {
          'icon': Icons.miscellaneous_services, // Placeholder for icon
          'title': service['title'],
          'onTap': (BuildContext context) {
            // Use the "screen" field to navigate to the appropriate screen
            String screen = service['screen'];
            Widget targetScreen;

            switch (screen) {
              case 'ArbitrationScreen':
                targetScreen = const ArbitrationScreen();
                break;
              case 'Mediation':
                targetScreen = const MediationScreen();
                break;

              case 'NotaryScreen':
                targetScreen = const NotaryScreen();
                break;
              case 'LegalNotice':
                targetScreen = const LegalNotice();
                break;
              case 'Drafting':
                targetScreen = const Drafting();
                break;
              case 'LegalRepresentation':
                targetScreen = const LegalRepresentation();
                break;
              case 'LegalDocumentReview':
                targetScreen = const LegalDocumentReview();
                break;
              case 'LegalCaseFiling':
                targetScreen = const LegalCaseFiling();
                break;
              case 'LegalDocumentVerification':
                targetScreen = const LegalDocumentVerification();
                break;
              case 'LegalDocumentAttestation':
                targetScreen = const LegalDocumentAttestation();
                break;
              case 'LegalDocumentCertification':
                targetScreen = const LegalDocumentCertification();
                break;
              default:
                targetScreen = const NotaryScreen(); // Default screen
            }

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return targetScreen;
            }));
          }
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadServices(); // Load services on init
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: otherServices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => otherServices[index]['onTap'](context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon
                        Icon(
                          otherServices[index]['icon'],
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        // Title Text
                        Text(
                          otherServices[index]['title'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
