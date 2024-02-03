
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_hercules/screens/bottom.dart';
import 'package:project_hercules/screens/login_screen.dart';
import 'package:project_hercules/utils/app_styles.dart';

void main() {
  runApp(const MyApp());
 
 

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Postify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
