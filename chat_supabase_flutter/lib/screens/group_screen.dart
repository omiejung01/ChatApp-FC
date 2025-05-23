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


  void initState()  {
    super.initState();
  }


    @override
  Widget build(BuildContext context)  {

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
                          return ProfileScreen(email : _appUser.email, appUser: _appUser);
                        }
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed:
                    () => showDialog<String>(
                  context: context,
                  builder:
                      (BuildContext context) => AlertDialog(
                    title: const Text('You will be logged out.'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {},
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: ()  {
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
        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(child: _SampleCard(cardName: 'Elevated Card')),
            Card.filled(child: _SampleCard(cardName: 'Filled Card')),
            Card.outlined(child: _SampleCard(cardName: 'Outlined Card')),
          ],
        ),
      )
    );
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
