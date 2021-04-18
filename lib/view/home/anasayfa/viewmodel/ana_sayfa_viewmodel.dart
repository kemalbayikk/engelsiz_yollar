import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:vibration/vibration.dart';
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
  Set<Marker> closeMarkers = {};
  @observable
  LatLng lastMapPosition = LatLng(37.3741, -122.0771);
  @observable
  MapType currentMapType = MapType.normal;

  @observable
  var allData;
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('pins');
  
  Reference storageRef = FirebaseStorage.instance.ref();

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
            print('$item');
            AppConstants().showModal(
                context: context,
                child: Column(
                  children: [
                    10.hSized,
                    Image.network(
                      item['mediaUrl'],
                      height: context.customHeight(4),
                    )
                  ],
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

    deletePost(String pinId) async {
    _collectionRef
        .doc(pinId)
        .get()
        .then((doc) => {
              if (doc.exists) {doc.reference.delete()}
            });

  }

  void checkDistancesPeriodically() async {
    getCurrentLocation();
    print("current  : $currentPosition");
    //print(allData);
    if (currentPosition != null) {
      for (int i = 0; i < allData.length; i++) {
        print(getDistance(
            double.parse(allData[i]["latitude"].toString()),
            double.parse(allData[i]["longitude"].toString()),
            currentPosition.latitude,
            currentPosition.longitude));

        if (getDistance(
                double.parse(allData[i]["latitude"].toString()),
                double.parse(allData[i]["longitude"].toString()),
                currentPosition.latitude,
                currentPosition.longitude) <
            0.01) {
          print("markerss : ");
          print(allData[i]);
          if (await Vibration.hasCustomVibrationsSupport()) {
            Vibration.vibrate(duration: 1000);
          } else {
            Vibration.vibrate();
            await Future.delayed(Duration(milliseconds: 500));
            Vibration.vibrate();
          }
          //closeMarkers.add(markers.)
        }
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
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latitudeUser - latitude) * p) / 2 +
        c(latitude * p) *
            c(latitudeUser * p) *
            (1 - c((longitudeUser - longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
