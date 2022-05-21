import 'package:app_for_specially_abled/init.dart';
import 'package:app_for_specially_abled/pages/audioNav%20custom.dart';
import 'package:app_for_specially_abled/pages/audioNav.dart';
import 'package:app_for_specially_abled/pages/home.dart';
import 'package:app_for_specially_abled/pages/learn.dart';
import 'package:app_for_specially_abled/pages/login.dart';
import 'package:app_for_specially_abled/pages/noiseMeter.dart';
import 'package:app_for_specially_abled/pages/player.dart';
import 'package:app_for_specially_abled/pages/signChat.dart';
import 'package:app_for_specially_abled/pages/signup.dart';
import 'package:app_for_specially_abled/pages/voiceAdd.dart';
import 'package:app_for_specially_abled/pages/voiceAssign.dart';
import 'package:flutter/material.dart';
import 'package:app_for_specially_abled/pages/textToSign.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';



void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.deepPurple[400], // status bar color
  ));
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    initOneSignal();
    super.initState();
  }

  Future<void> initOneSignal()async {

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    await OneSignal.shared.setAppId("ec008e93-b422-4fa5-abda-e684db23b3aa");

    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Colors.deepPurple[400],
          primaryColor: Colors.deepPurple[400]
      ),
      routes: {
        "/home" : (context) => Home(),
        "/signChat" : (context) => SignChat(),
        "/noiseMeter" : (context) => NoiseMeterClass(),
        "/audioNav" : (context) => AudioNav(),
        "/audioNavCustom" : (context) => AudioNavCustom(),
        "/learn" : (context) => Learn(),
        "/login" : (context) => Login(),
        "/signup" : (context) => Signup(),
        "/init" : (context) => Init(),
        "/voiceAssign" : (context) => VoiceAssign(),
        "/player" : (context) => Player(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/textToSign" : (context) => TextToSign(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/voiceAdd" : (context) => VoiceAdd()
      },
      initialRoute: "/init",
    );
  }
}
