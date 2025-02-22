import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class NotaryProcess extends StatefulWidget {
  const NotaryProcess({super.key});

  @override
  _NotaryProcessState createState() => _NotaryProcessState();
}

class _NotaryProcessState extends State<NotaryProcess> {
  bool _isHindi = false;

  // Helper method for translations
  String translate(String englishText, String hindiText) {
    return _isHindi ? hindiText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Notary Process', 'नोटरी प्रक्रिया'),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Text(
                translate('Notary Services', 'नोटरी सेवाएँ'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),

              // Upload Document Section
              _buildCard(
                title: translate('Upload Document', 'दस्तावेज़ अपलोड करें'),
                description: translate(
                  'Upload the document you want to notarize.',
                  'वह दस्तावेज़ अपलोड करें जिसे आप नोटरी करना चाहते हैं।',
                ),
                icon: Icons.upload_file,
                buttonLabel: translate('Upload', 'अपलोड करें'),
                onPressed: _uploadDocument,
              ),
              const SizedBox(height: 20),

              // Schedule Appointment Section
              _buildCard(
                title: translate(
                  'Schedule Notary Appointment',
                  'नोटरी अपॉइंटमेंट शेड्यूल करें',
                ),
                description: translate(
                  'Select a date and time for your notary appointment.',
                  'अपनी नोटरी अपॉइंटमेंट के लिए तारीख और समय चुनें।',
                ),
                icon: Icons.calendar_today,
                buttonLabel: translate('Schedule', 'शेड्यूल करें'),
                onPressed: _scheduleAppointment,
              ),
              const SizedBox(height: 20),

              // Track Notarization Progress Section
              _buildCard(
                title: translate(
                  'Track Notarization Progress',
                  'नोटरी प्रगति ट्रैक करें',
                ),
                description: translate(
                  'Check the current status of your notarization.',
                  'अपनी नोटरीकरण की वर्तमान स्थिति देखें।',
                ),
                icon: Icons.track_changes,
                buttonLabel: translate('Track', 'ट्रैक करें'),
                onPressed: _trackProgress,
              ),
              const SizedBox(height: 20),

              // Completed Notarizations Section
              Text(
                translate('Completed Notarizations', 'पूर्ण नोटरीकरण'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 10),
              _buildCompletedNotarizationsList(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to create cards for sections
  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.deepPurple),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(description),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonLabel,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of Completed Notarizations
  Widget _buildCompletedNotarizationsList() {
    List<Map<String, String>> completedNotarizations = [
      {'title': 'Property Agreement', 'date': '02/12/2024'},
      {'title': 'Affidavit Submission', 'date': '28/11/2024'},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: completedNotarizations.length,
      itemBuilder: (context, index) {
        final notarization = completedNotarizations[index];
        return ListTile(
          leading: const Icon(Icons.description, color: Colors.deepPurple),
          title: Text(notarization['title']!),
          subtitle: Text(translate(
            'Completed on: ${notarization['date']}',
            'पूरा किया गया: ${notarization['date']}',
          )),
        );
      },
    );
  }

  Future<void> _uploadDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(translate('Document uploaded successfully!',
                  'दस्तावेज़ सफलतापूर्वक अपलोड किया गया!'))),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(translate('No document selected.',
                'कोई दस्तावेज़ चयनित नहीं किया गया।'))),
      );
    }
  }

  void _scheduleAppointment() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(translate('Appointment scheduled successfully!',
              'अपॉइंटमेंट सफलतापूर्वक शेड्यूल की गई!'))),
    );
  }

  void _trackProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(translate(
              'Tracking progress...', 'प्रगति ट्रैक की जा रही है...'))),
    );
  }
}
