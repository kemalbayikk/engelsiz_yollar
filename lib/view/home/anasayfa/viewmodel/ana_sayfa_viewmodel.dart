import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz_yollar/core/components/buttons/my_button.dart';
import 'package:engelsiz_yollar/core/components/cards/custom_card.dart';
import 'package:engelsiz_yollar/core/components/cards/modal_content.dart';
import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/constants/navigation/navigation_constans.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:engelsiz_yollar/core/init/navigation/navigation_service.dart';
import 'package:engelsiz_yollar/view/home/pin_page/view/pin_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:vector_math/vector_math.dart';
part 'ana_sayfa_viewmodel.g.dart';

class AnasayfaViewModel = _AnasayfaViewModelBase with _$AnasayfaViewModel;

abstract class _AnasayfaViewModelBase with Store {
  final picker = ImagePicker();
  File _image;
  Reference storageRef = FirebaseStorage.instance.ref();

  GoogleMapController mapController;
  @observable
  Position currentPosition;
  @observable
  Set<Marker> markers = {};
  @observable
  LatLng lastMapPosition = LatLng(37.3741, -122.0771);
  @observable
  MapType currentMapType = MapType.normal;

  @observable
  var allData;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pins');

  Future<void> getData({
    @required BuildContext context,
  }) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    // Get data from docs and convert map to List
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    if (allData != null) {
      for (int i = 0; i < allData.length; i++) {
        var item = allData[i];

        markers.add(Marker(
          onTap: () {
            AppConstants().showModal(
                context: context,
                child: ModalContent(
                  item: item,
                  onTap: (pinId) async {
                    await deletePost(pinId).then((value) => AppConstants.showSuccesToast('Başarılı',subTitle: 'Pin kaldırma talebiniz alınmıştır'));
                  },
                ));
          },
          markerId: MarkerId(allData[i]['pinId'].toString()),
          position: LatLng(double.parse(allData[i]['latitude'].toString()),
              double.parse(allData[i]['longitude'].toString())),
          infoWindow: InfoWindow(title: allData[i]['description'].toString()),
          icon: BitmapDescriptor.defaultMarker,
        ));

        //print(getDistance(double.parse(allData[i]["latitude"].toString()), double.parse(allData[i]["longitude"].toString()), currentPosition.latitude, currentPosition.longitude));
      }
    }
  }

  Future deletePost(String pinId) async {
    // await storageRef.child('pin$pinId.jpg').delete();
    await _collectionRef.doc(pinId).get().then((doc) => {
          if (doc.exists) {doc.reference.delete()}
        });

    
  }

  void checkDistancesPeriodically() {
    //print(allData);
    if (currentPosition != null) {
      for (int i = 0; i < allData.length; i++) {
        print(getDistance(
            double.parse(allData[i]["latitude"].toString()),
            double.parse(allData[i]["longitude"].toString()),
            currentPosition.latitude,
            currentPosition.longitude));
      }
    }
  }

  @action
  onCameraMove(CameraPosition cameraPosition) {
    lastMapPosition = cameraPosition.target;
  }

  @action
  getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position;
      print(currentPosition);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
    }).catchError((e) {
      print("error");
      print(e);
    });
  }

  @action
  onAddMarkerButtonPressed() {
    markers.add(Marker(
      markerId: MarkerId(lastMapPosition.toString()),
      position: lastMapPosition,
      infoWindow:
          InfoWindow(title: 'This is Title', snippet: 'This is Snippet'),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  Future getImage(BuildContext context) async {
    final _fireBaseAuth = FirebaseAuth.instance;
    if (_fireBaseAuth.currentUser != null) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PinPage(
                      image: _image,
                      latitude: lastMapPosition.latitude,
                      longitude: lastMapPosition.longitude,
                    )));
      } else {
        print('No image selected.');
      }
    } else {
      await NavigationService.instance
          .navigateToPage(path: NavigationConstant.LOGIN_VIEW);
    }
  }

  double getDistance(double latitude, double longitude, double latitudeUser,
      double longitudeUser) {
    final int R = 6371; // Radius of the earth

    double latDistance = radians(latitudeUser - latitude);
    double lonDistance = radians(longitudeUser - longitude);
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(radians(latitude)) *
            cos(radians(latitudeUser)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c * 1000; // convert to meters

    return sqrt(distance);

    /*double a;
    double b;
    double c;

    a = cos(latitude)*cos(longitude)*cos(latitudeUser)*cos(longitudeUser);
    b = cos(latitude)*sin(longitude)*cos(latitudeUser)*sin(longitudeUser);
    c = sin(latitude)*sin(latitudeUser);
    return a * cos(a + b + c) * 6371;*/
  }
}
