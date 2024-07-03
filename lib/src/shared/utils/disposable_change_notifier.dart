import 'package:flutter/material.dart';

abstract class DisposableChangeNotifier extends ChangeNotifier {
  void disposeValues();
}
