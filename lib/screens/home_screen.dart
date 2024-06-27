import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/MakePost_screen.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:project_hercules/screens/friend_screen.dart';
import 'package:project_hercules/screens/login_screen.dart';
import 'package:project_hercules/screens/my_post_screen.dart';
import 'package:project_hercules/screens/post_screen.dart';
import 'package:project_hercules/screens/searchScreen.dart';
import 'package:project_hercules/screens/user_profile_screen.dart';
import 'package:project_hercules/utils/app_styles.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String username;
  const HomePage({required this.userId, required this.username});
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  late Future<User> futureUser;
  late Future<List<Post>> futurePost;

  @override
  void initState() {
    super.initState();
      futureUser = getUser();
      futurePost = getAllPosts();
  }

  void _initializeSpeechRecognition() async {
    bool available = await _speechToText.initialize();
    if (available) {
      print("YES");
      _startListening();
    } else {
      print('Speech recognition not available');
    }
  }

  void _startListening() {
    if (!_isListening) {
      _speechToText.listen(
        onResult: (result) => setState(() {
          _searchController.text = result.recognizedWords;
        }),
      );
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  Future<User> getUser() async {
    final String url =
        "https://postifybackend.onrender.com/personalInfo/getUserById/" + widget.userId;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);


    Contact contact = new Contact(
        PhNo: responseData['contact']['PhNo'].toString(),
        Email: responseData['contact']['Email']
    );

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
        friendRequestRecieved: friendRequestRecieved,
        friendRequestSent: friendRequestSent
    );
    return user;
  }

  Future<List<Post>> getAllPosts() async {
    final String url = "https://postifybackend.onrender.com/postInfo/getAllPosts";
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
    var screenSizeHorizontal = MediaQuery.of(context).size.width;
    var screenSizeVertical = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            TextButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) =>
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  super.widget)));
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    minimumSize: Size(screenSizeHorizontal/100, screenSizeVertical/10)),
                child: Text('Home')),
            SizedBox(
              width: 10,
            ),
          ],
        )),
        body: ListView(
          children: [
            Container(
              color: Color.fromARGB(83, 162, 207, 245),
              padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 5.w, vertical:  10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                    children: [
                      FutureBuilder(
                          future: futureUser,
                          builder: ((context, snapshot) {
                            var user = snapshot.data;
                            if(snapshot.connectionState == ConnectionState.waiting)
                              return Center(
                                  child: CircularProgressIndicator()
                              );
                            else if(snapshot.hasError)
                              return Text("Error: ${snapshot.error}");
                            else  if (user != null) {
                              return Container(
                                  child: Card(
                                      surfaceTintColor: Colors.white,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(children: [
                                        SizedBox(
                                          width: screenSizeHorizontal/100,
                                        ),
                                        FloatingActionButton(
                                            onPressed: () {
                                              setState(() {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) =>
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return MakePostScreen(
                                                            usernamePost:
                                                                user.username,
                                                            userId: user.userId,
                                                          );
                                                        })));
                                              });
                                            },
                                            child: Icon(CupertinoIcons.plus)),
                                        SizedBox(width: screenSizeHorizontal/100),
                                        CircleAvatar(
                                          radius: 50,
                                          child:ClipOval(
                                              child:Stack(
                                            children:[
                                              if(user.DP!="")
                                            Image.network(user.DP,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,),

                                        ]))
                                        ),
                                        SizedBox(
                                          width: screenSizeHorizontal/50,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: screenSizeVertical/100),
                                            Text(
                                              user.username,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: screenSizeVertical/200),
                                            Text(
                                              user.contact.Email,
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            SizedBox(height: screenSizeVertical/200),
                                            Text(
                                              user.name,
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                            SizedBox(height: screenSizeVertical/200),
                                            Text(
                                              'Followers: ' +
                                                  user.followers.length
                                                      .toString(),
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: screenSizeHorizontal/10,
                                        ),

                                        Column(children: [
                                          SizedBox(height: screenSizeVertical/100),
                                          Text(
                                            'Following: ' +
                                                user.following.length
                                                    .toString(),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          SizedBox(
                                            height: screenSizeVertical/200,
                                          ),
                                          Text(
                                            'Friends: ' +
                                                user.friends.length.toString(),
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                        ]),
                                        SizedBox(
                                          width: screenSizeHorizontal/100,
                                        ),
                                      ])));
                            } else {
                              return Center(
                                  child: CircularProgressIndicator()
                              );
                            }
                          })),
                    ],
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText:
                                'Search for People, Author, Buisnesses .....',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.mic_none_outlined),
                        onPressed: () {
                          _initializeSpeechRecognition();
                          Future.delayed(Duration(seconds: 5), () {
                            _stopListening();
                          });
                        },
                      ),
                      FutureBuilder(
                          future: futureUser,
                          builder: (context, snapshot) {
                            var user = snapshot.data;
                            if (user != null) {
                              return IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  return _performSearch(
                                      user.following,
                                      user.friends,
                                      user.friendRequestSent,
                                      user.friendRequestRecieved);
                                },
                              );
                            } else {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FutureBuilder(
                      future: futurePost,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
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
                                  future: futureUser,
                                  builder: (context, Usersnapshot) {
                                    var user = Usersnapshot.data;
                                    if (user != null) {
                                      return GestureDetector(
                                          onTap: () {
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
                                            child: SingleChildScrollView(
                                              // scrollDirection: Axis.horizontal,
                                              child: ListTile(
                                                tileColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: -30,
                                                        right: 20,
                                                        top: 20,
                                                        bottom: 20),
                                                leading: Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                ),
                                                title: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(post.title,
                                                      style: Styles.headingStyle2),
                                                ),
                                                subtitle: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                      post.author +
                                                          "\n\n" +
                                                          post.description,
                                                      style: Styles.headingStyle3),
                                                ),
                                                trailing: Container(
                                                    height: 70,
                                                    width: 70,
                                                    child: Column(children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.thumb_up),
                                                          Text(
                                                            " " +
                                                                post.noOfLikes
                                                                    .toString(),
                                                            style: Styles
                                                                .headingStyle3,
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Icons.thumb_down),
                                                          Text(
                                                            " " +
                                                                post.noOfDislikes
                                                                    .toString(),
                                                            style: Styles
                                                                .headingStyle3,
                                                          )
                                                        ],
                                                      ),
                                                    ])),
                                              ),
                                            ),
                                          ));
                                    } else {
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                  });
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Image.asset("images/logo.png")),
              FutureBuilder(
                  future: getUser(),
                  builder: (context, snapshot) {
                    var user = snapshot.data;
                    if (user != null) {
                      return ListTile(
                        title: Text('Friends'),
                        onTap: () {
                          List<String> following = user.following;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendsPage(
                                        userId: widget.userId,
                                        username: widget.username,
                                        following: following,
                                        friends: user.friends,
                                        friendRequestSent:
                                            user.friendRequestSent,
                                        friendRequestRecieved:
                                            user.friendRequestRecieved,
                                      )));
                        },
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
              ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePage(
                                userId: widget.userId,
                                username: widget.username,
                              )));
                },
              ),
              ListTile(
                title: Text('My Posts'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyPostScreen(
                                userId: widget.userId,
                                username: widget.username,
                              )));
                },
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ],
          ),
        ));
  }

  void _performSearch(List<String> following, List<String> friends,
      List<String> friendRequestSent, List<String> friendRequestRecieved) {
    String searchKey = _searchController.text;
    if (searchKey != "")
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchScreen(
                    searchKey: searchKey,
                    userId: widget.userId,
                    following: following,
                    friends: friends,
                    friendRequestSent: friendRequestSent,
                    friendRequestRecieved: friendRequestRecieved,
                  )));
  }
}
