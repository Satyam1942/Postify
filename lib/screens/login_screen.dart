import 'dart:convert';
// import 'dart:js_util';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:project_hercules/screens/home_screen.dart';
import 'package:project_hercules/screens/register_screen.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<Login>? _futureLogin;

  Future<Login> login(String username, String password) async {
    final http.Response response = await http.post(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return Login.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
        Container(
          padding: (_futureLogin == null)? EdgeInsets.symmetric(vertical: 10.h, horizontal:25.w): EdgeInsets.symmetric(vertical: 50.h, horizontal:25.w),
            color: Color.fromARGB(83, 162, 207, 245),
          child: (_futureLogin == null)
              ?  buildLoginForm() : buildHomeScreen()
        )
        ]
      ),
    );
  }

    Widget buildLoginForm(){
      return    Card(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10))),
      child:  Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),
          Image.asset(
              "images/logo.png",
              height: 25.h,
              width: 25.w
          ),
          SizedBox(
            width: 30.w,
            height: 12.h,
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
          ),
          SizedBox(height: 2.h,),
          SizedBox(
              width: 30.w,
              height: 12.h,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              )),

          SizedBox(height: 4.h),

          ElevatedButton(
            onPressed: () {
              String username = _usernameController.text;
              String password = _passwordController.text;
              if(username=="" || password==""){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Cannot Login!!'),
                      content: Text('Enter All Details!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }else {
                setState(() {
                  _futureLogin = login(username, password);
                });
              }
            },
            child: Text('Log In'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(10.w, 8.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to the sign-up screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
              },
            child: Text('Don\'t have an account? \n \t Register Now'),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(10.w, 10.h),
                padding: EdgeInsets.symmetric(horizontal:5.w,vertical: 3.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10),
                        right: Radius.circular(10)))),
          ),
          SizedBox(height: 4.h,)
        ],
      ));
    }

    Widget buildHomeScreen(){
        return FutureBuilder<Login>(
          future: _futureLogin,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.hasData) {
              String? userId = snapshot.data?.userId;
              String? username = snapshot.data?.userName;

              WidgetsBinding.instance!.addPostFrameCallback((_) =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                        return HomePage(
                          userId: userId.toString(),
                          username: username.toString(),
                        );
                      }
                      )
                  )
              );

            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();

          },
        );
    }
}
