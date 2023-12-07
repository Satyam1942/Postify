import 'dart:convert';
import 'dart:js_util';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:project_hercules/screens/home_screen.dart';
import 'package:project_hercules/screens/register_screen.dart';

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

  Future<Login> login(String username, String password) async {
    final http.Response response = await http.post(
      Uri.parse("http://localhost:5000/personalInfo/login"),
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

  Future<Login>? _futureLogin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 500),
          color: Color.fromARGB(83, 162, 207, 245),
          child: Card(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              alignment: Alignment.center,
              child: (_futureLogin == null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/logo.png",
                          height: 250,
                          width: 250,
                        ),
                        SizedBox(
                          width: 400,
                          height: 75,
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0, width: 50),
                        SizedBox(
                            width: 400,
                            height: 75,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                            )),
                        SizedBox(height: 50.0, width: 50.0),
                        ElevatedButton(
                          onPressed: () {
                            // Perform login action
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            setState(() {
                              _futureLogin = login(username, password);
                            });
                          },
                          child: Text('Log In'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(40, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0))),
                        ),
                        SizedBox(height: 30.0, width: 50.0),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the sign-up screen
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: Text('Don\'t have an account? Register Now'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(80, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(10),
                                      right: Radius.circular(10)))),
                        ),
                      ],
                    )
                  : FutureBuilder<Login>(
                      future: _futureLogin,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String? userId = snapshot.data?.userId;
                          String? username = snapshot.data?.userName;
                          print(userId.toString());
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return HomePage(
                                  userId: userId.toString(),
                                  username: username.toString(),
                                );
                              })));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
            ),
          )),
    );
  }
}
