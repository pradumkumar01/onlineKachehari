import 'package:flutter/material.dart';

class MediationProcess extends StatefulWidget {
  const MediationProcess({super.key});

  @override
  _MediationProcessState createState() => _MediationProcessState();
}

class _MediationProcessState extends State<MediationProcess> {
  bool _isHindi = false;

  // Helper method to get translated text
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Mediation Process', 'मध्यस्थता प्रक्रिया'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mediator Information Section
            Text(
              translate('Mediator', 'मध्यस्थ'),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                translate('Mr. Rajesh Sharma', 'श्री राजेश शर्मा'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                translate('Certified Mediator', 'प्रमाणित मध्यस्थ'),
              ),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                // Navigate to detailed mediator profile
              },
            ),
            const SizedBox(height: 20),

            // Case Details Section
            Text(
              translate('Case Details', 'मामले का विवरण'),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate('Case ID: 123456', 'मामला आईडी: 123456'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translate('Dispute: Land Ownership Conflict',
                          'विवाद: भूमि स्वामित्व विवाद'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translate('Status: Awaiting First Mediation',
                          'स्थिति: पहली मध्यस्थता की प्रतीक्षा'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Live Communication Options
            Text(
              translate('Communicate', 'संचार'),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCommunicationButton(
                  icon: Icons.video_call,
                  label: translate('Video Call', 'वीडियो कॉल'),
                  onPressed: () {
                    // Navigate to video call screen
                  },
                ),
                _buildCommunicationButton(
                  icon: Icons.chat,
                  label: translate('Live Chat', 'लाइव चैट'),
                  onPressed: () {
                    // Navigate to live chat screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Actions Section
            Text(
              translate('Actions', 'कार्यवाही'),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  label: translate('Track Case', 'मामले का ट्रैक करें'),
                  onPressed: () {
                    // Navigate to case tracker
                  },
                ),
                _buildActionButton(
                  label: translate('Submit Evidence', 'साक्ष्य जमा करें'),
                  onPressed: () {
                    // Navigate to evidence submission
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create communication buttons
  Widget _buildCommunicationButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 40, color: Colors.deepPurple),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

  // Helper method to create action buttons with consistent styling
  Widget _buildActionButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
