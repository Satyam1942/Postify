import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:http/http.dart' as http;
import 'package:project_hercules/screens/my_post_screen.dart';
import 'package:project_hercules/screens/post_screen.dart';

import 'home_screen.dart';

class EditPostScreen extends StatefulWidget {
  final String usernamePost;
  final String userId;
  final String postId;
  const EditPostScreen({required this.usernamePost, required this.userId,required this.postId});
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String imageURL="";

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
    }
  }

  Future<Post> getRequest() async {
    final String url =
        "https://postifybackend.onrender.com/postInfo/getPostById/" + widget.postId;
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    List<Comments> commentsList = [];
    for (var eachComment in responseData["comments"]) {
      Comments comments = new Comments(
          body: eachComment["body"], author: eachComment["username"]);
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

  Future<Post> deletePost() async
  {
    final http.Response response = await http.delete(
        Uri.parse("https://postifybackend.onrender.com/postInfo/deletePostById/"+widget.postId),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{}),
    );
    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Login failed. Status Code: ${response.statusCode}');
    }
    }
  Future<Post> updatePost(String title, String description , String imageUrl) async {
    final http.Response response = await http.patch(
      Uri.parse("https://postifybackend.onrender.com/postInfo/updatePostById/"+widget.postId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'description': description,
        'image':imageUrl,
      }),
    ) ;
    print(response.statusCode);
    if(response.statusCode ==200){return Post.fromJson(json.decode(response.body));}
    else throw Exception("Post UPDATING Failed");
  }
  Future<Post>? _futurePost,_deletePost;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Update Post'),
        ),
        body: FutureBuilder(future: getRequest(),builder:(context,snapshot)
        {
          if(snapshot.hasData)
           {
             var post = snapshot!.data;
             _titleController.text = post!.title;
             _descriptionController.text = post.description;
           return Padding(
            padding: EdgeInsets.all(100.0),
            child: Column(

              children: [

                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Post Title',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _descriptionController,
                  minLines: 1,
                  maxLines: 50,
                  decoration: InputDecoration(
                    labelText: 'Post Description',

                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed:  _uploadImage,
                  child: Text('Upload Image'),
                ),
                SizedBox(height:20),
                ElevatedButton(onPressed: ()=>{
                  setState(()=>{
                    _deletePost = deletePost(),
                WidgetsBinding.instance.addPostFrameCallback((_) =>   Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) =>  MyPostScreen(userId: widget.userId,username: widget.usernamePost,)))
                )})
                }, child: Text("Delete Post")),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {


                    String title = _titleController.text;
                    String description = _descriptionController.text;
                    if(imageURL=="") imageURL=post.imageUrl;
                    print(title+" "+description);
                    // Do something with the input data
                    setState(() {
                      _futurePost = updatePost(title,description,imageURL);
                      WidgetsBinding.instance.addPostFrameCallback((_) =>   Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) =>  MyPostScreen(userId: widget.userId, username: widget.usernamePost)))
                      );
                    });
                  },
                  child: Text('Update Post'),
                ),
              ],
            ),
          );
           } else{
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          }
        })

    );
  }
}
