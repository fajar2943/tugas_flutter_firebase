import 'package:flutter/material.dart';
import 'package:tugas_firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tugas_firebase/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TodoPage();
  }
}
