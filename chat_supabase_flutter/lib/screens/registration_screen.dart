import 'package:chat_supabase_flutter/constants.dart';
import 'package:chat_supabase_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;
import 'dart:convert';



class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _supabase = Supabase.instance.client;
  bool showSpinner = false;

  String alertMessage = '';
  String validateMessage = '';

  String email = '';
  String password = '';
  String confirm_password = '';
  String display_name = '';
  String first_name = '';
  String last_name = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Expanded(
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 180.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'Please enter a valid email address',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    confirm_password = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'Confirm our password',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    display_name = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'Enter your display name',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    first_name = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'First name',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    last_name = value;
                  },
                  decoration: kTextFieldDecorationPurple.copyWith(
                    hintText: 'Last name',
                  ),
                ),
                SizedBox(height: 8.0),
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

                          bool register_success = await registerToDatabase(
                            email,
                            display_name,
                            first_name,
                            last_name,
                            '',
                          );
                          if (register_success) {
                            await _showEmailDialog();
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
                          }
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
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    alertMessage,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
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

    if (allowed) {
      if (display_name.isEmpty) {
        allowed = false;
        validateMessage = "Please enter your display name";
      }
    }

    if (allowed) {
      // Check display name
      String url =
          "https://tetrasolution.com/chatapp/api/check_display_name.php?display_name=$display_name";

      final response = await http.get(
        Uri.parse(url),
        // Send authorization headers to the backend.
        headers: my.header,
      );

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      String success = responseJson['result'];
      if (success.compareTo('Success') == 0) {
        allowed = true;
        validateMessage = '';
      } else {
        allowed = false;
        validateMessage = responseJson['Error'];
      }
    }

    // First name cannot be blank
    if (allowed) {
      if (first_name.trim().isEmpty) {
        allowed = false;
        validateMessage = "Please enter your first name";
      } else {
        allowed = true;
        validateMessage = '';
      }
    }

    return allowed;
  }

  Future<bool> registerToDatabase(
    String email,
    String display_name,
    String first_name,
    String last_name,
    String remark,
  ) async {
    bool result = true;

    String url =
        "https://tetrasolution.com/chatapp/api/register_user.php?"
        "email=$email&display_name=$display_name&"
        "first_name=$first_name&last_name=$last_name&remark=$remark";

    final response = await http.get(
      Uri.parse(url),
      // Send authorization headers to the backend.
      headers: my.header,
    );

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

    String success = responseJson['result'];
    print("result: $success");
    if (success.compareTo('Success') == 0) {
      result = true;
    } else {
      result = false;
    }

    return result;
  }

  Future<void> _showEmailDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Thank you for registration!!!'),
                Text(''),
                Text('Please confirm registration by clicking the link in your email.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('I understand.'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
