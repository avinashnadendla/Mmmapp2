import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmmapp/Models/User.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mmmapp/Screens/home.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final auth.User user;
  final User nuser;
  ProfileScreen({this.user, this.nuser});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _userBloc;
  User user;
  String radio = '';

  File _image;

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _name = "";
  String _email = "";
  String _number = "";
  String _wnumber = "";
  String _countryName = "";

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
    super.didChangeDependencies();
  }

  @override
  void initState() {
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
                        decoration: InputDecoration(labelText: 'Email-Id'),
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
                            return 'Please enter  number!!';
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
                            InputDecoration(labelText: 'WhatsApp Number'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your whatsapp number ';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _wnumber = value;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Country Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter your country name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _countryName = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
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
                                whatsappNumber: _wnumber,
                                countryName: _countryName,
                                userType: "Student");
                            _userBloc.userEventSink.add(AddUser(user: newUser));
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
