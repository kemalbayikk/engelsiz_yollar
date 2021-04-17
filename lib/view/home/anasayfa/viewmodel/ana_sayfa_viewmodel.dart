import 'dart:io';

import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/view/home/pin_page/view/pin_page_view.dart';
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
    final pickedFile = await picker.getImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }

        Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PinPage(
                  image: _image,
                  latitude: lastMapPosition.latitude,
                  longitude: lastMapPosition.longitude,
                )));
  }
}
