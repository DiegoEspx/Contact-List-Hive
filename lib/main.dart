import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_hive/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  // Abre la caja de Hive
  await Hive.openBox('Contact list');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CONTACT LIST',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ContactsPage(),
    );
  }
}
