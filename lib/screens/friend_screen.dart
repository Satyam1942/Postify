import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/profile_screen.dart';
import 'Post.dart';
import 'package:http/http.dart' as http;
import 'chat_room.dart';

class FriendsPage extends StatefulWidget {
  final String userId;
  final String username;
  final List<String> following;
  final List<String> friendRequestSent;
  final List<String> friends;
  final List<String> friendRequestRecieved;

  const FriendsPage(
      {required this.userId,
      required this.username,
      required this.following,
      required this.friends,
      required this.friendRequestSent,
      required this.friendRequestRecieved});
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {

  Future<User?> getUser(String eachUserId) async {
    final String url =
        "https://postifybackend.onrender.com/personalInfo/getUserById/" + eachUserId;

    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    if (responseData.toString() != "null") {
      Contact contact = new Contact(PhNo: "123", Email: responseData['contact']['Email']);

      List<String> friends = [];
      List<String> followers = [];
      List<String> following = [];
      List<String> friendRequestSent = [];
      List<String> friendRequestRecieved = [];

      if (responseData['friends'].length != 0) {
        for (var eachFriend in responseData['friends']) {
          friends.add(eachFriend.toString());
        }
      }

      if (responseData['followers'].length != 0) {
        for (var eachFollower in responseData['followers']) {
          followers.add(eachFollower.toString());
        }
      }

      if (responseData['following'].length != 0) {
        for (var eachFollowing in responseData['following']) {
          following.add(eachFollowing.toString());
        }
      }

      if (responseData['friendRequestSent'].length != 0) {
        for (var eachFriendRequestSent in responseData['friendRequestSent']) {
          friendRequestSent.add(eachFriendRequestSent.toString());
        }
      }

      if (responseData['friendRequestRecieved'].length != 0) {
        for (var eachFriendRequestRecieved
            in responseData['friendRequestRecieved']) {
          friendRequestRecieved.add(eachFriendRequestRecieved.toString());
        }
      }

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
          friendRequestRecieved: friendRequestRecieved
      );
      return user;
    } else {
      User user = new User(
          userId: "null",
          username: "null",
          name: "null",
          age: 1,
          gender: "null",
          contact: new Contact(PhNo: "null", Email: "null"),
          DP: "null",
          friends: [],
          followers: [],
          following: [],
          friendRequestSent: [],
          friendRequestRecieved: []);
      return user;
    }
  }

  Future<List<Future<User?>>> getFriend() async {

    final String url = "https://postifybackend.onrender.com/personalInfo/getUserById/" + widget.userId;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    List<Future<User?>> listUser = [];
    for (var eachUserId in responseData['friends']) {
      Future<User?> us = getUser(eachUserId);
      listUser.add(us);
    }
    return listUser;
  }

  Future<List<User?>> fetchUsers(List<Future<User?>> usersList) async {
    List<User?> users = [];
    for (var element in usersList) {
      User? user = await element;
      if (user!.username != "null") users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
        ),
        body: FutureBuilder(
            future: getFriend(),
            builder: (context, snapshot) {
              var usersList = snapshot.data;

              if (usersList != null) {
                return FutureBuilder(
                    future: fetchUsers(usersList),
                    builder: (context, userSnapshot) {
                      var users =  userSnapshot.data;
                      if (users != null) {
                        return ListView.builder(
                          padding: EdgeInsetsDirectional.only(top: 20.0),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            String friendName = users[index]!.username;
                            return Container(
                                child: Card(
                                    color: Colors.white,
                                    child: ListTile(
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: -30,
                                          right: 20,
                                          top: 20,
                                          bottom: 20),
                                      title: Text(friendName),
                                      leading: CircleAvatar(
                                        radius: 20.0,
                                        child: ClipOval(
                                            child: Stack(children: [
                                          if (users[index]!.DP != "")
                                            Image.network(
                                              users[index]!.DP,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                        ])),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.message_rounded),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                      userId: widget.userId,
                                                      userName: widget.username,
                                                      friendName: friendName,
                                                      friendId: users[index]!.userId,
                                                      friendDP: users[index]!.DP,
                                                    )
                                            ),
                                          );
                                        },
                                      ),

                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileScreen(
                                                    userIdFriend:
                                                        users[index]!.userId,
                                                    userIdHead: widget.userId,
                                                    following: widget.following,
                                                    friendRequestSent: widget
                                                        .friendRequestSent,
                                                    friends: widget.friends,
                                                    friendRequestRecieved: widget
                                                        .friendRequestRecieved,
                                                  )),
                                        );
                                      },
                                    )));
                          },
                        );
                      } else {
                        return Container(
                            child: Center(child: Text("No Friends")));
                      }
                    });
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}
