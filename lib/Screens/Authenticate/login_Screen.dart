import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:mmmapp/Screens/Authenticate/login_form.dart';
import 'package:mmmapp/Screens/RouteScreen.dart';
import 'package:mmmapp/bloc/AuthenticationBloc/loginbloc.dart';
import 'package:mmmapp/bloc/userRepository.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:mmmapp/bloc/userBloc.dart';
import 'package:mmmapp/bloc/userEvent.dart';
import 'package:mmmapp/Models/User.dart';
import 'dart:io';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: bloc.BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: widget._userRepository),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfff2cbd0), Color(0xfff4ced9)],
          )),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 100, left: 50),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      color: Color(0xff6a515e),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: LoginForm(
                    userRepository: widget._userRepository,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneScreen extends StatefulWidget {
  @override
  _PhoneScreenState createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  var _code = ['+91', '+971'];
  var _currentCodeSelected;
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text('Phone Authentication'),
        ),
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(shrinkWrap: true, children: [
              Row(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Expanded(
                    child: Container(
                        child: DropdownButtonFormField<String>(
                      iconSize: 0.0,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      hint: Text('code'),
                      items: _code.map((value) {
                        return DropdownMenuItem<String>(
                            child: Text(value), value: value);
                      }).toList(),
                      value: _currentCodeSelected,
                      onChanged: (newValue) {
                        setState(() {
                          _currentCodeSelected = newValue;
                        });
                      },
                    )),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                        ),
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        controller: _controller,
                      ),
                    ))
              ]),
              SizedBox(height: 40.0),
              Container(
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                height: 40.0,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  shadowColor: Colors.greenAccent,
                  color: Colors.pink,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OTPScreen(
                              code: _currentCodeSelected,
                              phone: _controller.text)));
                    },
                    child: Center(
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ])));
  }
}

class OTPScreen extends StatefulWidget {
  final String code;
  final String phone;
  OTPScreen({this.phone, this.code});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  UserBloc userBloc;
  @override
  void didChangeDependencies() {
    userBloc = BlocProvider.of<UserBloc>(context);
    super.didChangeDependencies();
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.green,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: Colors.green),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify ${widget.code}-${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
              eachFieldWidth: 40.0,
              eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  auth.UserCredential user = await auth.FirebaseAuth.instance
                      .signInWithCredential(auth.PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: pin));
                  print(user.user.uid);
                  User newUser =
                      User(userId: user.user.uid, userType: "Student");

                  userBloc.userEventSink
                      .add(AddUser(user: newUser));

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RouteScreen(
                                user: user.user,
                                userType: "Student",
                              )),
                      (route) => false);
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: ' ${widget.code + widget.phone}',
        verificationCompleted: (auth.PhoneAuthCredential credential) async {
          await auth.FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              User newUser = User(userId: value.user.uid, userType: "Student");

              userBloc.userEventSink
                  .add(AddUser(user: newUser));

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RouteScreen(
                            user: value.user,
                            userType: "Student",
                          )),
                  (route) => false);
            }
          });
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
