import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_hercules/screens/profile_screen.dart';

import 'Post.dart';
import 'package:http/http.dart' as http;

import 'chat_room.dart';

class NotificationScreen extends StatelessWidget {
  final String userId, username;
  NotificationScreen({required this.userId, required this.username});

  Future<HashMap<Message, User>> searchMessage() async {
    HashMap<Message, User> messageMap = new HashMap();
    final response = await http
        .get(Uri.parse("https://postifybackend.onrender.com/chatInfo/search/" + userId));
    var responseData = json.decode(response.body);

    for (var eachMessage in responseData) {
      Message message = new Message(
          fromId: eachMessage['from'],
          toId: userId,
          messageBody: eachMessage['messageBody'],
          date: eachMessage['messageInfo']['date'],
          time: eachMessage['messageInfo']['time'],
          timeStamp: eachMessage['messageInfo']['timeStamp']);

      final response2 = await http.get(Uri.parse(
          "https://postifybackend.onrender.com/personalInfo/getUserById/" +
              message.fromId));
      var responseData2 = json.decode(response2.body);
      Contact contact = new Contact(
          PhNo: responseData2['contact']['PhNo'].toString(),
          Email: responseData2['contact']['Email']);
      List<String> friends = [];
      List<String> followers = [];
      List<String> following = [];

      List<String> friendRequestSent = [];
      List<String> friendRequestRecieved = [];

      for (var eachFriend in responseData2['friends']) {
        friends.add(eachFriend);
      }
      for (var eachFollower in responseData2['followers']) {
        followers.add(eachFollower);
      }
      for (var eachFollowing in responseData2['following']) {
        following.add(eachFollowing);
      }

      if (responseData2['friendRequestSent'].length != 0)
        for (var eachFriendRequestSent in responseData2['friendRequestSent'])
          friendRequestSent.add(eachFriendRequestSent.toString());
      if (responseData2['friendRequestRecieved'].length != 0)
        for (var eachFriendRequestRecieved
            in responseData2['friendRequestRecieved'])
          friendRequestRecieved.add(eachFriendRequestRecieved.toString());

      User user = new User(
          userId: responseData2['_id'],
          username: responseData2['username'],
          name: responseData2['name'],
          age: responseData2['age'],
          gender: responseData2['gender'],
          contact: contact,
          DP: responseData2['DP'],
          friends: friends,
          followers: followers,
          following: following,
          friendRequestSent: friendRequestSent,
          friendRequestRecieved: friendRequestRecieved);
      messageMap[message] = user;
    }
    print(messageMap.toString());
    return messageMap;
  }

  Future<User> getUser() async {
    final String url =
        "https://postifybackend.onrender.com/personalInfo/getUserById/" + userId;
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
        friendRequestRecieved: friendRequestRecieved,
        friendRequestSent: friendRequestSent);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children:[
              Container(
                height: 460,
          
            child: FutureBuilder(
                future: searchMessage(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    HashMap<Message, User>? messageMap = snapshot.data;
                    final messageList = messageMap!.entries.toList();
                    return ListView.builder(
                      itemCount: (messageMap!.length>0)?messageMap.length:0, // Replace with your actual number of notifications
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Card(
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: -30, right: 20, top: 20, bottom: 20),
                                leading: Container(
                                  width: 5.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                title: Text(
                                    'You have new message from ${messageList[index].value.username}:\n\n "${messageList[index].key.messageBody}" \n'),
                                subtitle: Text('${messageList[index].key.time}'),
                                trailing: Text('${messageList[index].key.date}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              userId: userId,
                                              userName: username,
                                              friendName: messageList[index]
                                                  .value
                                                  .username,
                                              friendId:
                                                  messageList[index].value.userId,
                                              friendDP:
                                                  messageList[index].value.DP,
                                            )),
                                  );
                                },
                              )),
                        ]);
                      },
                    );
                  } else {
                    print("1");
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                })
              ),
            SizedBox(height: 20,),
            Container(
                height: 200,
             child: FutureBuilder(
                future: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot!.data;
                    return ListView.builder(
                      itemCount: user?.friendRequestRecieved
                          .length, // Replace with your actual number of notifications
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Card(
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: -30, right: 20, top: 20, bottom: 20),
                                leading: Container(
                                  width: 5.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                title: Text(
                                    'You have recieved Friend Request from ${user?.friendRequestRecieved[index]}'),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                            userIdFriend: user!
                                                .friendRequestRecieved[index],
                                            userIdHead: userId,
                                            following: user.following,
                                            friendRequestSent:
                                                user.friendRequestSent,
                                            friends: user.friends,
                                            friendRequestRecieved:
                                                user.friendRequestRecieved)),
                                  );
                                },
                              )),
                        ]);
                      },
                    );
                  } else {
                    print("2");
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }),)
          ]),
        )
        );
  }
}
