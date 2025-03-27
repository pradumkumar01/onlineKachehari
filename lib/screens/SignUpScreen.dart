import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/toaster/toast.dart';
import 'package:flutter_online_kachehari/screens/LoginScreen.dart';
import 'package:flutter_online_kachehari/screens/alert.dart';
import 'package:flutter_online_kachehari/services/auth_service.dart';
import 'package:flutter_online_kachehari/services/notification_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final auth = Authservices();
  final NotificationService notificationService = NotificationService();

  // Controllers for the form fields
  final _controllerForName = TextEditingController();
  final _controllerForEmail = TextEditingController();
  final _controllerForMobile = TextEditingController();
  final _controllerForPassword = TextEditingController();
  final _controllerForConfirmPassword = TextEditingController();
  String _selectedGender = "Select Gender";
  bool _showPassword = false;

  // Multi-step navigation (6 steps total)
  int _currentStep = 0;
  final int _totalSteps = 6;

  @override
  void initState() {
    super.initState();
    notificationService.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar similar to AdvocateRegistration screen
      appBar: AppBar(
        title: const Text(
          'Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 60, 4, 213),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // If on the first step, simply pop.
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Step indicator row
              _buildStepIndicators(),
              const SizedBox(height: 20),
              // Form container
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo and tagline
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                            color: const Color.fromARGB(255, 60, 4, 213),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'आपका न्याय की ओर सफर यहीं से शुरू होता है\nRegister with Online Kachaheri!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 60, 4, 213),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Step-specific content
                          _buildStepContent(_currentStep),
                          const SizedBox(height: 24),
                          // Navigation Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Show Previous button if not on first step
                              if (_currentStep > 0)
                                _currentStep == _totalSteps - 1
                                    ? SizedBox()
                                    : ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentStep--;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 60, 4, 213),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: const Text(
                                          "Previous",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                              else
                                const SizedBox.shrink(),
                              // Next or Register button
                              _currentStep == _totalSteps - 1
                                  ? SizedBox()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (_currentStep < _totalSteps - 2) {
                                          // Advance to the next step
                                          setState(() {
                                            _currentStep++;
                                          });
                                        } else if (_currentStep ==
                                            _totalSteps - 2) {
                                          // On step 5 (index 4), process sign-up
                                          await signUp();
                                        } else {
                                          // Do nothing on Thank You step
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 60, 4, 213),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 40),
                                      ),
                                      child: Text(
                                        _currentStep == _totalSteps - 2
                                            ? "Register"
                                            : _currentStep == _totalSteps - 1
                                                ? "Login"
                                                : "Next",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          // On Thank You step, show additional login button if needed.
                          if (_currentStep == _totalSteps - 1)
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 60, 4, 213))),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: const Text(
                                'Go to Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the step indicators at the top.
  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (index) {
        bool isActive = index == _currentStep;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: isActive
                ? const Color.fromARGB(255, 37, 6, 105)
                : Colors.grey.shade300,
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

  /// Returns the content for each step.
  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        // Step 1: Name
        return _buildTextField(
          _controllerForName,
          'Enter your name',
          Icons.person,
        );
      case 1:
        // Step 2: Email
        return _buildTextField(
          _controllerForEmail,
          'Enter your E-mail',
          Icons.email,
          keyboardType: TextInputType.emailAddress,
        );
      case 2:
        // Step 3: Mobile Number
        return _buildTextField(
          _controllerForMobile,
          'Enter your mobile number',
          Icons.call,
          keyboardType: TextInputType.phone,
        );
      case 3:
        // Step 4: Gender
        return _buildGenderSelection();
      case 4:
        // Step 5: Password and Confirm Password
        return Column(
          children: [
            _buildTextField(
                _controllerForPassword, 'Enter your password', Icons.lock,
                isPassword: true),
            const SizedBox(height: 16),
            _buildTextField(_controllerForConfirmPassword,
                'Confirm your password', Icons.lock,
                isPassword: true),
          ],
        );
      case 5:
        // Step 6: Thank You screen
        return const Column(
          children: [
            Icon(Icons.check_circle,
                size: 80, color: Color.fromARGB(255, 60, 4, 213)),
            SizedBox(height: 16),
            Text(
              'Thank you for registering!\nYour account has been created.',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 4, 213)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Please click the Login button to continue.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  /// A custom text field widget.
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_showPassword : false,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromARGB(255, 60, 4, 213),
                ),
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
              )
            : null,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 60, 4, 213)),
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 60, 4, 213), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 60, 4, 213), width: 2.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  /// A gender selection dropdown.
  Widget _buildGenderSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: DropdownButtonFormField<String>(
        icon: Icon(
          _selectedGender == 'Select Gender'
              ? Icons.person_2_outlined
              : _selectedGender == 'Male'
                  ? Icons.male
                  : _selectedGender == 'Female'
                      ? Icons.female
                      : Icons.transgender,
          color: const Color.fromARGB(255, 60, 4, 213),
        ),
        value: _selectedGender,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 60, 4, 213), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 60, 4, 213), width: 2.0),
          ),
          border: InputBorder.none,
        ),
        items: <String>['Select Gender', 'Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
      ),
    );
  }

  /// Signs up the user using the provided details.
  Future<void> signUp() async {
    String name = _controllerForName.text.trim();
    String email = _controllerForEmail.text.trim();
    String password = _controllerForPassword.text.trim();
    String mobile = _controllerForMobile.text.trim();
    String cnfPassword = _controllerForConfirmPassword.text.trim();
    String gender = _selectedGender;

    // Validation for fields
    if (name.isEmpty) {
      showAlert(context, "Name is required");
      return;
    }
    if (email.isEmpty) {
      showAlert(context, "Email is required");
      return;
    }
    if (mobile.isEmpty) {
      showAlert(context, "Mobile is required");
      return;
    }
    if (password.isEmpty) {
      showAlert(context, "Password is required");
      return;
    }
    if (cnfPassword.isEmpty) {
      showAlert(context, "Confirm Password is required");
      return;
    }
    if (password != cnfPassword) {
      showAlert(context, "Password and Confirm Password do not match");
      return;
    }

    try {
      await auth.createUserWithDetails(
          name, email, password, mobile, cnfPassword, gender);

      // Show success message and notification
      showToaster("Signup successful!");

      await notificationService.showNotification(
          title: "Signup successful!",
          body: "You have successfully signed up to Online Kachehari.");

      DateTime dateNow = DateTime.now();
      await notificationService.saveNotificationToFirebase(
          userId: FirebaseAuth.instance.currentUser!.uid,
          title: "$name and $email",
          body: 'SignUp Successful',
          date: dateNow.toString());

      // After a successful sign up, advance to the Thank You step.
      setState(() {
        _currentStep = _totalSteps - 1; // move to step 5
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Signup failed.";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already registered.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is invalid.";
      }
      showAlert(context, errorMessage);
    } catch (e) {
      showAlert(context, "An unexpected error occurred. Please try again.");
    }
  }
}
