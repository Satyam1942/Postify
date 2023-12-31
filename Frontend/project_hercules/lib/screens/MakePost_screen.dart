import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_hercules/screens/Post.dart';
import 'package:http/http.dart' as http;
import 'package:project_hercules/screens/post_screen.dart';

import 'home_screen.dart';

class MakePostScreen extends StatefulWidget {
    final String usernamePost;
    final String userId;
    const MakePostScreen({required this.usernamePost, required this.userId,});
  @override
  _MakePostScreenState createState() => _MakePostScreenState();
}

class _MakePostScreenState extends State<MakePostScreen> {

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
  Future<Post> createPost(String title, String description , String username , String dpLink, int noOfLikes, int noOfDislikes ,int noOfComments , List<Comments>comments, String imageUrl) async {
    final http.Response response = await http.post(
      Uri.parse("http://localhost:5000/postInfo/uploadPost"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'author':{ 'username': username, 'DP' : dpLink},
        'description': description,
        'image':imageUrl,
        'likes':noOfLikes,
        'dislikes':noOfDislikes,
        'numberOfComments':noOfComments,
        'comments' : comments
      }),
    ) ;
    if(response.statusCode ==200){return Post.fromJson(json.decode(response.body));}
    else throw Exception("Post UPLOADING Failed");
  }
  Future<Post>? _futurePost;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: (_futurePost==null)?Padding(
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String username = widget.usernamePost;
                String title = _titleController.text;
                String description = _descriptionController.text;
                  int likes =0;
                  int dislikes =0;
                  int noOfComments =0;
                  List<Comments> comments=[];
                  String DPLink ="https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg?20200913095930" ;

                // Do something with the input data
                setState(() {
                  _futurePost =createPost(title,description,username,DPLink,likes,dislikes,noOfComments,comments,imageURL);
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ): FutureBuilder<Post>(
        future: _futurePost ,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>   Navigator.push(context,
    MaterialPageRoute(builder: (context) =>  HomePage(userId: widget.userId,username: widget.usernamePost,))));

    } else if (snapshot.hasError) {
    return Text("${snapshot.error}");
    }

    return const CircularProgressIndicator();
    },
    )
    );
  }
}
