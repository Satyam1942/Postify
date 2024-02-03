import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'Post.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class ProfilePage extends StatefulWidget {
  String userId, username;
  ProfilePage({required this.userId, required this.username});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = 'John Doe';
  String email = 'johndoe@example.com';
  int age = 25;
  String gender = 'Male';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    String DP="";
  Future<User> getUser() async {
    final String url =
        "https://postifybackend.onrender.com/personalInfo/getUserById/" + widget.userId;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    Contact contact = new Contact(
        PhNo: responseData['contact']['PhNo'].toString(),
        Email: responseData['contact']['Email']);
    List<String> friends = [];
    List<String> followers = [];
    List<String> following = [];
    List<String> friendRequestSent = [];
    List<String> friendRequestRecieved = [];

    for (var eachFriend in responseData['friends']) {
      friends.add(eachFriend);
    }
    for (var eachFollower in responseData['followers']) {
      followers.add(eachFollower);
    }
    for (var eachFollowing in responseData['following']) {
      following.add(eachFollowing);
    }

    if (responseData['friendRequestSent'].length != 0)
      for (var eachFriendRequestSent in responseData['friendRequestSent'])
        friendRequestSent.add(eachFriendRequestSent.toString());
    if (responseData['friendRequestRecieved'].length != 0)
      for (var eachFriendRequestRecieved
          in responseData['friendRequestRecieved'])
        friendRequestRecieved.add(eachFriendRequestRecieved.toString());

    User user = new User(
        userId: responseData['_id'],
        username: responseData['username'],
        name: responseData['name'],
        age: responseData['age'],
        gender: responseData['gender'],
        contact: contact,
        DP: responseData['DP'],
        friends: friends,
        followers: followers,
        following: following,
        friendRequestSent: friendRequestSent,
        friendRequestRecieved: friendRequestRecieved);
    return user;
  }

  Future<User> updateUser(
      String name, int age, String gender, String Email,String DP) async {
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "name": name,
        "age": age,
        "gender": gender,
        "contact": {"Email": Email},
        "DP":DP
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> updateUserPassword(String password) async {
    final http.Response response = await http.patch(
      Uri.parse(
          "https://postifybackend.onrender.com/personalInfo//updateUserPasswordById/" +
              widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> deleteUser() async {
    final http.Response response = await http.delete(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/deleteUserById/" +
          widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User>? _futureUser;
  Future<User>? _deleteFutureUser;
  Future<User>? _futurePassword;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    genderController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void deleteAccount() {
    _deleteFutureUser = deleteUser();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen();
            })));
  }

  void updateProfile() {
    setState(() {
      name = nameController.text;
      email = emailController.text;
      age = int.parse(ageController.text);
      gender = genderController.text;

      _futureUser = updateUser(name, age, gender, email,DP);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage(
                  userId: widget.userId,
                  username: widget.username,
                );
              })));
    });
  }

  void updatePassword() {
    setState(() {
      String password = passwordController.text;
      _futurePassword = updateUserPassword(password);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HomePage(
                  userId: widget.userId,
                  username: widget.username,
                );
              })));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (user != null) {
                nameController.text = user.name;
                emailController.text = user.contact.Email;
                ageController.text = user.age.toString();
                genderController.text = user.gender;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                    ),
                    TextField(
                      controller: genderController,
                      decoration: InputDecoration(labelText: 'Gender'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(onPressed: ()=>{_uploadImage()}, child: Text("Upload DP")),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Update Profile'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatePassword,
                      child: Text('Change Password'),
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: deleteAccount,
                      child: Text('Delete Account'),
                    ),
                    SizedBox(height: 16),
                  ],
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ),
    );
  }
  void _uploadImage() async {
    final picker = ImagePicker();
    XFile? _pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (_pickedImage != null) {
      Uint8List imageBytes = await _pickedImage.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      DP = base64Image;
    } else {
      // No image selected
      print('No image selected');
      DP = "";
    }
  }
}
