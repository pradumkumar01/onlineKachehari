import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/HomePage/LiveAdvoates.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/LiveWakeels.dart';

class LegalNotice extends StatefulWidget {
  const LegalNotice({super.key});

  @override
  State<LegalNotice> createState() => _LegalNoticeState();
}

class _LegalNoticeState extends State<LegalNotice> {
  bool _isHindi = false;

  // Helper method to get translated text based on the selected language
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Legal Notice', 'कानूनी सूचना'),
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
                    translate('What is Legal Notice?', 'कानूनी सूचना क्या है?'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    translate(
                      'A legal notice is a formal written communication between parties. It serves as a warning before legal action is initiated.',
                      'कानूनी सूचना पक्षों के बीच औपचारिक लिखित संचार है। यह कानूनी कार्रवाई शुरू करने से पहले एक चेतावनी के रूप में कार्य करता है।',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Steps of Legal Notice Process
            Text(
              translate('Legal Notice Process', 'कानूनी सूचना प्रक्रिया'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _buildLegalNoticeStep(
                stepNumber: '1',
                description: translate('Drafting the legal notice.',
                    'कानूनी सूचना का मसौदा तैयार करना।')),
            _buildLegalNoticeStep(
                stepNumber: '2',
                description: translate(
                    'Reviewing the notice with a legal expert.',
                    'कानूनी विशेषज्ञ के साथ सूचना की समीक्षा करना।')),
            _buildLegalNoticeStep(
                stepNumber: '3',
                description: translate(
                    'Sending the notice to the concerned party.',
                    'संबंधित पक्ष को सूचना भेजना।')),
            _buildLegalNoticeStep(
                stepNumber: '4',
                description: translate(
                    'Awaiting response or taking further legal action.',
                    'प्रतिक्रिया की प्रतीक्षा करना या आगे की कानूनी कार्रवाई करना।')),

            const SizedBox(height: 20),

            // Action buttons wrapped in cards for a more attractive look
            _buildActionButton(
              label: translate('Start Legal Notice Process',
                  'कानूनी सूचना प्रक्रिया शुरू करें'),
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

  // Helper method to build each step in the legal notice process
  Widget _buildLegalNoticeStep(
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
