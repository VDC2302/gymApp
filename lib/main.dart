import 'package:gymApp/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.delayed(
    const Duration(milliseconds: 800),
    () => runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      ),
  );
}
