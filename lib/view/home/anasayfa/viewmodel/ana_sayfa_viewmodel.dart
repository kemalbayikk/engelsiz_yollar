import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:mobx/mobx.dart';
part 'ana_sayfa_viewmodel.g.dart';

class AnasayfaViewModel = _AnasayfaViewModelBase with _$AnasayfaViewModel;

abstract class _AnasayfaViewModelBase with Store {
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
}
