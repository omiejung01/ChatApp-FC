import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'secret.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabase_url,
    anonKey: anon_key,
  );
  runApp(OmegaChat());
}


//void main() => runApp(OmegaChat());

class OmegaChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WelcomeScreen(),
    );
  }
}