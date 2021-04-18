import '../../../../core/components/buttons/my_button.dart';
import '../../../../core/components/cards/image_card.dart';
import '../../../../core/constants/app/app_constants.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class PinPage extends StatefulWidget {
  final double latitude;
  final double longitude;
   File image;
  PinPage({this.latitude, this.longitude, this.image});

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  //final PinPageViewModel _pinPageViewModel = PinPageViewModel();

  Reference storageRef = FirebaseStorage.instance.ref();
  var usersRef;
  var pinsRef;
  TextEditingController captionController;
  String pinId;

  @override
  void initState() {
    super.initState();
    usersRef = FirebaseFirestore.instance.collection('users');
    pinsRef = FirebaseFirestore.instance.collection('pins');
    captionController = TextEditingController();
    pinId = Uuid().v4();
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  createPinInFirestore({
    String mediaUrl,
    String description,
    UserFromFirebase user,
    double latitude,
    double longitude,
    //DocumentSnapshot doc
  }) {
    pinsRef.doc(pinId).set({
      "pinId": pinId,
      //"ownerId": doc['uid'],
      "mediaUrl": mediaUrl,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(widget.image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$pinId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      widget.image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("pin_$pinId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

 void handleSubmit(parentContext) async {
    var filePath = widget.image.path;
    if (filePath.contains('jpg')) {
      await compressImage();
    }
    var mediaUrl = await uploadImage(widget.image);
    createPinInFirestore(
      mediaUrl: mediaUrl,
      description: captionController.text,
      //user: user,
      latitude: widget.latitude,
      longitude: widget.longitude,
      //doc: doc,
    );
    captionController.clear();
    pinId = Uuid().v4();
    await NavigationService.instance.navPop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sorun Paylaş'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (captionController.text.isNotEmpty) {
            handleSubmit(context);
          } else {
            AppConstants.showErrorToast('Açıklama',
                subTitle: 'Lütfen bir açıklama giriniz');
          }
        },
        tooltip: 'Paylaş',
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ImageCard(image: widget.image),
          MyButton(
            child: TextField(
              controller: captionController,
              style: context.textTheme.bodyText1.copyWith(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Bir açıklama yaz ... ',
                hintStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 50,
                    color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
