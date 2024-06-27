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
      Uri.parse("https://postifybackend.onrender.com/personalInfo/addUser"),
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
          'Username Already Exists. Status Code: ${response.statusCode}');
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User>? _futureUser;
  String imageURL="";
  bool isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    var screenSizeHorizontal = MediaQuery.sizeOf(context).width;
    var screenSizeVertical = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: (_futureUser == null)
          ?ListView(
          children:<Widget>[
        Container(
              padding: EdgeInsets.symmetric(horizontal: screenSizeHorizontal/10,vertical: screenSizeVertical/10),
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
                  (isUploadingImage)?CircularProgressIndicator():
                  ElevatedButton(
                    onPressed:() {
                      try {
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
                        if (name == "" || gender == "" || DP=="" || username == "" ||
                            password == "" || Email == "") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Cannot Register!!'),
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
                        } else {
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
                        }
                      }catch(e){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Cannot Register!!'),
                              content: Text('Enter valid age'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      // Perform registration action
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Already have an account? Log in'),
                  ),
                ],
              ),
            )])
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
                  return Center(child:Text('${snapshot.error}'));
                }
                return Center(child: const CircularProgressIndicator());
              },
            ),
    );
  }
  void _uploadImage() async {

    final picker = ImagePicker();
    XFile? _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      Uint8List fileBytes = await _pickedImage.readAsBytes();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/dhrde70mt/image/upload'),
      );
      request.fields['upload_preset'] = 'ml_default';
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename:_pickedImage.name,
        ),
      );
      setState(() {
        isUploadingImage = true;
      });
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var resultData = json.decode(utf8.decode(responseData));

      setState(() {
        imageURL = resultData['secure_url'];
        isUploadingImage = false;
      });

    } else {
      print('No image selected');
    }
  }
}
