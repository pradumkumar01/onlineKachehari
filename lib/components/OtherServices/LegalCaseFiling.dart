import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/HomePage/LiveAdvoates.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/LiveWakeels.dart';

class LegalCaseFiling extends StatefulWidget {
  const LegalCaseFiling({super.key});

  @override
  State<LegalCaseFiling> createState() => _LegalCaseFilingState();
}

class _LegalCaseFilingState extends State<LegalCaseFiling> {
  bool _isHindi = false;

  // Helper method to get translated text based on the selected language
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Legal Case Filing', 'कानूनी मामला दाखिल करना'),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        actions: [
          // Language toggle button in AppBar
          IconButton(
            icon: Icon(
              _isHindi ? Icons.language : Icons.translate,
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
            Navigator.of(context).pop();
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
                boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate('What is Legal Case Filing?',
                        'कानूनी मामला दाखिल करना क्या है?'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    translate(
                      'Legal case filing involves submitting your case to the court for legal proceedings.',
                      'कानूनी मामला दाखिल करने में कानूनी कार्यवाही के लिए अपने मामले को अदालत में जमा करना शामिल है।',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Steps of Legal Case Filing Process
            Text(
              translate('Legal Case Filing Process',
                  'कानूनी मामला दाखिल करने की प्रक्रिया'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _buildCertificationStep(
                stepNumber: '1',
                description: translate('Consulting with a legal expert.',
                    'एक कानूनी विशेषज्ञ से परामर्श करना।')),
            _buildCertificationStep(
                stepNumber: '2',
                description: translate('Preparing the necessary documents.',
                    'आवश्यक दस्तावेज़ तैयार करना।')),
            _buildCertificationStep(
                stepNumber: '3',
                description: translate('Filing the case in court.',
                    'मामला अदालत में दाखिल करना।')),

            const SizedBox(height: 20),

            // Action buttons wrapped in cards for a more attractive look
            _buildActionButton(
              label: translate(
                  'Request Case Filing', 'मामला दाखिल करने का अनुरोध करें'),
              onPressed: () => _showConsultationForm(),
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

  // Helper method to build each step in the legal case filing process
  Widget _buildCertificationStep(
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
