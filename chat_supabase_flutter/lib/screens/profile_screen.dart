import 'package:flutter/material.dart';
import 'package:chat_supabase_flutter/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:chat_supabase_flutter/secret.dart' as my;
import 'dart:convert';
import 'dart:async';
import 'package:chat_supabase_flutter/components/profile_menu.dart';
import 'package:chat_supabase_flutter/screens/account_screen.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

//final _supabase = Supabase.instance.client;

//Session? session;
//User? user;

String _currentUserEmail = '';

class ProfileScreen extends StatefulWidget {

  String email = '';
  ProfileScreen({super.key, required this.email}) {
    _currentUserEmail = email;
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.orange,
        elevation: 0.0,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: Icon(
                Icons.account_circle,
                color: Colors.orange,
                size: 30.0,
              ),
              press:
                  () => {
                Navigator.of(context).push(
                    _createRouteAccount()
                ),
              },
            ),
            ProfileMenu(
              text: "Help Center",
              icon: Icon(Icons.help, color: Colors.orange, size: 30.0),
              press: () {},
            ),
            //ProfileMenu(
            //  text: "Log Out",
            //  icon: Icon(Icons.logout, color: Colors.orange, size: 30.0),
            //  press: () {},
            //),
          ],
        ),
      ),
    );
  }

  Route _createRouteAccount() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AccountScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

class ProfilePic extends StatefulWidget {
  const ProfilePic({super.key});

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  String _pictureLocation = "https://tetrasolution.com/chatapp/images/person_blue02.png";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                _pictureLocation
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () async {
                  print('Ad Astra Abyssosque!! - 01');
                  await _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: false,
                  );
                  XFile? thisFile = _mediaFileList?.first;
                  if (thisFile == null) {
                    print('No data');
                  } else {
                    print('Path: ' + thisFile.path);
                    String newFile = await startUpload(thisFile);
                    setState(() {
                      _pictureLocation = newFile;
                    });
                    print('location: ' + _pictureLocation);
                  }

                },
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.orange,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This is to upload - by Ohm 20 May 2025

  List<XFile>? _mediaFileList;
  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
      }) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (context.mounted) {
      if (isVideo) {
        /*
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
        await _playVideo(file); */
      } else if (isMultiImage) { /*
        await _displayPickImageDialog(context, true, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = isMedia
                ? await _picker.pickMultipleMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
              limit: limit,
            )
                : await _picker.pickMultiImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
              limit: limit,
            );
            setState(() {
              _mediaFileList = pickedFileList;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        }); */
      } else if (isMedia) {
        //await _displayPickImageDialog(context, false, (double? maxWidth,
        //    double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = <XFile>[];
            final XFile? media = await _picker.pickMedia(
              //maxWidth: maxWidth,
              //maxHeight: maxHeight,
              //imageQuality: quality,
            );
            if (media != null) {
              pickedFileList.add(media);
              setState(() {
                _mediaFileList = pickedFileList;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        //});
      } else {
        //await _displayPickImageDialog(context, false, (double? maxWidth,
            //double? maxHeight, int? quality, int? limit) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
             // maxWidth: maxWidth,
              //maxHeight: maxHeight,
              //imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        //});
      }
    }
  }

  // di
  String uploadEndPoint = 'https://media04.tetraserver.com/flutter/upload_image.php';
  Future<String> startUpload(XFile medium) async {
    //String fileName = filePath.split('/').last;
    return await upload(medium);
  }

  Future<String> upload(XFile medium) async {
    String returnValue = '';
    String fileName = medium.path.split('/').last;
    String base64Image = base64Encode(await medium.readAsBytes());
    print("base64: " + base64Image.length.toString());
    await http.post(Uri.parse(uploadEndPoint),
        body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
     String target = (result.statusCode == 200 ? result.body : 'Okay');
     //_pictureLocation = target;
     returnValue = target;
     print('target: ' + target.toString());
    }).catchError((error) {
      //setStatus(error);
    });
    return returnValue;
  }
}
