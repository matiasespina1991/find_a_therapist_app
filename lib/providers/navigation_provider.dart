import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  bool _isNavigating = false;

  bool get isNavigating => _isNavigating;

  void startNavigating() {
    _isNavigating = true;
    notifyListeners();
  }

  void stopNavigating() {
    _isNavigating = false;
    notifyListeners();
  }
}
