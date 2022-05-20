import 'package:app_for_specially_abled/pages/audioNav%20custom.dart';
import 'package:app_for_specially_abled/pages/audioNav.dart';
import 'package:app_for_specially_abled/pages/home.dart';
import 'package:app_for_specially_abled/pages/learn.dart';
import 'package:app_for_specially_abled/pages/noiseMeter.dart';
import 'package:app_for_specially_abled/pages/player.dart';
import 'package:app_for_specially_abled/pages/signChat.dart';
import 'package:app_for_specially_abled/pages/voiceAdd.dart';
import 'package:app_for_specially_abled/pages/voiceAssign.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      routes: {
        "/" : (context) => Home(),
        "/signChat" : (context) => SignChat(),
        "/noiseMeter" : (context) => NoiseMeterClass(),
        "/audioNav" : (context) => AudioNav(),
        "/audioNavCustom" : (context) => AudioNavCustom(),
        "/learn" : (context) => Learn(),
        "/player" : (context) => Player(arguments: ModalRoute.of(context)!.settings.arguments as Map),
        "/voiceAssign" : (context) => VoiceAssign(),
        "/voiceAdd" : (context) => VoiceAdd(),

      },
      initialRoute: "/",
    );
  }
}
