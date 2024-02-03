import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.dart';

class ProfileScreen extends StatefulWidget {
  final String userId; // The userId of the friend
  final String userIdHead;
  final List<String> following;
  final List<String> friendRequestSent;
  final List<String> friendRequestRecieved;
  final List<String> friends;

  ProfileScreen(
      {required this.userId,
      required this.userIdHead,
      required this.following,
      required this.friendRequestSent,
      required this.friends,
      required this.friendRequestRecieved});
  @override
  _ProfileScreenState createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Simulated data for the friend's profile
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

    if (responseData['friends'].length != 0) {
      for (var eachFriend in responseData['friends'])
        friends.add(eachFriend.toString());
    }
    if (responseData['followers'].length != 0)
      for (var eachFollower in responseData['followers'])
        followers.add(eachFollower.toString());
    if (responseData['following'].length != 0)
      for (var eachFollowing in responseData['following'])
        following.add(eachFollowing.toString());
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

  Future<User>? _futureFriend,
      _futureUser,
      _friendRequestSent,
      _friendRequestRecieved,
      _acceptFriendRequest;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: FutureBuilder(
            future: getUser(),
            builder: (context, snapshot) {
              var user = snapshot.data;
              if (user != null) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            child:ClipOval(
                                child:Stack(
                                    children:[
                                      if(user.DP!="")
                                        Image.memory(base64Decode(user.DP),
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,),

                                    ])),
                          ),
                          SizedBox(height: 16),
                          Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user.contact.Email,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user.username,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if ((!user.friends.contains(widget.userIdHead)) &&
                                (!user.friendRequestSent
                                    .contains(widget.userIdHead))) {
                              setState(() {
                                _friendRequestSent = updateFriendRequestSent(
                                    widget.friendRequestSent);
                                _friendRequestRecieved =
                                    updateFriendRequestRecieved(
                                        user.friendRequestRecieved);
                                WidgetsBinding.instance.addPostFrameCallback((_) =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            super.widget)));
                              });
                            } else if (!user.friends
                                    .contains(widget.userIdHead) &&
                                user.friendRequestSent
                                    .contains(widget.userIdHead))
                              setState(() {
                                _acceptFriendRequest = updateFriends(
                                    widget.friends,
                                    user.friends,
                                    user.friendRequestSent,
                                    widget.friendRequestRecieved);
                                WidgetsBinding.instance.addPostFrameCallback((_) =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                            super.widget)));
                              });
                            else
                              return null;
                          },
                          child: buildFriends(context, user),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed:
                                (!user.followers.contains(widget.userIdHead))
                                    ? () {
                                        setState(() {
                                          _futureUser =
                                              updateFollowing(widget.following);
                                          _futureFriend =
                                              updateFollower(user.followers);
                                        });
                                      }
                                    : null,
                            child: Text("Follow")),
                      ],
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Friends: ' + user.friends.length.toString()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                          'Followers: ' + user.followers.length.toString()),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                          'Following: ' + user.following.length.toString()),
                    ),
                  ],
                );
              } else {
                return Container(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              }
            }));
  }

  Widget buildFriends(BuildContext context, var user) {
    return Builder(
      builder: (context) {
        if ((!user.friends.contains(widget.userIdHead)) &&
            (!user.friendRequestSent.contains(widget.userIdHead))) {
          return Text("Send Friend Request");
        } else if (user.friendRequestRecieved.contains(widget.userIdHead) &&
            !user.friends.contains(widget.userIdHead)) {
          return Text("Request Sent! Not Accepted Yet.");
        } else if (user.friends.contains(widget.userIdHead)) {
          return Text("Already a friend!");
        } else if (!user.friends.contains(widget.userIdHead) &&
            user.friendRequestSent.contains(widget.userIdHead)) {
          print("YES");
          return Text(
              "Accept Friend Request"); // Return an empty container or null if none of the conditions are met
        } else
          return Container();
      },
    );
  }

  Future<User> updateFollowing(List<String> followingUser) async {
    followingUser.add(widget.userId);
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userIdHead),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{'following': followingUser}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> updateFollower(List<String> followerFriend) async {
    followerFriend.add(widget.userIdHead);
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{'followers': followerFriend}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> updateFriendRequestSent(List<String> friendRequestSent) async {
    friendRequestSent.add(widget.userId);
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userIdHead),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <dynamic, dynamic>{'friendRequestSent': friendRequestSent}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> updateFriendRequestRecieved(
      List<String> friendRequestRecieved) async {
    friendRequestRecieved.add(widget.userIdHead);
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <dynamic, dynamic>{'friendRequestRecieved': friendRequestRecieved}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }

  Future<User> updateFriends(
      List<String> friendUserHead,
      List<String> friendUser,
      List<String> friendRequestSentUser,
      List<String> friendRequestRecievedUserHead) async {
    friendUser.add(widget.userIdHead);
    friendUserHead.add(widget.userId);
    friendRequestSentUser.remove(widget.userIdHead);
    friendRequestRecievedUserHead.remove(widget.userId);

    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'friends': friendUser,
        'friendRequestSent': friendRequestSentUser
      }),
    );

    final http.Response response2 = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/personalInfo/updateUserById/" +
          widget.userIdHead),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'friends': friendUserHead,
        'friendRequestRecieved': friendRequestRecievedUserHead
      }),
    );
    if (response.statusCode == 200 && response2.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }
}
