import 'package:chat_supabase_flutter/constants.dart';
import 'package:chat_supabase_flutter/models/app_user.dart';
import 'package:chat_supabase_flutter/utils/app_user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/components/rounded_button.dart';
import 'package:chat_supabase_flutter/screens/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_supabase_flutter/screens/group_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _password_controller = TextEditingController();

  final supabase = Supabase.instance.client;
  bool showSpinner = false;

  String email = '';
  String password = '';

  String alertMessage = '';
  String loginMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
        
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email') ,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: _password_controller,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  setState(() {
                    if (password.isEmpty) {
                      alertMessage = "";
                    }
                  });
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password') ,
              ),
              SizedBox(
                height: 24.0,
              ),
              createRoundedButton(Colors.orange, 'Log in', () async {
                bool loginSuccess = false;
                setState(() {
                  showSpinner = true;
                });
                try {
                  final AuthResponse res = await supabase.auth.signInWithPassword(
                    email: email,
                    password: password,
                  );
                  final Session? session = res.session;
                  final User? user = res.user;
        
                  loginSuccess = true;
                } on AuthException catch(e) {
                  //print('e: ' + e.message);
                  if (e.message.contains('Email not confirmed')) {
                    loginMessage = 'Check your email and click the confirmation link';
                  } else {
                    loginMessage = 'Invalid email or password';
                  }
                  loginSuccess = false;
                  alertMessage = loginMessage;
                }
                if (loginSuccess) {
                  alertMessage = '';
                  AppUser currentUser = await getCurrentUser();
                  var result = await Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => GroupScreen(appUser: currentUser)
                      )
                  ).then((value) {
                    _password_controller.clear();
                  });

                  if (!context.mounted) return;

                  print(result);
                } else {
                  setState(() {
                    //alertMessage = 'Invalid email or password';
                    alertMessage = loginMessage;
                  });
                  //alertMessage = 'Invalid email or password.';
                }
                setState(() {
                  showSpinner = false;
                });
              }),
              Center(
                  child: Text(
                      alertMessage,
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  )
              ),
              /*
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      //Implement login functionality.
                      // Here it is
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}