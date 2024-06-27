
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_hercules/screens/bottom.dart';
import 'package:sizer/sizer.dart';
import 'package:project_hercules/screens/login_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:project_hercules/utils/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp( title: 'Postify',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: LoginScreen(),);
        }
    );
  }
}
