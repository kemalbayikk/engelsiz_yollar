// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ana_sayfa_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnasayfaViewModel on _AnasayfaViewModelBase, Store {
  final _$myNumAtom = Atom(name: '_AnasayfaViewModelBase.myNum');

  @override
  int get myNum {
    _$myNumAtom.reportRead();
    return super.myNum;
  }

  @override
  set myNum(int value) {
    _$myNumAtom.reportWrite(value, super.myNum, () {
      super.myNum = value;
    });
  }

  final _$_AnasayfaViewModelBaseActionController =
      ActionController(name: '_AnasayfaViewModelBase');

  @override
  void increment() {
    final _$actionInfo = _$_AnasayfaViewModelBaseActionController.startAction(
        name: '_AnasayfaViewModelBase.increment');
    try {
      return super.increment();
    } finally {
      _$_AnasayfaViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$_AnasayfaViewModelBaseActionController.startAction(
        name: '_AnasayfaViewModelBase.decrement');
    try {
      return super.decrement();
    } finally {
      _$_AnasayfaViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
myNum: ${myNum}
    ''';
  }
}
