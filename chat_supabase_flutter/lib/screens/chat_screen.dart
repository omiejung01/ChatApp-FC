import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;
import 'dart:convert';
import 'dart:async';

final _supabase = Supabase.instance.client;

Session? _session;
User? _user;

String _currentUserEmail = '';
String _messageText = '';
late Stream<dynamic> _dataStream;
int count1 = 0;
int count2 = 0;

//List<String> senders = [];
//List<String> texts = [];
//List<String> sendTimes = [];

MessagesStream _messagesStream= new MessagesStream();

final _messageTextController = TextEditingController();
final _scrollController = ScrollController();

//List<MessageBubble> messageBubbles = [];

String _signature = '';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

Future<String> getSignature() async {
  http.Response response = await http.get(Uri.parse(my.signature_url));

  String signature = 'Not defined';
  String body = '';
  if (response.statusCode == 200) {
    body = response.body;
    //print("body: ${jsonDecode(body)}");
    signature = (jsonDecode(body))['Hash'];
    //print("signature: ${signature}");
  }
  return signature;
}
class _ChatScreenState extends State<ChatScreen> {
  Timer? timer;

  void refresh() async {
    if (_signature.isEmpty) {
      _signature = await getSignature();
    } else {
      String new_signature = await getSignature();
      if (_signature == new_signature) {
        // Do nothing
      } else {
        _signature = new_signature;
        setState(() {
          _dataStream = _fetchStreamData2(my.message_url);
          _messagesStream= MessagesStream();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _dataStream = _fetchStreamData2(my.message_url);
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => refresh());
    //_dataStream.listen( (p) {
    //  print("Data added");
    //});

  }

  void getCurrentUser() {
    try {
      _session = _supabase.auth.currentSession;
      _user = _supabase.auth.currentUser;
      String? this_email = _user!.email;
      if (this_email == null) {
        throw Exception('Null user');
      } else {
        _currentUserEmail = this_email;
        //print("User email: $email");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _supabase.auth.signOut();
              Navigator.pop(context);
              },
          ),
        ],
        title: Text('Mes8 Chat'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _messagesStream,
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageTextController,
                      onChanged: (value) {
                        _messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (await sendMessage(_messageText.trim(), _currentUserEmail, 1)) {
                        setState(() {
                          _dataStream = _fetchStreamData2(my.message_url);
                          _messagesStream= MessagesStream();
                        });
                        _scrollController.animateTo(
                          0.0,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 1000),
                        );
                        //print(_dataStream.toString());
                        _messageText = '';
                        //print("Success");
                        _messageTextController.clear();
                        //setState(() {
                        //  _dataStream = _fetchStreamData(url);
                        //});

                      }
                    },
                    child: Text('Send', style: kSendButtonTextStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> sendMessage(
  String messageText,
  String senderEmail,
  int groupID,
) async {
  bool result = true;

  String url =
      "https://tetrasolution.com/chatapp/api/send_message.php?"
      "group_id=$groupID&sender_email=$senderEmail&message_text=$messageText";

  final response = await http.get(
    Uri.parse(url),
    // Send authorization headers to the backend.
    headers: my.header,
  );

  final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
  String success = responseJson['result'];
  //print("result: $success");
  if (success.compareTo('Success') == 0) {
    result = true;
  } else {
    result = false;
  }
  return result;
}


//List<String> myData = [];
Stream<dynamic> _fetchStreamData2(String url) async* {

  final request = http.Request('GET', Uri.parse(url));
  final streamedResponse = await request.send();
  List<dynamic> myData = [];
  if (streamedResponse.statusCode == 200) {
    //List<String> myData = [];
    await for (final chunk in streamedResponse.stream) {
      final decodedChunk = utf8.decode(chunk);
      //print("decodeChunk $decodedChunk");
      final lines = decodedChunk
          .split('\n')
          .where((line) => line.trim().isNotEmpty);
      for (final line in lines) {
        try {
          //print("line ${jsonDecode(line)}");
          myData.add(jsonDecode(line));

          //yield jsonDecode(line);
        } catch (e) {
          print('Error decoding JSON: $e, line: $line');
          //yield e.toString(); // Or handle the error as needed
        }
      }
    }
    yield myData;
  } else {
    yield* Stream<dynamic>.error('Error fetching data');
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dataStream, //_dataStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
        //print(snapshot.data[0]);
        //final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        //messageBubbles.clear();

        final currentUser = _currentUserEmail;
        //print("snapshot ${snapshot.data['message_text']} ${count2}");
        //count2 ++;
        for (var message in snapshot.data) {
        //print("data ${snapshot.data}");
        final messageBubble = MessageBubble(
          sender: message['sender_email'],
          text: message['message_text'],
          createdTime: message['created_time'],
          isMe: message['sender_email'] == currentUser,
        );

        messageBubbles.add(messageBubble);
      }

        return Expanded(
          child: ListView(
            controller: _scrollController,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    this.sender = '',
    this.text = '',
    this.isMe = false,
    this.createdTime = '',
  });

  final String sender;
  final String text;
  final bool isMe;
  final String createdTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: TextStyle(fontSize: 12.0, color: Colors.black54)),
          Material(
            borderRadius:
                isMe
                    ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    )
                    : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
            elevation: 5.0,
            color: isMe ? Colors.orange : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
