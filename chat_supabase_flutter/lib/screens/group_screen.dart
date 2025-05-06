import 'package:chat_supabase_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/components/rounded_button.dart';
import 'package:chat_supabase_flutter/screens/chat_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _supabase = Supabase.instance.client;

Session? session;
User? user;

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final supabase = Supabase.instance.client;
  bool showSpinner = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      session = _supabase.auth.currentSession;
      user = _supabase.auth.currentUser;
      String? this_email = user!.email;
      if (this_email == null) {
        throw Exception('Null user');
      } else {
        currentUserEmail = this_email;
        //print("User email: $email");
      }
    } catch (e) {
      print(e);
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {

              },
            ),
          ],
        title: Text('Talk group'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(

        )
      ),
    );
  }
}
