class Post {
  final String title;
  final String description;
  String author = "No Author";
  int noOfLikes;

  int noOfDislikes;
  List<Comments> comments = [];
  String imageUrl;
  final String postId;

  Post({
    required this.title,
    required this.author,
    required this.description,
    required this.noOfLikes,
    required this.noOfDislikes,
    required this.postId,
    required this.comments,
    required this.imageUrl
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    List<Comments> listOfComments =[];
        for(var eachComment in json['comments'])
          {
            Comments comment = new Comments(body: eachComment['body'], author: eachComment['username']);
            listOfComments.add(comment);
          }
    return Post(
        title: json["title"],
        author: json['author']['username'],
        description: json['description'],
        noOfLikes: json['likes'],
        noOfDislikes: json['dislikes'],
        postId: json['_id'],
        comments:listOfComments,
      imageUrl: json['image']
    );
  }
}
class Comments{

  final String body;
  final String author;
  const Comments({
    required this.body,
    required this.author,
  });
  Map<String, dynamic> toJson() {
    return {
      'username': author,
      'body': body,
    };
  }

}

class Login{
  final String userId;
  final String userName;
  Login({
    required this.userId,
    required this.userName,
});

  factory Login.fromJson(Map<String,dynamic> json)
  {
    return Login(
      userId: json['_id'],
      userName: json['username']
    );
  }
}

class User{
  String userId;
  String name;
  int  age;
  String gender;
  String username;
  Contact contact;
  String DP;
  List<String> friends;
  List<String> followers;
  List<String> following;
  List<String> friendRequestSent;
  List<String> friendRequestRecieved;

User({
    required this.userId,
  required this.username,
  required this.name,
  required this.age,
  required this.gender,
  required this.contact,
  required this.DP,
  required this.friends,
  required this.followers,
  required this.following,
  required this.friendRequestSent,
  required this.friendRequestRecieved,
});

factory User.fromJson(Map<String,dynamic> json){
  Contact contact = new Contact(PhNo: json['contact']['PhNo'].toString(), Email: json['contact']['Email']);
List<String> friend=[];
List<String> followers=[];
List<String> following=[];
List<String> friendRequestSent= [];
List<String> friendRequestRecieved=[];
if(json['friends'].length!=0)
for(var eachFriend in json['friend']) friend.add(eachFriend.toString());
if(json['followers'].length!=0)
for(var eachFollower in json['followers']) followers.add(eachFollower.toString());
if(json['following'].length!=0)
for(var eachFollowing in json['following']) following.add(eachFollowing.toString());
if(json['friendRequestSent'].length!=0)
  for(var eachFriendRequestSent in json['freindRequestSent']) friendRequestSent.add(eachFriendRequestSent .toString());
if(json['friendRequestRecieved'].length!=0)
    for(var eachFriendRequestRecieved in json['freindRequestRecieved']) friendRequestRecieved.add(eachFriendRequestRecieved .toString());


  return User(
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    username: json['username'],
    userId:  json['_id'],
    DP: json['DP'],
    friends: friend,
    followers: followers,
    following: following,
    contact: contact,
    friendRequestRecieved: friendRequestRecieved,
    friendRequestSent: friendRequestSent
  );
}
}

class Contact{
  String PhNo;
  String Email;
  Contact({
    required this.PhNo,
    required this.Email,
});
}

class Message{
  String fromId,toId;
  String messageBody;
  String date, time ;
  int timeStamp;
  Message({
    required this.fromId,
    required this.toId,
    required this.messageBody,
    required this.date,
    required this.time,
    required this.timeStamp
});


  factory Message.fromJson(Map<String,dynamic> json)
  {
   Message message = new  Message(
      fromId:json['from'],
      toId:json['friendName'],
      messageBody:json['messageBody'],
      date:json['messageInfo']['date'],
      time: json['messageInfo']['time'],
       timeStamp: json['messageInfo']['timeStamp'],
    );
    return message;
  }
}

