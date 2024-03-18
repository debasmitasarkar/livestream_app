import 'package:flutter/material.dart';
import 'package:livestream_example/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: LoginPage()));
}

