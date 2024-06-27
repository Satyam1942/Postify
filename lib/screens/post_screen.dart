import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:project_hercules/screens/searchScreen.dart';


class PostScreen extends StatefulWidget {
  final String postId;
  final String username, userId;
  final List<String> following;
  final List<String> friendRequestSent;
  final List<String> friendRequestRecieved;
  final List<String> friends;
  const PostScreen(
      {required this.postId,
      required this.username,
      required this.userId,
      required this.following,
      required this.friendRequestSent,
      required this.friends,
      required this.friendRequestRecieved});
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _commentController = TextEditingController();
  Future<Post>? _futureComment;

  Future<Post> getRequest() async {
    final String url = "https://postifybackend.onrender.com/postInfo/getPostById/" + widget.postId;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    List<Comments> commentsList = [];

    for (var eachComment in responseData["comments"]) {
      Comments comments = new Comments(
          body: eachComment["body"],
          author: eachComment["username"]
      );
      commentsList.add(comments);
    }

    Post post = new Post(
      title: responseData["title"],
      author: responseData["author"]["username"],
      description: responseData["description"],
      noOfLikes: responseData["likes"],
      noOfDislikes: responseData["dislikes"],
      postId: responseData["_id"],
      comments: commentsList,
      imageUrl: responseData['image'],
    );
    return post;
  }

  Future<Post> updateComment(String username, String commentBody, String postId, List<Comments> commentList) async {

    Comments comments = new Comments(body: commentBody, author: username);
    commentList.add(comments);

    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/postInfo/updatePostById/" + postId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{'comments': commentList}),
    );

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts/" + widget.postId),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: getRequest(),
                builder: (context, snapshot) {
                  var post = snapshot.data;

                  if (post == null) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen(
                                            searchKey: post.author,
                                            userId: widget.userId,
                                            following: widget.following,
                                            friends: widget.friends,
                                            friendRequestSent: widget.friendRequestSent,
                                            friendRequestRecieved: widget.friendRequestRecieved,
                                          )));
                            },
                            child: Text("Post By: " + post.author,
                                style: TextStyle(
                                  fontSize: 21.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            post.title,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            post.description,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(height: 20.0),
                          (post.imageUrl == "")
                              ? SizedBox(height: 20)
                              : Image.network(post.imageUrl),
                          SizedBox(height: 20.0),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    updateNoOfLikes(
                                        post.noOfLikes + 1, post.postId);
                                  });
                                },
                                icon: Icon(Icons.thumb_up),
                              ),
                              Text('${post.noOfLikes}'),
                              SizedBox(width: 5.0),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      updateNoOfDislikes(
                                          post.noOfDislikes + 1, post.postId);
                                    });
                                  },
                                  icon: Icon(Icons.thumb_down)),
                              SizedBox(width: 5.0),
                              Text('${post.noOfDislikes}'),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            'Comments',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Enter your comment...',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              String comment = _commentController.text;
                              List<Comments> commentsList = post.comments;

                              setState(() {
                                _futureComment = updateComment(widget.username,
                                    comment, post.postId, commentsList);
                                WidgetsBinding.instance.addPostFrameCallback(
                                    (_) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                super.widget)));
                              });
                              _commentController
                                  .clear();
                            },
                            child: Text('Submit'),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: post.comments.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(post.comments[index].body),
                                leading: TextButton(
                                    child: Text("@" +
                                        post.comments[index].author +
                                        ":"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchScreen(
                                                    searchKey: post
                                                        .comments[index].author,
                                                    userId: widget.userId,
                                                    following: widget.following,
                                                    friends: widget.friends,
                                                    friendRequestSent: widget
                                                        .friendRequestSent,
                                                    friendRequestRecieved: widget
                                                        .friendRequestRecieved,
                                                  )));
                                    }),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<Post> updateNoOfLikes(int noOfLikes, String postId) async {
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/postInfo/updatePostById/" + postId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'likes': noOfLikes}),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }

  Future<Post> updateNoOfDislikes(int noOfDislikes, String postId) async {
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/postInfo/updatePostById/" + postId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'dislikes': noOfDislikes}),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Connection failed. Status Code: ${response.statusCode}');
    }
  }
}
