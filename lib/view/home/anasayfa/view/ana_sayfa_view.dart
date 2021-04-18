import 'dart:async';
import 'package:engelsiz_yollar/core/components/buttons/add_marker_button.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:engelsiz_yollar/view/home/anasayfa/viewmodel/ana_sayfa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AnasayfaView extends StatefulWidget {
  @override
  _AnasayfaViewState createState() => _AnasayfaViewState();
}

class _AnasayfaViewState extends State<AnasayfaView> {
  final AnasayfaViewModel _viewModel = AnasayfaViewModel();

  @override
  void initState() {
    _viewModel.getCurrentLocation();
    _viewModel.getData(context: context);
    const oneSec = const Duration(seconds:3);
    new Timer.periodic(oneSec, (Timer t) => _viewModel.checkDistancesPeriodically());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              backgroundColor: Colors.orange[100],
              foregroundColor: Colors.black,
              onPressed: () {
                _viewModel.mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        _viewModel.currentPosition.latitude,
                        _viewModel.currentPosition.longitude,
                      ),
                      zoom: 18.0,
                    ),
                  ),
                );
              },
              child: Icon(Icons.my_location),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () async {
              await _viewModel.getImage(context).then((value) {
                setState(() {
                  _viewModel.getData(context: context);
                });
              });
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Observer(builder: (_) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _viewModel.lastMapPosition,
                zoom: 16.0,
              ),
              mapType: _viewModel.currentMapType,
              markers: _viewModel.markers,
              onCameraMove: _viewModel.onCameraMove,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _viewModel.mapController = controller;
              },
            );
          }),
          Container(
              padding: EdgeInsets.only(bottom: 24.0),
              alignment: Alignment.center,
              child: Icon(
                Icons.location_pin,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}
