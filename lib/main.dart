import 'package:flutter/material.dart';
import 'login_page.dart';
import 'note_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteService().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}