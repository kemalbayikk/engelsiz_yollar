import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:engelsiz_yollar/view/home/anasayfa/viewmodel/ana_sayfa_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AnasayfaView extends StatelessWidget {
  final AnasayfaViewModel _viewModel = AnasayfaViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
