import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'Post.dart';

class ChatScreen extends StatefulWidget{
  String friendName="", friendId="",friendDP="";
  String userName ="", userId="";
  ChatScreen({
    required this.userId,
    required this.userName,
    required this.friendId,
    required this.friendName,
    required this.friendDP,
  });
  @override
  _ChatScreenState createState() =>  _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  TextEditingController _messageController = TextEditingController();

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
          _messageController.text = result.recognizedWords;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildMessageList(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
              radius: 24,
              child : ClipOval(
                  child:Stack(
                      children:[
                        if(widget.friendDP!="")
                          Image.network(widget.friendDP,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,),

                      ]))
          ),
          SizedBox(width: 16),
          Text(
            widget.friendName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  Future<Message> createMessage(String fromId , String toId, String body , String date, String time,int timeStamp) async {
    final http.Response response = await http.post(
      Uri.parse("https://postifybackend.onrender.com/chatInfo/uploadMessage"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'friendName':toId,
        'messageBody':body,
        'from':fromId,
        'messageInfo':{'date': date, 'time':time , 'timeStamp':timeStamp }
      }),
    ) ;
    if(response.statusCode ==200){return Message.fromJson(json.decode(response.body));}
    else throw Exception("Chat Post Failed");
  }

  Future<List<Message>> searchMessage(String fromId , String toId) async {
    List<Message>messageList=[];
    final response = await http.get(Uri.parse("https://postifybackend.onrender.com/chatInfo/search/"+fromId+"/"+toId)) ;
    var responseData = json.decode(response.body);

    for(var eachMessage in responseData) {
      Message message = new Message(
          fromId: fromId,
          toId: toId,
          messageBody: eachMessage['messageBody'],
          date: eachMessage['messageInfo']['date'],
          time: eachMessage['messageInfo']['time'],
          timeStamp: eachMessage['messageInfo']['timeStamp']
      );

      messageList.add(message);
    }

    final response2 = await http.get(Uri.parse("https://postifybackend.onrender.com/chatInfo/search/"+toId+"/"+fromId)) ;
    var responseData2 = json.decode(response2.body);

    for(var eachMessage in responseData2) {
      Message message = new Message(
          fromId: toId,
          toId: fromId,
          messageBody: eachMessage['messageBody'],
          date: eachMessage['messageInfo']['date'],
          time: eachMessage['messageInfo']['time'],
          timeStamp: eachMessage['messageInfo']['timeStamp']
      );
      messageList.add(message);
    }

    return messageList;
  }

  // Replace with your actual message stream

  Widget _buildMessageList() {
    return FutureBuilder(future: searchMessage(widget.userId, widget.friendId),builder:(context, snapshotFuture){
      if(snapshotFuture.hasData){
        List<Message>? message =snapshotFuture.data;
        message?.sort((a,b)=>a.timeStamp-b.timeStamp);
        return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: message?.length, // Replace with the actual number of messages
              itemBuilder: (context, index) {
                bool isSender = message![index].fromId==widget.userId; // Determine if the message is sent by the sender or the receiver

                return Container(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message[index].messageBody+"\n"+message[index].time+"\n"+message[index].date,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ));
      }else{
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });

  }

  Future<Message> ? _futureMessage;

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8,),

          ElevatedButton(onPressed: (){_initializeSpeechRecognition();
          Future.delayed(Duration(seconds: 5), () {
            _stopListening();
          });
          }, child: Icon(Icons.mic_none_outlined)),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              String toId = widget.friendId;
              String fromId = widget.userId;
              String body = _messageController.text;
              final now = new DateTime.now();
              String date = DateFormat("dd-MM-yyyy").format(now);
              String time= DateFormat("HH:mm:ss").format(now);
              int timeStamp = DateTime.now().millisecondsSinceEpoch;
              if(body.length>0){
                setState(() {
                  _futureMessage = createMessage(fromId, toId, body, date, time,timeStamp);
                  WidgetsBinding.instance.addPostFrameCallback((_) =>Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget)));
                });}
              // Add logic to send the message
              _messageController.clear();

            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }



}