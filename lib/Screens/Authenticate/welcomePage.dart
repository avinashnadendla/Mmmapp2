import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mmmapp/Screens/Authenticate/login_Screen.dart';
import 'package:mmmapp/Screens/Authenticate/signup_Screen.dart';
import 'package:mmmapp/bloc/userRepository.dart';

class WelcomePage extends StatefulWidget {
  final UserRepository _userRepository;

  const WelcomePage({Key key, UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Welcome',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          children: [
            TextSpan(
              text: ' eLearn',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'er',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: () {
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen(userRepository: widget._userRepository,)));

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(
              fontSize: 22, color: Colors.blueGrey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _tutorButton() {
    return InkWell(
      onTap: () {
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterScreen(userRepository: widget._userRepository,)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Register as Tutor',
          style: TextStyle(
              fontSize: 22, color: Colors.blueGrey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _studentButton() {
    return InkWell(
      onTap: () {
        
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PhoneScreen()));

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login as Student',
          style: TextStyle(
              fontSize: 22, color: Colors.blueGrey, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.yellow[800],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(),
              SizedBox(
                height: 80,
              ),
              _loginButton(),
              SizedBox(
                height: 20,
              ),
              _tutorButton(),
              SizedBox(
                height: 20.0,
              ),
              _studentButton(),
            ],
          ),
        ),
      ),
    );
  }
}
