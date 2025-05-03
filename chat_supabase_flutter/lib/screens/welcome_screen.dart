import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/screens/login_screen.dart';
import 'package:chat_supabase_flutter/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_supabase_flutter/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  double opacity = 0.0;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(
        seconds: 2,
      ),
      vsync: this,
      //upperBound: 100,
    );

    //animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    animation = ColorTween(begin: Colors.black, end: Colors.white).animate(controller);

    controller.forward();
    /*
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    */
    controller.addListener(() {
      setState(() {
        opacity = controller.value * 100;
      });
      //print(animation.value);
      //opacity = 1.0 - controller.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromRGBO(255, 0, 0, opacity),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo2.png'),
                      //height: opacity,
                      height: 300.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            createRoundedButton(Colors.orange, 'Log in', () {
              Navigator.push(
                context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 3),
                      pageBuilder: (_, __, ___) => LoginScreen()
                  )
                ,
              );
            }),
            /*
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            }
                        )
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            */
            createRoundedButton(Colors.purple, 'Register', () {
              Navigator.push(context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 3),
                      pageBuilder: (_, __, ___) => RegistrationScreen()
                  )
              );
            }),
            /*
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegistrationScreen();
                        }
                      )
                    );
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}