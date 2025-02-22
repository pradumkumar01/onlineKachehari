import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/HomePage/LiveAdvoates.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/LiveWakeels.dart';
import 'package:flutter_online_kachehari/components/OtherServices/NotaryScreeen/NotaryProcess.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';

class NotaryScreen extends StatefulWidget {
  const NotaryScreen({super.key});

  @override
  State<NotaryScreen> createState() => _NotaryScreenState();
}

class _NotaryScreenState extends State<NotaryScreen> {
  bool _isHindi = false;

  // Helper method to get translated text based on the selected language
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Notary Services', 'नोटरी सेवाएँ'),
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
                    translate('What is Notary?', 'नोटरी क्या है?'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    translate(
                      'Notary services involve the certification of documents and the witnessing of signatures to ensure their authenticity. A notary public is authorized to perform these tasks.',
                      'नोटरी सेवाओं में दस्तावेजों का प्रमाणीकरण और हस्ताक्षरों की प्रामाणिकता सुनिश्चित करने के लिए गवाही देना शामिल है। एक नोटरी पब्लिक इन कार्यों को करने के लिए अधिकृत होता है।',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Steps of Notary Process
            Text(
              translate('Notary Process', 'नोटरी प्रक्रिया'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _buildNotaryStep(
                stepNumber: '1',
                description: translate('Initial consultation with the notary.',
                    'नोटरी के साथ प्रारंभिक परामर्श।')),
            _buildNotaryStep(
                stepNumber: '2',
                description: translate(
                    'Verification of documents and identification.',
                    'दस्तावेजों और पहचान का सत्यापन।')),
            _buildNotaryStep(
                stepNumber: '3',
                description: translate('Notary signs and stamps the documents.',
                    'नोटरी दस्तावेजों पर हस्ताक्षर और मुहर लगाता है।')),
            _buildNotaryStep(
                stepNumber: '4',
                description: translate('Documents are returned to the client.',
                    'दस्तावेज़ ग्राहक को लौटा दिए जाते हैं।')),

            const SizedBox(height: 20),

            // Action buttons wrapped in cards for a more attractive look
            _buildActionButton(
              label: translate(
                  'Start Notary Process', 'नोटरी प्रक्रिया शुरू करें'),
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

  // Helper method to build each step in the notary process
  Widget _buildNotaryStep(
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
                  return NotaryProcess();
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
