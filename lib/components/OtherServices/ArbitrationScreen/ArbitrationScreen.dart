import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/HomePage/LiveAdvoates.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/LiveWakeels.dart';
import 'package:flutter_online_kachehari/components/OtherServices/ArbitrationScreen/ArbitrationProcess.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';

class ArbitrationScreen extends StatefulWidget {
  const ArbitrationScreen({super.key});

  @override
  State<ArbitrationScreen> createState() => _ArbitrationScreenState();
}

class _ArbitrationScreenState extends State<ArbitrationScreen> {
  bool _isHindi = false;

  // Helper method to get translated text based on the selected language
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Arbitration Services', 'मध्यस्थता सेवाएँ'),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        actions: [
          // Language toggle button in AppBar
          IconButton(
            icon: Icon(
              _isHindi
                  ? Icons.language
                  : Icons.translate, // Change icon based on the language
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isHindi = !_isHindi; // Toggle between Hindi and English
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return HomePage();
            }));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Description Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade100,
                    Colors.deepPurple.shade50
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 8, color: Colors.black26)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('What is Arbitration?', 'मध्यस्थता क्या है?'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    translate(
                      'Arbitration is a legal process where a neutral third party, called an arbitrator, is appointed to resolve disputes outside the court system. It is an alternative dispute resolution (ADR) method that allows parties to avoid lengthy litigation.',
                      'मध्यस्थता एक कानूनी प्रक्रिया है, जिसमें एक तटस्थ तीसरे पक्ष, जिसे मध्यस्थ कहा जाता है, अदालत प्रणाली के बाहर विवादों को हल करने के लिए नियुक्त किया जाता है। यह एक वैकल्पिक विवाद समाधान (ADR) विधि है, जो पक्षों को लंबी मुकदमेबाजी से बचने की अनुमति देती है।',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Steps of Arbitration Process
            Text(
              translate('Arbitration Process', 'मध्यस्थता प्रक्रिया'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _buildArbitrationStep(
                stepNumber: '1',
                description: translate(
                    'Initial consultation with the arbitrator.',
                    'मध्यस्थ के साथ प्रारंभिक परामर्श।')),
            _buildArbitrationStep(
                stepNumber: '2',
                description: translate(
                    'Agreement on the arbitration procedure.',
                    'मध्यस्थता प्रक्रिया पर समझौता।')),
            _buildArbitrationStep(
                stepNumber: '3',
                description: translate(
                    'Presentation of arguments by both parties.',
                    'दोनों पक्षों द्वारा तर्कों का प्रस्तुतिकरण।')),
            _buildArbitrationStep(
                stepNumber: '4',
                description: translate('Arbitrator issues a final decision.',
                    'मध्यस्थ अंतिम निर्णय जारी करता है।')),

            const SizedBox(height: 20),

            // Action buttons wrapped in cards for a more attractive look
            _buildActionButton(
              label: translate(
                  'Start Arbitration Process', 'मध्यस्थता प्रक्रिया शुरू करें'),
              onPressed: () => _showConsultationProcessForm(),
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 15),
            _buildActionButton(
              label: translate(
                  'Request Legal Consultation', 'कानूनी परामर्श अनुरोध करें'),
              onPressed: () => _showConsultationForm(),
              color: Colors.purpleAccent,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build each step in the arbitration process
  Widget _buildArbitrationStep(
      {required String stepNumber, required String description}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.deepPurple,
              child: Text(
                stepNumber,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create action buttons with custom styles
  Widget _buildActionButton(
      {required String label,
      required VoidCallback onPressed,
      required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Method to show the consultation form
  void _showConsultationProcessForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translate('Legal Consultation', 'कानूनी परामर्श')),
          content: Text(translate(
              'Would you like to proceed with a consultation?',
              'क्या आप परामर्श के साथ आगे बढ़ना चाहेंगे?')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate('Cancel', 'रद्द करें')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return ArbitrationProcess();
                }));
              },
              child: Text(translate('Proceed', 'आगे बढ़ें')),
            ),
          ],
        );
      },
    );
  }

  void _showConsultationForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(translate('Legal Consultation', 'कानूनी परामर्श')),
          content: Text(translate(
              'Would you like to proceed with a consultation?',
              'क्या आप परामर्श के साथ आगे बढ़ना चाहेंगे?')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translate('Cancel', 'रद्द करें')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return LiveWakeels();
                }));
              },
              child: Text(translate('Proceed', 'आगे बढ़ें')),
            ),
          ],
        );
      },
    );
  }
}
