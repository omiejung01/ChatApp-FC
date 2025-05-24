import 'package:chat_supabase_flutter/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;

import 'dart:convert';
import 'dart:async';

final _supabase = Supabase.instance.client;

Session? _session;
User? _user;

Future<AppUser> getCurrentUser() async {
  AppUser user = AppUser();
  try {
    _session = await _supabase.auth.currentSession;
    _user = await _supabase.auth.currentUser;
    String? this_email = _user!.email;
    if (this_email == null) {
      throw Exception('Null user');
    } else {
      user.email = this_email;

      String url =
          "https://tetrasolution.com/chatapp/api/user_details.php?email=${user.email}";

      final response = await http.get(
        Uri.parse(url),
        // Send authorization headers to the backend.
        headers: my.header,
      );

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;

      var allowed = false;
      String validateMessage = '';

      String success = responseJson['result'];
      print("result: $success");
      if (success.compareTo('Success') == 0) {
        allowed = true;
      } else {
        allowed = false;
        validateMessage = responseJson['Error'];
      }
      // Fetch User data
      if (allowed) {
        user.display_name = responseJson['display_name'];
        user.first_name = responseJson['first_name'];
        user.last_name = responseJson['last_name'];
        user.status = responseJson['status'];
        user.remark = responseJson['remark'];
        user.avatar = responseJson['avatar'];
      }
    }
  } catch (e) {
    print(e);
  }
  return user;
}
