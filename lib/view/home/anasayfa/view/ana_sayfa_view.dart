import 'dart:async';

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
    _viewModel.getData();
      //const oneSec = const Duration(seconds:2);
      //new Timer.periodic(oneSec, (Timer t) => _viewModel.checkDistancesPeriodically());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              onMapCreated: (GoogleMapController controller) {
                _viewModel.mapController = controller;
              },
            );
          }),
          /*Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () {
                          setState(() {
                            _viewModel.getImage(context);
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.add_location, size: 36.0)),
                  ],
                )),
          ),*/
          Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_pin,
                  color: Colors.black,
                )),
          ),
          Padding(
            padding: EdgeInsets.all(42.0),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    RaisedButton(
                      onPressed: () async {
                              setState(() {
                            _viewModel.getImage(context);
                          });
                      },
                      child: Text(
                        "Yolda Bir Sorun İşaretle",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    )
                  ],
                )),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: ClipOval(
                  child: Material(
                    color: Colors.orange[100], // button color
                    child: InkWell(
                      splashColor: Colors.orange, // inkwell color
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () {
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    /*return Scaffold(
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              _viewModel.increment();
            },
          ),
          FloatingActionButton(
            onPressed: () {
              _viewModel.decrement();
            },
          ),
        ],
      ),
      body: Center(
        child: Observer(builder: (_) {
          return Text('${_viewModel.myNum}');
        }),
      ),
    );*/
  }
}
