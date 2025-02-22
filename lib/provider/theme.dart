// import 'dart:ffi';

import 'package:flutter/material.dart';

class ThemeProviderState extends ChangeNotifier {
  bool isDarkMode = false;

  void changeTheme() {
    isDarkMode = !isDarkMode; // Toggle dark mode state
    notifyListeners(); // Notify listeners about the change
  }
}
