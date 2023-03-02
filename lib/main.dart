import 'dart:convert';
import 'dart:io';
import 'package:ez_xpert/screen/Splash.dart';
import 'package:ez_xpert/utils/locator.dart';
import 'package:ez_xpert/utils/share_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'language/app_localizations.dart';
import 'language/app_store.dart';
import 'language/languages.dart';
import 'utils/common.dart';

BaseLanguage? language;
AppStore appStore = AppStore();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', //id
    'High Importance Notifications', // name
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white24,

    // Status bar brightness (optional)
    statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
    statusBarBrightness: Brightness.light, // status bar color
  ));
  Provider.debugCheckInvalidValueType = null;
  await initialize(aLocaleLanguageList: languageList());
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeLeft,
    ],
  );
  setupLocator();
  await locator<SharedPrefs>().init();

  await appStore
      .setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: 'en'));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(const MyApp());
  configLoading();
  configLocalNotification();
  _getFCMToken();
}

void configLocalNotification() {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showNotification1(RemoteMessage message) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    Platform.isAndroid ? 'com.ezxpert.ez_xpert1' : 'com.ezxpert.ez_xpert1',
    'Ez_xpert',
    playSound: true,
    enableVibration: true,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  print(message.data.toString());
  await flutterLocalNotificationsPlugin.show(
      0,
      message.data['title'].toString(),
      message.data['message'].toString(),
      platformChannelSpecifics,
      payload: json.encode(message));
}

_getFCMToken() async {
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.getAPNSToken();
  FirebaseMessaging.instance.getToken().then((token) async {
    print('fcm-token-----$token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fcmToken', token!);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('onMsgggggggg: ' + message.data.toString());

    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;
    if (androidNotification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  color: const Color.fromRGBO(71, 79, 156, 1),
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));
    }
    if (appleNotification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification!.title,
          notification.body,
          const NotificationDetails(
              iOS: IOSNotificationDetails(
            presentSound: true,
            presentAlert: true,
            presentBadge: true,
          )));
    }
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext get context => navigatorKey.currentContext!;

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: MyApp.navigatorKey,
      color: HexColor("#1a226c"),
      theme: ThemeData(
        bottomAppBarColor: HexColor("#1a226c"),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins400',
          ),
        ),
        fontFamily: 'Poppins400',
      ),
      home: Splash(),
      builder: EasyLoading.init(),
      //supportedLocales: LanguageDataModel.languageLocales(),
      localizationsDelegates: const [
        AppLocalizations(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) => locale,
      locale: Locale(appStore.selectedLanguageCode),
    );
  }
}
