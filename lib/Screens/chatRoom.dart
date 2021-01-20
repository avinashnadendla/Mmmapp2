import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmmapp/Models/chat.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:mmmapp/bloc/ChatBloc/chatEvent.dart';
import 'package:mmmapp/bloc/ChatBloc/chatbloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatRoom extends StatefulWidget {
  final String user;
  final User receiver;
  ChatRoom({this.receiver, this.user});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}
String generateRandomString(int len) {
  var r = Random();
  return String.fromCharCodes(
      List.generate(len, (index) => r.nextInt(33) + 89));
}
class _ChatRoomState extends State<ChatRoom> {

  ChatBloc _chatBloc;
  TextEditingController messageEditingController = new TextEditingController();
  String downloadUrl;
  var imageUrl = "";
  var fileUrl = "";
  Future<dynamic> uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;

    image = await _imagePicker.getImage(source: ImageSource.gallery);

    var file = File(image.path);
    if (image != null) {
      await _firebaseStorage
          .ref()
          .child(generateRandomString(10))
          .putFile(file)
          .onComplete
          .then((value) {
        value.ref
            .getDownloadURL()
            .whenComplete(() => print('hello'))
            .then((value) {
          downloadUrl = value;
          setState(() {
            imageUrl = downloadUrl;
          });

          // int date = DateTime.now().millisecondsSinceEpoch;
          int date = DateTime.now().millisecondsSinceEpoch;
          Chat chat = Chat(
            message: imageUrl,
            date: date,
            sendBy: auth.FirebaseAuth.instance.currentUser.uid,
            messageType: 'image',
          );
          _chatBloc.chatEventSink.add(AddChat(
              chat: chat,
              userId: auth.FirebaseAuth.instance.currentUser.uid,
              receiverId: widget.receiver.userId));

          _chatBloc.chatEventSink.add(AddChat(
              chat: chat,
              userId: widget.receiver.userId,
              receiverId: auth.FirebaseAuth.instance.currentUser.uid));
          messageEditingController.text = "";
        });
      });
    } else {
      print('No Image Path Received');
    }
  }

  uploadFile() async {
    final _firebaseStorage = FirebaseStorage.instance;
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      await _firebaseStorage
          .ref()
          .child(generateRandomString(10))
          .putFile(file)
          .onComplete
          .then((value) {
        value.ref
            .getDownloadURL()
            .whenComplete(() => print("hi"))
            .then((value) {
          downloadUrl = value;
          setState(() {
            fileUrl=downloadUrl;
          });
          print('avi');
          int date = DateTime.now().millisecondsSinceEpoch;
          Chat chat = Chat(
            message: fileUrl,
            date: date,
            sendBy: auth.FirebaseAuth.instance.currentUser.uid,
            messageType: 'file',
          );
          _chatBloc.chatEventSink.add(AddChat(
              chat: chat,
              userId: auth.FirebaseAuth.instance.currentUser.uid,
              receiverId: widget.receiver.userId));

          _chatBloc.chatEventSink.add(AddChat(
              chat: chat,
              userId: widget.receiver.userId,
              receiverId: auth.FirebaseAuth.instance.currentUser.uid));
          messageEditingController.text = "";
        });
      });
    } else {
      print("nothing");
    }
  }

  void didChangeDependencies() {
    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _chatBloc.chatEventSink.add(FetchChats(
        senderId: auth.FirebaseAuth.instance.currentUser.uid,
        receiverId: widget.receiver.userId));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.name),
        ),
        body: Container(
          child: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Chat>>(
                    stream: _chatBloc.chatDataStream,
                    initialData: _chatBloc.allChats,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error"),
                          );
                        } else {
                          return Scrollbar(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    // var date = DateTime.fromMillisecondsSinceEpoch(
                                    //     snapshot.data[i].date);
                                    // var formattedDate =
                                    //     DateFormat('hh:mm a  EEE d MMM').format(date);
                                    DateTime now = DateTime.now();
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd – kk:mm')
                                            .format(now);

                                    if (snapshot.data[i].sendBy ==
                                        auth.FirebaseAuth.instance.currentUser
                                            .uid) {
                                      return MessageTile(

                                        message:
                                            snapshot.data[i].message == null
                                                ? ""
                                                : snapshot.data[i].message,
                                        sendByMe: true,
                                        time: formattedDate,
                                        messageType:
                                            snapshot.data[i].messageType,
                                      );
                                    } else {
                                      return MessageTile(

                                          message: snapshot.data[i].message,
                                          sendByMe: false,
                                          messageType:
                                              snapshot.data[i].messageType,
                                          time: formattedDate);
                                    }
                                  }));
                        }
                      }

                      return Container(
                        child: Text(""),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    color: Color(0x54FFFFFF),
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.attach_file),
                            color: Colors.black,
                            onPressed:()=> uploadFile()),
                        IconButton(
                            icon: Icon(Icons.image),
                            color: Colors.black,
                            onPressed: () {
                              uploadImage();
                            }),
                        Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: TextField(
                                maxLines: null,
                          controller: messageEditingController,
                          //style: simpleTextStyle(),
                          decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                        ),
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            int date = DateTime.now().millisecondsSinceEpoch;
                            Chat chat = Chat(
                                messageType: "message",
                                message: messageEditingController.text,
                                date: date,
                                sendBy:
                                    auth.FirebaseAuth.instance.currentUser.uid);

                            _chatBloc.chatEventSink.add(AddChat(
                                chat: chat,
                                userId:
                                    auth.FirebaseAuth.instance.currentUser.uid,
                                receiverId: widget.receiver.userId));

                            _chatBloc.chatEventSink.add(AddChat(
                                chat: chat,
                                userId: widget.receiver.userId,
                                receiverId: auth
                                    .FirebaseAuth.instance.currentUser.uid));

                            messageEditingController.clear();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0x36FFFFFF),
                                        const Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.send)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]),
        ));
  }
}

