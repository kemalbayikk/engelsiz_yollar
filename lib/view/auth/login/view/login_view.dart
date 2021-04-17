import 'package:engelsiz_yollar/core/constants/app/app_constants.dart';
import 'package:engelsiz_yollar/core/constants/navigation/navigation_constans.dart';
import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:engelsiz_yollar/core/init/navigation/navigation_service.dart';
import 'package:engelsiz_yollar/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      messages: LoginMessages(
          forgotPasswordButton: 'Şifremi Unuttum?',
          signupButton: 'Kayıt Ol',
          loginButton: 'GİRİŞ',
          passwordHint: 'Şifre',
          usernameHint: 'E-Posta',
          recoverPasswordButton: 'GÖNDER',
          recoverPasswordSuccess: 'Sıfırlama mailiniz başarıyla gönderilmiştir',
          recoverPasswordDescription: 'Şifrenizi mail hesabınıza göndereceğiz',
          recoverPasswordIntro: 'Mail adresinizi yazınız',
          goBackButton: 'GERİ',
          confirmPasswordHint: 'Şifre Tekrar',
          confirmPasswordError: 'Şifreler aynı değil',
          signUpSuccess: 'Kaydınız Başarıyla Yapılmıştır ',
          flushbarTitleSuccess: 'Başarılı',
          flushbarTitleError: 'Hata'),
      onLogin: (data) async {
        return await AuthService().signInWith(data.name, data.password);
        
      },
      onSignup: (data) async {
       return await AuthService()
            .registerWith(data.name, data.password, 'samil', 'demir');
           
      },
      onRecoverPassword: (data) {
        print(' onRecoverPassword $data');
        return Future.delayed(10.millisecondsDuration);
      },
      loginAfterSignUp: false,
      onSubmitAnimationCompleted: () {
        NavigationService.instance
            .navigateToPage(path: NavigationConstant.HOME_VIEW);
      },
      emailValidator: AppConstants.emailKontrol,
      title: 'Engelsiz Yollar',
    );
  }
}
