import 'package:flutter/material.dart';
import 'app/app.dart';
import 'data/services/note_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteService().init();
  runApp(const MyApp());
}