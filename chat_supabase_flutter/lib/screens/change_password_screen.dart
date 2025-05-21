import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/components/textfield_widget.dart';
import 'package:chat_supabase_flutter/components/profile_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;
import 'dart:convert';
import 'package:chat_supabase_flutter/components/rounded_button.dart';


//import 'package:flutter_svg/flutter_svg.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final _supabase = Supabase.instance.client;
  bool showSpinner = false;

  String email = '';
  String alertMessage = '';
  String validateMessage = '';

  String old_password = '';
  String password = '';
  String confirm_password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Change password"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:8.0, bottom: 4.0),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  old_password = value;
                },
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: 'Old password',
                ),
              ),
            ),SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:8.0, bottom: 4.0),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: 'New password',
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:8.0, bottom: 4.0),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  confirm_password = value;
                },
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: 'Confirm new password',
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:8.0, bottom: 4.0),
              child: createRoundedButton(Colors.purple, 'Update password', () async {
                setState(() {

                });
              },
              ),
            ),

            /*
            Padding(

              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.purple,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    // if password match
                    // if email not taken
                    // display name not taken

                    //print('email: $email');
                    //print('password: $password');

                    bool result = await checkInput();

                    if (result) {
                      validateMessage = "You are ready!!!";

                      final AuthResponse res = await _supabase.auth.signUp(
                        email: email,
                        password: password,
                      );
                      final Session? session = res.session;
                      final User? user = res.user;

                      /*
                      bool register_success = await registerToDatabase(
                        email,
                        display_name,
                        first_name,
                        last_name,
                        '',
                      );


                      if (register_success) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                        );
                      } else {
                        setState(() {
                          showSpinner = false;
                          alertMessage = 'Registration error!!';
                        });
                      }*/
                    } else {
                      setState(() {
                        showSpinner = false;
                        alertMessage = validateMessage;
                      });
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Update password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),*/
            Center(
              child: Text(
                alertMessage,
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ]
        ),
      ),
    );
  }



  Future<bool> checkInput() async {
    bool allowed = false;
    validateMessage = "";

    if (email.length < 4) {
      allowed = false;
      validateMessage = 'Please enter email.';
    } else {
      bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);

      if (emailValid) {
        allowed = true;
        validateMessage = "";
      } else {
        allowed = false;
        validateMessage = "Email address is invalid";
      }

      // check duplicate email
      if (allowed) {
        String url =
            "https://tetrasolution.com/chatapp/api/check_email.php?email=$email";

        final response = await http.get(
          Uri.parse(url),
          // Send authorization headers to the backend.
          headers: my.header,
        );

        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

        String success = responseJson['result'];
        print("result: $success");
        if (success.compareTo('Success') == 0) {
          allowed = true;
        } else {
          allowed = false;
          validateMessage = responseJson['Error'];
        }
      }
    }

    if (allowed) {
      if (password.isEmpty) {
        allowed = false;
        validateMessage = 'Please enter password';
      } else {
        if (password.length <= 6) {
          allowed = false;
          validateMessage = 'Password is too weak';
        } else {
          if (password.compareTo(confirm_password) == 0) {
            allowed = true;
            validateMessage = "";
          } else {
            allowed = false;
            validateMessage = "Passwords do not match. Please try again";
          }
        }
      }
    }
    return allowed;
  }

}