// ignore: must_be_immutable
class MessageTile extends StatelessWidget {
  final String messageType;
  final String message;
  final bool sendByMe;
  var time;

  MessageTile(
      {@required this.message,
      @required this.sendByMe,
      this.time,
      this.messageType});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: sendByMe ? 0 : 24,
            right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: messageType == 'message'
            ? Container(
                margin: sendByMe
                    ? EdgeInsets.only(left: 30)
                    : EdgeInsets.only(right: 30),
                padding:
                    EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                    borderRadius: sendByMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                            bottomLeft: Radius.circular(23))
                        : BorderRadius.only(
                            topLeft: Radius.circular(23),
                            topRight: Radius.circular(23),
                            bottomRight: Radius.circular(23)),
                    gradient: LinearGradient(
                      colors: sendByMe
                          ? [const Color(0xff007EF4), const Color(0xff007EF4)]
                          : [const Color(0xffff4081), const Color(0xffff4081)],
                    )),
                child: Expanded(
                  child: Text(message,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
              )

            : messageType=='image'?Container(
                width: 250.0,
                height: 250.0,
                padding: EdgeInsets.only(
                    left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
                alignment:
                    sendByMe ? Alignment.centerRight : Alignment.centerLeft,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(message), fit: BoxFit.fill)),
              ) :
            RaisedButton(
              padding: EdgeInsets.only(
                  left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
              child:
                  Image(
                    image: AssetImage('images/avi.png'),
                    width: 25.0,
                    height: 25.0,
                  ),
              onPressed: ()
              async {
                print('avi');
                Dio dio=Dio();
                var dir=await getApplicationDocumentsDirectory();
                var s=generateRandomString(10);
                await dio.download(message,"${dir.path}/s",);
                print(message);
                await OpenFile.open('${dir.path}/s');
              },

            )
    );
  }
}
