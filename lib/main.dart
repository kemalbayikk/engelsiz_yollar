import 'package:bot_toast/bot_toast.dart';
import 'view/auth/login/view/login_view.dart';
import 'view/home/anasayfa/view/ana_sayfa_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/navigation/navigation_constans.dart';
import 'core/init/cache/locale_manager.dart';
import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/notifier/provider_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocaleManager.prefrencesInit();
  runApp(MultiProvider(
      providers: [...ApplicationProvider.instance.dependItems],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: ThemeData(
          backgroundColor: Colors.white60,
          primaryColor: Colors.black,
          accentColor: Colors.orange),
      navigatorObservers: [BotToastNavigatorObserver()],
      navigatorKey: NavigationService.instance.navigatorKey,
      onGenerateRoute: NavigationRoute.instance.onGenerateRoute,
      routes: {
        NavigationConstant.HOME: (context) => AnasayfaView(),
        NavigationConstant.LOGIN_VIEW: (context) => LoginView(),
        NavigationConstant.HOME_VIEW: (context) => AnasayfaView(),
      },
    );
  }
}
