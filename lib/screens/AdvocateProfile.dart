import 'package:flutter/material.dart';

class AdvocateRegistration extends StatefulWidget {
  const AdvocateRegistration({Key? key}) : super(key: key);

  @override
  State<AdvocateRegistration> createState() => _AdvocateRegistrationState();
}

class _AdvocateRegistrationState extends State<AdvocateRegistration> {
  // Current step: 0-based index (0..7)
  int _currentStep = 0;

  // Controllers and variables for form fields
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'Male';

  // Example for date of birth
  // Lists of months, days, and years
  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

// Generate 1..31
  final List<String> _days =
      List.generate(31, (index) => '${index + 1}'.padLeft(2, '0'));

// Generate 1970..2019 (for example)
  final List<String> _years = List.generate(50, (index) => '${1970 + index}');

// Indices to keep track of which item is selected
  int _selectedMonthIndex = 4; // 0 => 'Jan'
  int _selectedDayIndex = 3; // 0 => '01'
  int _selectedYearIndex = 30; // 30 => '2000' in the _years list

  // Example phone usage
  bool _useIphone = false;
  bool _useAndroid = false;

  // Selected languages
  List<String> _selectedLanguages = [];

  //Selected Specialization
  List<String> _selectedSkills = [];

  // A sample token number
  final String _tokenNumber = '296435';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Advocate Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentStep == 0) {
              Navigator.pop(context);
            } else {
              setState(() {
                _currentStep--;
              });
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Step indicators at the top
            _buildStepIndicators(),
            const SizedBox(height: 20),
            // Expanded content area for each step
            Expanded(child: _buildStepContent(_currentStep)),
            // Previous / Next Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        bool isActive = index == _currentStep;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor:
                isActive ? Colors.deepPurple.shade800 : Colors.grey.shade300,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    // If we are at the last step, show a different button
    if (_currentStep == 7) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // For the final screen, maybe navigate or do something
              // Here we just pop or do nothing
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade800,
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button
        ElevatedButton(
          onPressed: _currentStep == 0
              ? null // disable on first step
              : () {
                  setState(() {
                    _currentStep--;
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: _currentStep == 0
                ? Colors.grey.shade200
                : Colors.deepPurple.shade800,
          ),
          child: Text(
            'Previous',
            style: TextStyle(
              color: _currentStep == 0 ? Colors.grey : Colors.white,
            ),
          ),
        ),
        // Next button
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = (_currentStep + 1).clamp(0, 7);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple.shade800,
          ),
          child: const Text('Next', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildDateOfBirthStep();
      case 2:
        return _buildGenderStep();
      case 3:
        return _buildLanguagesStep();
      case 4:
        return _buildSkillsStep();
      case 5:
        return _buildProfilePictureStep();
      case 6:
        return _buildPhoneUsageStep();
      case 7:
        return _buildThankYouStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 1: Name
  Widget _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name (नाम)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Date of Birth
  Widget _buildDateOfBirthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth (जन्म तिथि)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Container with a fixed height to hold the "wheel" pickers
        Container(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Month Wheel
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  // This controller lets you set the initial item
                  controller: FixedExtentScrollController(
                      initialItem: _selectedMonthIndex),
                  itemExtent: 40,
                  perspective: 0.002, // Slight 3D effect
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMonthIndex = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      // If index is out of range, return null
                      if (index < 0 || index >= _months.length) return null;

                      final bool isSelected = (index == _selectedMonthIndex);
                      return Center(
                        child: Text(
                          _months[index],
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.blue.shade800
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                    childCount: _months.length,
                  ),
                ),
              ),

              // Day Wheel
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: FixedExtentScrollController(
                      initialItem: _selectedDayIndex),
                  itemExtent: 40,
                  perspective: 0.002,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= _days.length) return null;

                      final bool isSelected = (index == _selectedDayIndex);
                      return Center(
                        child: Text(
                          _days[index],
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.blue.shade800
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                    childCount: _days.length,
                  ),
                ),
              ),

              // Year Wheel
              Expanded(
                child: ListWheelScrollView.useDelegate(
                  controller: FixedExtentScrollController(
                      initialItem: _selectedYearIndex),
                  itemExtent: 40,
                  perspective: 0.002,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedYearIndex = index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      if (index < 0 || index >= _years.length) return null;

                      final bool isSelected = (index == _selectedYearIndex);
                      return Center(
                        child: Text(
                          _years[index],
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.blue.shade800
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                    childCount: _years.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 3: Gender
  Widget _buildGenderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender (लिंग)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        RadioListTile<String>(
          title: const Text('Male'),
          value: 'Male',
          groupValue: _selectedGender,
          onChanged: (val) {
            setState(() {
              _selectedGender = val!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Female'),
          value: 'Female',
          groupValue: _selectedGender,
          onChanged: (val) {
            setState(() {
              _selectedGender = val!;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Other'),
          value: 'Other',
          groupValue: _selectedGender,
          onChanged: (val) {
            setState(() {
              _selectedGender = val!;
            });
          },
        ),
      ],
    );
  }

  // Step 4: Languages
  Widget _buildLanguagesStep() {
    // In a real app, you might have a list of languages that you can select/deselect
    // For the sake of the UI, let's just show placeholders as in your screenshot
    final List<String> leftColumn = [
      'English',
      'Tamil',
      'Marathi',
      'Bengali',
      'Odia',
      'Kannada',
      'Assamese',
      'German',
      'Maithili',
      'Nepali',
    ];
    final List<String> rightColumn = [
      'Hindi',
      'Punjabi',
      'French',
      'Telugu',
      'Malayalam',
      'Sanskrit',
      'Manipuri',
      'Sindhi',
      'Bodo',
      'Arabic',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Languages (भाषाएँ)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
            children: [
              // Left column
              Expanded(
                child: ListView.builder(
                  itemCount: leftColumn.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(leftColumn[index]),
                      trailing: _selectedLanguages.contains(leftColumn[index])
                          ? Icon(
                              Icons.check,
                            )
                          : Icon(Icons.add),
                      onTap: () {
                        setState(() {
                          if (_selectedLanguages.contains(leftColumn[index])) {
                            _selectedLanguages.remove(leftColumn[index]);
                          } else {
                            _selectedLanguages.add(leftColumn[index]);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              // const VerticalDivider(width: 1),
              // Right column
              Expanded(
                child: ListView.builder(
                  itemCount: rightColumn.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(rightColumn[index]),
                      trailing: _selectedLanguages.contains(rightColumn[index])
                          ? Icon(
                              Icons.check,
                            )
                          : Icon(Icons.add),
                      onTap: () {
                        setState(() {
                          if (_selectedLanguages.contains(rightColumn[index])) {
                            _selectedLanguages.remove(rightColumn[index]);
                          } else {
                            _selectedLanguages.add(rightColumn[index]);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 5: Skills
  Widget _buildSkillsStep() {
    // Similar approach: placeholders to replicate the UI
    final List<String> skills = [
      "Criminal Law",
      "Family Law",
      "Corporate Law",
      "Property Law",
      "Civil Law",
      "Intellectual Property Law",
      "Tax Law"
    ];

    // In a real app, you might store selected skills in a List<bool> or something similar
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specialization (विशेषज्ञता)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 7,
            ),
            itemCount: skills.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(skills[index]),
                trailing: _selectedSkills.contains(skills[index])
                    ? Icon(Icons.check)
                    : Icon(Icons.add),
                onTap: () {
                  setState(() {
                    if (_selectedSkills.contains(skills[index])) {
                      _selectedSkills.remove(skills[index]);
                    } else {
                      _selectedSkills.add(skills[index]);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Step 6: Profile Picture
  Widget _buildProfilePictureStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Profile Picture (प्रोफाइल फोटो)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Stack(
          alignment: Alignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.blue),
                  onPressed: () {
                    // Handle picking an image
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Make sure your profile picture has your face in the center and wear your best clothes for a great first impression!',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Step 7: Which phone do you use?
  Widget _buildPhoneUsageStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Which phone do you use? (आप कौन सा फोन इस्तेमाल करते हैं)*',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Two “cards” with plus sign, similar to the screenshot
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _useIphone = !_useIphone;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _useIphone ? Colors.blue.shade800 : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('iPhone'),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.add,
                      color: _useIphone ? Colors.blue.shade800 : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _useAndroid = !_useAndroid;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _useAndroid ? Colors.blue.shade800 : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text('Android'),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.add,
                      color: _useAndroid ? Colors.blue.shade800 : Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Step 8: Thank You screen
  Widget _buildThankYouStep() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // "Thank you" image or text
            const Text(
              'Thank you!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Thank you for submitting your details with Online Kachehari!\nYour token number is $_tokenNumber.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Please note that you will be notified about any updates both via WhatsApp and email.\n\n'
              'For further details, feel free to reach out to us via email at onboarding@casemates.com. '
              'Looking forward to having you on board!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
