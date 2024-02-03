import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_hercules/screens/profile_screen.dart';
import 'dart:convert';

import 'Post.dart';

class SearchScreen extends StatefulWidget {
  String searchKey, userId;
  List<String> following;
  final List<String> friendRequestSent;
  final List<String> friendRequestRecieved;
  final List<String> friends;
  SearchScreen(
      {required this.searchKey,
      required this.userId,
      required this.following,
      required this.friendRequestSent,
      required this.friends,
      required this.friendRequestRecieved});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  Future<List<User>> searchUser() async {
    final String url =
        "https://postifybackend.onrender.com/personalInfo/search/" + widget.searchKey;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    List<User> users = [];
    for (var eachUser in responseData) {
      Contact contact = new Contact(
          PhNo: eachUser['contact']['PhNo'].toString(),
          Email: eachUser['contact']['Email']);
      List<String> friends = [];
      List<String> followers = [];
      List<String> following = [];
      List<String> friendRequestSent = [];
      List<String> friendRequestRecieved = [];

      if (eachUser['friends'].length != 0) {
        for (var eachFriend in eachUser['friends'])
          friends.add(eachFriend.toString());
      }
      if (eachUser['followers'].length != 0)
        for (var eachFollower in eachUser['followers']) {
          followers.add(eachFollower.toString());
        }
      if (eachUser['following'].length != 0) {
        for (var eachFollowing in eachUser['following']) {
          following.add(eachFollowing.toString());
        }
      }

      if (eachUser['friendRequestSent'].length != 0)
        for (var eachFriendRequestSent in eachUser['friendRequestSent'])
          friendRequestSent.add(eachFriendRequestSent.toString());

      if (eachUser['friendRequestRecieved'].length != 0)
        for (var eachFriendRequestRecieved in eachUser['friendRequestRecieved'])
          friendRequestRecieved.add(eachFriendRequestRecieved.toString());

      User user = new User(
          userId: eachUser['_id'],
          username: eachUser['username'],
          name: eachUser['name'],
          age: eachUser['age'],
          gender: eachUser['gender'],
          contact: contact,
          DP: eachUser['DP'],
          friends: friends,
          followers: followers,
          following: following,
          friendRequestSent: friendRequestSent,
          friendRequestRecieved: friendRequestRecieved);
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            // child: TextField(
            //   controller: _searchController,
            //   onChanged: changeSeachKey(_searchController.text) ,
            //   decoration: InputDecoration(
            //     hintText: 'Search...',
            //   ),
            // ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: searchUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {

                      List<User>? listUsers = snapshot.data;
                      return ListView.builder(
                        itemCount: listUsers!.length,
                        itemBuilder: (context, index) {
                          return Container(
                              child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                        child:ClipOval(
                                            child:Stack(
                                                children:[
                                                  if(listUsers[index].DP!="")
                                                    Image.memory(base64Decode(listUsers[index].DP),
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.cover,),

                                                ]))
                                    ),
                                    title: Text(listUsers[index].username),
                                    subtitle: Text(listUsers[index].name),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                  userId:
                                                      listUsers[index].userId,
                                                  userIdHead: widget.userId,
                                                  following: widget.following,
                                                  friends: widget.friends,
                                                  friendRequestSent:
                                                      widget.friendRequestSent,
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
                          child: Center(child: CircularProgressIndicator()));
                    }
                  })),
        ],
      ),
    );
  }

  changeSeachKey(String searchKey) {
    widget.searchKey = searchKey;
  }
}
