import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/MakePost_screen.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:project_hercules/screens/edit_Post_Screen.dart';
import 'package:project_hercules/screens/post_screen.dart';
import 'package:project_hercules/utils/app_styles.dart';

class MyPostScreen extends StatefulWidget {
  final String userId;
  final String username;

  const MyPostScreen({required this.userId, required this.username});
  @override
  _MyPostScreenState createState() {
    return _MyPostScreenState();
  }
}

class _MyPostScreenState extends State<MyPostScreen> {
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

  Future<List<Post>> getRequest() async {
    final String url =
        "https://postifybackend.onrender.com/postInfo/getPostByUserName/" +
            widget.username;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    List<Post> posts = [];
    for (var eachPost in responseData) {
      List<Comments> commentsList = [];
      for (var eachComment in eachPost["comments"]) {
        Comments comments = new Comments(
            body: eachComment["body"], author: eachComment["username"]);
        commentsList.add(comments);
      }
      Post post = new Post(
          title: eachPost["title"],
          author: eachPost["author"]["username"],
          description: eachPost["description"],
          noOfLikes: eachPost["likes"],
          noOfDislikes: eachPost["dislikes"],
          postId: eachPost["_id"],
          comments: commentsList,
          imageUrl: eachPost['image']);
      posts.add(post);
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MakePostScreen(
                          userId: widget.userId,
                          usernamePost: widget.username,
                        )));
          },
          child: Icon(CupertinoIcons.plus),
        ),
        appBar: AppBar(
          title: Text("My Posts"),
        ),
        body: SingleChildScrollView(
            child: Container(
                color: Color.fromARGB(83, 162, 207, 245),
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FutureBuilder(
                      future: getRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data![index];
                              return FutureBuilder(
                                  future: getUser(),
                                  builder: (context, Usersnapshot) {
                                    var user = Usersnapshot.data;
                                    if (user != null) {
                                      return GestureDetector(
                                          onTap: () {
                                            // Handle post click
                                            List<String> following =
                                                user.following;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PostScreen(
                                                          postId: post.postId,
                                                          username:
                                                              widget.username,
                                                          userId: widget.userId,
                                                          following: following,
                                                          friends: user.friends,
                                                          friendRequestSent: user
                                                              .friendRequestSent,
                                                          friendRequestRecieved:
                                                              user.friendRequestRecieved,
                                                        )));
                                          },
                                          child: Card(
                                            color: Colors.white,
                                            child: ListTile(
                                                tileColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(80),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: -30,
                                                        right: 20,
                                                        top: 20,
                                                        bottom: 20),
                                                leading: Container(
                                                  width: 5.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                ),
                                                title: Text(post.title,
                                                    style:
                                                        Styles.headingStyle2),
                                                subtitle: Text(
                                                    post.author +
                                                        "\n\n" +
                                                        post.description,
                                                    style:
                                                        Styles.headingStyle3),
                                                trailing: ElevatedButton(
                                                    onPressed: () => {
                                                          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext context) => EditPostScreen(
                                                                      usernamePost:
                                                                          widget
                                                                              .username,
                                                                      userId: widget
                                                                          .userId,
                                                                      postId: post
                                                                          .postId)))),
                                                        },
                                                    child: Icon(Icons.edit))),
                                          ));
                                    } else {
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                  });
                            },
                          );
                        }
                      })
                ]))));
  }
}
