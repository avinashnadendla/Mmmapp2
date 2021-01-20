import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ProfilePage extends StatefulWidget {
  ProfilePage({this.user});
  final User user;
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserBloc userBloc;
  File _file;

  final picker = ImagePicker();

  void didChangeDependencies() {
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.userEventSink
        .add(FetchUser(userID: auth.FirebaseAuth.instance.currentUser.uid));
    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      }
    });
  }

  final double circleRadius = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("My Profile"),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editModalBottomSheet();
              },
            )
          ],
        ),
        body: StreamBuilder<User>(
            stream: userBloc.currentUserDataStream,
            //  initialData: userBloc.allUsers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.cyan[200],
                    child: Stack(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: circleRadius / 2.0,
                              ),

                              ///here we create space for the circle avatar to get ut of the box
                              child: Container(
                                height: 300.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8.0,
                                      offset: Offset(0.0, 5.0),
                                    ),
                                  ],
                                ),
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, bottom: 15.0),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: circleRadius / 2,
                                        ),
                                        Text(
                                          snapshot.data.name == null
                                              ? ""
                                              : "${snapshot.data.name[0].toUpperCase()}${snapshot.data.name.substring(1)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30.0,
                                              color: Colors.blueGrey),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Email',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    snapshot.data.email == null
                                                        ? ""
                                                        : snapshot.data.email,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15.0),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'WhatsappNumber',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    snapshot.data.whatsappNumber == null
                                                        ? ""
                                                        : snapshot.data.whatsappNumber,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 15.0),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    'Mobile Number',
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    snapshot.data.number == null
                                                        ? ""
                                                        : snapshot.data.number,
                                                    style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),

                            ///Image Avatar
                        /*    Container(
                              width: circleRadius,
                              height: circleRadius,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 8.0,
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Center(
                                    child: Container(
                                  child: ClipOval(
                                    child: Image.network(
                                      snapshot.data.photoPath == null
                                          ? ""
                                          : snapshot.data.photoPath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ]),
                  );
                }
              } else {
                return Container();
              }
            }));
  }

  void editModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Form(
              key: _formKey,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: ListView(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Spacer(),
                              Text('Edit Profile ',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.orange)),
                              Spacer(),
                              IconButton(
                                  icon: Icon(Icons.cancel,
                                      color: Colors.orange, size: 25.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ]),
                            GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Container(
                                  child: _file != null
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Image.file(
                                              _file,
                                              width: 100,
                                              height: 30,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ))
                                      : Column(children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.add_photo_alternate,
                                              size: 40.0,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          Text("[ Image  ]",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey[600]))
                                        ])),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              height: 5 * 10.0,
                              padding: EdgeInsets.only(left: 20.0, right: 20.0),
                              child: TextFormField(
                                controller: _nameController,
                                validator: (value) =>
                                    _nameController.text.isEmpty
                                        ? "Name is required"
                                        : null,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  labelText: 'Name ',
                                  contentPadding: EdgeInsets.all(20.0),
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            FlatButton(
                                onPressed: () async {
                                  final form = _formKey.currentState;
                                  if (_file != null) {
                                    if (form.validate()) {
                                      userBloc.userEventSink.add(EditUser(
                                        userId: auth.FirebaseAuth.instance
                                            .currentUser.uid,
                                        name: _nameController.text,
                                      ));
                                      _nameController.clear();

                                      Navigator.of(context).pop();
                                    } else {
                                      print("Hello");
                                    }
                                  } else {
                                    return alert(context);
                                  }
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ))
                          ]))));
        });
  }

  Future<void> alert(BuildContext context) {
    return showDialog(
        context: _scaffoldKey.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Please pick a image first !!",
              textAlign: TextAlign.center,
            ),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
