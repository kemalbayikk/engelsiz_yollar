import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/constants/navigation/navigation_constans.dart';
import 'package:engelsiz_yollar/core/init/navigation/navigation_service.dart';
import 'package:engelsiz_yollar/view/home/pin_page/view/pin_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
part 'ana_sayfa_viewmodel.g.dart';

class AnasayfaViewModel = _AnasayfaViewModelBase with _$AnasayfaViewModel;

abstract class _AnasayfaViewModelBase with Store {
  final picker = ImagePicker();
  File _image;

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
  int myNum = 0;

  @observable
  var allData;

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pins');

  Future<void> getData() async {
    // Get docs from collection reference

    QuerySnapshot querySnapshot = await _collectionRef.get();
    double latitude;
    double longitude;

    // Get data from docs and convert map to List
    allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < allData.length; i++) {
      print(allData[i][1].toString());
      markers.add(Marker(
        markerId: MarkerId(allData[i]["pinId"].toString()),
        position: LatLng(double.parse(allData[i]["latitude"].toString()),
            double.parse(allData[i]["longitude"].toString())),
        infoWindow: InfoWindow(title: allData[i]["description"].toString()),
        icon: BitmapDescriptor.defaultMarker,
      ));
      print(allData[0]);
    }

    print(allData);
  }

  @action
  void increment() {
    myNum++;
    AppConstants.showSuccesToast('Başarılı', subTitle: 'Pin başarıyla eklendi');
  }

  @action
  void decrement() {
    myNum--;

    AppConstants.showErrorToast('Hata', subTitle: 'Lüten tekrar deneyiniz');
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
}
