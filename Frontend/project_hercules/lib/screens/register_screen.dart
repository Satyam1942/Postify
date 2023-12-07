import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'Post.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  Future<User> registerUser(
      String name,
      int age,
      String gender,
      String username,
      String password,
      String Email,
      String DP,
      List<String> friends,
      List<String> followers,
      List<String> following,
      int phNo,
      List<String> friendRequestSent,
      List<String> friendRequestRecieved) async {
    final http.Response response = await http.post(
      Uri.parse("http://localhost:5000/personalInfo/addUser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "age": age,
        "gender": gender,
        "username": username,
        "password": password,
        "contact": {"PhNo": phNo, "Email": Email},
        "DP": DP,
        "friends": friends,
        "friendRequestSent": friendRequestSent,
        "friendRequestRecieved": friendRequestRecieved,
        "followers": followers,
        "following": following
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 409) {
      throw Exception(
          'User Already Exists. Status Code: ${response.statusCode}');
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User>? _futureUser;
  String imageURL="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_futureUser == null)
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/logo.png",
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _genderController,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()=>{_uploadImage()}, child: Text("Upload Image")),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      String name = _nameController.text;
                      int age = int.parse(_ageController.text);
                      String gender = _genderController.text;
                      String username = _usernameController.text;
                      String password = _passwordController.text;
                      String Email = _emailController.text;
                      String DP = imageURL;
                      List<String> friends = [];
                      List<String> followers = [];
                      List<String> following = [];
                      List<String> friendRequestSent = [];
                      List<String> friendRequestRecieved = [];
                      int phNo = 123;
                      setState(() {
                        _futureUser = registerUser(
                            name,
                            age,
                            gender,
                            username,
                            password,
                            Email,
                            DP,
                            friends,
                            followers,
                            following,
                            phNo,
                            friendRequestRecieved,
                            friendRequestSent);
                      });

                      // Perform registration action
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the login screen
                      Navigator.pop(context);
                    },
                    child: Text('Already have an account? Log in'),
                  ),
                ],
              ),
            )
          : FutureBuilder<User>(
              future: _futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String? userId = snapshot.data?.userId;
                  String? username = snapshot.data?.username;
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
    );
  }
  void _uploadImage() async {

    final picker = ImagePicker();
    XFile? _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {

      Uint8List  imageBytes = await _pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);
     imageURL =  base64Image;

    } else {
      // No image selected
      print('No image selected');
      imageURL="";
    }
  }
}
