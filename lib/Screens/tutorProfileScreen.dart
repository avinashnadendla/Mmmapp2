import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mmmapp/Screens/home.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmmapp/bloc/userEvent.dart';

class TutorProfileScreen extends StatefulWidget {
  final auth.User user;
  final User nuser;
  TutorProfileScreen({this.user, this.nuser});
  @override
  _TutorProfileScreenState createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  UserBloc _userBloc;
  List<String> selectedSubjects = [];
  List<String> subjectLists = [];
  User user;

  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _number = "";
  String _wnumber = "";
  List<Map<String, String>> lists = [];

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void didChangeDependencies() {
    _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.userEventSink.add(FetchSubjects());
    super.didChangeDependencies();
  }

  void initState() {
    setState(() {
      // ignore: unnecessary_statements
      selectedSubjects = selectedSubjects;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Profile"),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(30.0),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    /* Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.25),
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: _image == null
                              ? Icon(Icons.add_a_photo)
                              : Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    ),
                                    Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                        ))
                                  ],
                                ),
                        ),
                      ),
                    ),*/
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  name!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _name = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email-Id',
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  Email!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _email = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Mobile Number'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  your number!!';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _number = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Whatsapp Number'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter  your whatsapp number';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _wnumber = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    /*  Container(
                      child: Text(
                        "Subjects :",
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                        child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue)),
                            width: MediaQuery.of(context).size.width,
                            child: GestureDetector(
                                child: subjectLists == null
                                    ? Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Text(
                                          "Choose Subjects",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontSize: 15.0),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: subjectLists.length,
                                        itemBuilder: (context, i) {
                                          return GestureDetector(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.0),
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue[200],
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(50))),
                                              child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  subjectLists[i],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                selectedSubjects.removeAt(i);
                                              });
                                              print("deleted");
                                            },
                                          );
                                        },
                                      ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(// StatefulBuilder
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          title: Text(
                                            'Please select subject from the list!!',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 15.0),
                                          ),
                                          content:
                                              StreamBuilder<List<Subjects>>(
                                                  stream: _userBloc
                                                      .subjectsDataStream,
                                                  initialData:
                                                      _userBloc.allSubjects,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.hasData) {
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Text("Error"),
                                                        );
                                                      } else {
                                                        return ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data.length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              return ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: snapshot
                                                                          .data[
                                                                              i]
                                                                          .subjects
                                                                          .length,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int j) {
                                                                        var snap = snapshot
                                                                            .data[i]
                                                                            .subjects;

                                                                        return CheckboxListTile(
                                                                          onChanged:
                                                                              (bool value) {
                                                                            setState(() {
                                                                              if (value) {
                                                                                selectedSubjects.add(snap[j]);
                                                                              } else {
                                                                                selectedSubjects.remove(snap[j]);
                                                                              }
                                                                            });
                                                                          },
                                                                          value:
                                                                              selectedSubjects.contains(snap[j]),
                                                                          title:
                                                                              new Text(snap[j]),
                                                                        );
                                                                      });
                                                            });
                                                      }
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                          actions: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(
                                                    context, selectedSubjects);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  )..then((val) {
                                      setState(() {
                                        subjectLists = selectedSubjects;
                                      });
                                    });
                                }))),*/
                    SizedBox(height: 40.0),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                        ),
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: FlatButton(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }
                            _formKey.currentState.save();

                            User newUser = User(
                                name: _name,
                                email: _email,

                                //photopath: _image.path,
                                userId: widget.user.uid,
                                number: _number,
                                countryName: "",
                                whatsappNumber: _wnumber,
                                userType: "Tutor");
                            _userBloc.userEventSink.add(AddUser(
                              user: newUser,
                            ));
                            //Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return HomeScreen(
                                  user: widget.nuser,
                                );
                              },
                            ));
                          },
                        )),
                  ],
                ))));
  }
}
