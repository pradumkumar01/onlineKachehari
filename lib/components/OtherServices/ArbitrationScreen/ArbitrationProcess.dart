import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/OtherServices/ArbitrationScreen/ArbitrationScreen.dart';

class ArbitrationProcess extends StatefulWidget {
  const ArbitrationProcess({super.key});

  @override
  State<ArbitrationProcess> createState() => _ArbitrationProcessState();
}

class _ArbitrationProcessState extends State<ArbitrationProcess> {
  bool _isHindi = false;

  // Helper method to get translated text based on the selected language
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ArbitrationScreen(),
              ),
            );
          },
        ),
        title: Text(
          translate('Arbitration Process', 'मध्यस्थता प्रक्रिया'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              _isHindi ? Icons.language : Icons.translate,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isHindi = !_isHindi;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                translate('Welcome, Rahul', 'स्वागत है, राहुल'),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),

              // Main Action Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildActionButton(
                      label: translate(
                        'Start New Arbitration',
                        'नई मध्यस्थता शुरू करें',
                      ),
                      onPressed: () {
                        // Action to initiate arbitration
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildActionButton(
                      label: translate('My Cases', 'मेरे मामले'),
                      onPressed: () {
                        // Navigate to ongoing cases
                      },
                    ),
                    const SizedBox(width: 10),
                    _buildActionButton(
                      label: translate('Legal Assistance', 'कानूनी सहायता'),
                      onPressed: () {
                        // Navigate to legal assistance
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Recent Notifications Section
              _buildSectionTitle('Recent Notifications', 'हाल की सूचनाएं'),
              SizedBox(
                height: 140,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(translate('Hearing Scheduled for 12/12/2024',
                          'सुनवाई 12/12/2024 के लिए निर्धारित')),
                      subtitle: Text(translate('Check your hearing details',
                          'अपनी सुनवाई का विवरण जांचें')),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to hearing details
                      },
                    ),
                    ListTile(
                      title: Text(translate('Response Received from Respondent',
                          'प्रतिवादी से प्रतिक्रिया प्राप्त हुई')),
                      subtitle: Text(translate(
                          'Review the response in your case',
                          'अपने मामले में प्रतिक्रिया की समीक्षा करें')),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to case response
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Case Tracker Section
              _buildSectionTitle('Case Tracker', 'मामले का ट्रैकर'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CaseTrackerStep(
                      step: translate('Initiated', 'आरंभ किया गया'),
                      isActive: true),
                  _CaseTrackerStep(
                      step: translate(
                          'Awaiting Response', 'प्रतिक्रिया की प्रतीक्षा'),
                      isActive: true),
                  _CaseTrackerStep(
                      step: translate('Hearing Scheduled', 'सुनवाई निर्धारित'),
                      isActive: false),
                ],
              ),
              const SizedBox(height: 30),

              // Quick Access Icons
              _buildSectionTitle('Quick Access', 'त्वरित पहुँच'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickAccessIcon(
                      icon: Icons.document_scanner,
                      label: translate('Documents', 'दस्तावेज़')),
                  _QuickAccessIcon(
                      icon: Icons.schedule,
                      label: translate('Hearing', 'सुनवाई')),
                  _QuickAccessIcon(
                      icon: Icons.person,
                      label: translate('Arbitrators', 'मध्यस्थ')),
                  _QuickAccessIcon(
                      icon: Icons.feedback,
                      label: translate('Feedback', 'प्रतिक्रिया')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      child: Text(label,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildSectionTitle(String englishTitle, String hindiTitle) {
    return Text(
      translate(englishTitle, hindiTitle),
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
    );
  }
}

class _CaseTrackerStep extends StatelessWidget {
  final String step;
  final bool isActive;

  const _CaseTrackerStep({required this.step, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.deepPurple : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step[0], // Display first letter of the step
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            step,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _QuickAccessIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAccessIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 30, color: Colors.deepPurple),
            onPressed: () {
              // Action for quick access
            },
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
