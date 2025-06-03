import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/components/textfield_widget.dart';
import 'package:chat_supabase_flutter/components/profile_menu.dart';
import 'package:chat_supabase_flutter/screens/change_password_screen.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_supabase_flutter/models/app_user.dart';

import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;
import 'dart:convert';
import 'dart:async';

AppUser _appUser = AppUser();

TextEditingController _firstNameController = TextEditingController();
TextEditingController _lastNameController = TextEditingController();

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.appUser}) {
    _appUser = appUser;

    _firstNameController.text = _appUser.first_name;
    _lastNameController.text = _appUser.last_name;
  }

  AppUser appUser = new AppUser();

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Account settings"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
                bottom: 4.0,
              ),
              child: TextField(
                //keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                readOnly: true,
                enabled: false,
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: _appUser.email,
                ),
              ),
            ),

            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
                bottom: 4.0,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                readOnly: true,
                enabled: false,
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: _appUser.display_name,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
                bottom: 4.0,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _firstNameController,
                onChanged: (value) async {
                  if (value.length > 1) {
                    _appUser.first_name = value;

                    String url =
                        "https://tetrasolution.com/chatapp/api/change_first_name.php?email=${_appUser.email}&first_name=$value";
                    print('url: ' + url);

                    final response = await http.get(
                      Uri.parse(url),
                      // Send authorization headers to the backend.
                      headers: my.header,
                    );

                    final responseJson =
                        jsonDecode(response.body) as Map<String, dynamic>;

                    String success = responseJson['result'];
                    //print("result: $success");
                    if (success.compareTo('Success') == 0) {
                      //allowed = true;
                    } else {
                      //allowed = false;
                      //validateMessage = responseJson['Error'];
                      errorMessage = "Cannot change firstname";
                    }
                  }
                },
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: 'First name',
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 8.0,
                bottom: 4.0,
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _lastNameController,
                onChanged: (value) async {
                  if (value.length > 1) {
                    _appUser.last_name = value;

                    String url =
                        "https://tetrasolution.com/chatapp/api/change_last_name.php?email=${_appUser.email}&first_name=$value";
                    //print('url: ' + url);

                    final response = await http.get(
                      Uri.parse(url),
                      // Send authorization headers to the backend.
                      headers: my.header,
                    );

                    final responseJson =
                        jsonDecode(response.body) as Map<String, dynamic>;

                    String success = responseJson['result'];
                    //print("result: $success");
                    if (success.compareTo('Success') == 0) {
                      //allowed = true;
                    } else {
                      //allowed = false;
                      //validateMessage = responseJson['Error'];
                      errorMessage = "Cannot change lastname";
                    }
                  }
                },
                decoration: kTextFieldDecorationOrange.copyWith(
                  hintText: 'Last name',
                ),
              ),
            ),
            SizedBox(height: 8.0),

            ProfileMenu(
              text: "Change password",
              icon: Icon(
                Icons.account_circle,
                color: Colors.orange,
                size: 30.0,
              ),
              press:
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangePasswordScreen();
                        },
                      ),
                    ),
                  },
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRouteChangePassword() {
  return PageRouteBuilder(
    pageBuilder:
        (context, animation, secondaryAnimation) =>
            const ChangePasswordScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
