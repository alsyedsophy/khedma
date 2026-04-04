import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khedma/app/dependenc_injections.dart' as di;
import 'package:khedma/app/my_app.dart';
import 'package:khedma/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}
