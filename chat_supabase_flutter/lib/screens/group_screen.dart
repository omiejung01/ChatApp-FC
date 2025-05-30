import 'package:chat_supabase_flutter/components/group_chat_button.dart';
import 'package:chat_supabase_flutter/constants.dart';
import 'package:chat_supabase_flutter/screens/profile_screen.dart';
import 'package:chat_supabase_flutter/utils/app_user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/components/rounded_button.dart';
import 'package:chat_supabase_flutter/screens/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:chat_supabase_flutter/screens/profile_screen.dart';
import 'package:chat_supabase_flutter/models/app_user.dart';
import 'package:chat_supabase_flutter/components/group_chat_button.dart';

AppUser _appUser = new AppUser();

class GroupScreen extends StatefulWidget {
  GroupScreen({super.key, required this.appUser}) {
    _appUser = appUser;
  }

  AppUser appUser;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {

  bool showSpinner = false;
  String _enteredEmail = '';

  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.person_2),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) {
                          //return ChatScreen();
                          return ProfileScreen(
                              email: _appUser.email, appUser: _appUser);
                        }
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:
                  () =>
                  showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) =>
                        AlertDialog(
                          title: const Text('You will be logged out.'),
                          content: const Text(
                              'Are you sure you want to log out?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => {},
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                //print('Outtttt');
                                Navigator.pop(context, 'Logout');
                                Navigator.pop(context, 'Logout');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  ),

            ),
          ],
          title: Text('Talk group'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        body: SafeArea(
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150),
            children: [
              Card(
                  child: TextButton(
                    onPressed: () {
                      setState(() {

                      });
                    },
                    child: IconButton(
                        onPressed: () {
                          _showEmailInputDialog(context);
                        },
                        icon: Icon(
                            Icons.add,
                            color: Colors.orange,
                            size: 56.0
                        )
                    ),
                  )
              ),
              //Card(child: _SampleCard(cardName: 'Elevated Card')),
              //Card.filled(child: _SampleCard(cardName: 'Filled Card')),
              //Card.outlined(child: _SampleCard(cardName: 'Outlined Card')),
              //GroupChatButton(),

            ],
          ),
        )
    );
  }

  Future<void> _showEmailInputDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receiver',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.orange,
                ),
                labelText: "Email",
                hintText: 'e.g., ohm@tetrasolution.com',
                hintStyle: TextStyle(
                  color: Colors.orange,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 20.0,
                    color: Colors.orange,
                  ),
                  borderRadius:  const BorderRadius.all(
                    Radius.circular(30.0)
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Colors.orange,
                  ),
                  borderRadius:  const BorderRadius.all(
                      Radius.circular(30.0)
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1.5,
                    color: Colors.orange,
                  ),
                  borderRadius:  const BorderRadius.all(
                      Radius.circular(30.0)
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email address.';
                }
                // Basic email regex validation
                final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email address.';
                }
                if (value == _appUser.email) {
                  return 'You cannot send messages to yourself.';
                }
                return null; // Return null if the input is valid
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                style: TextStyle(
                  color: Colors.orange
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm',
                style: TextStyle(
                    color: Colors.orange
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // If the form is valid, pop the dialog with the entered email
                  Navigator.of(context).pop(emailController.text);

                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) {
                            // Create new Chat group
                            
                            return ChatScreen();
                          }
                      )
                  );
                }
              },
            ),
          ],
        );
      },
    );

    // Update the state with the received email (if any)
    if (result != null) {
      setState(() {
        _enteredEmail = result;
      });
    }
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, child: Center(child: Text(cardName)));
  }
}
