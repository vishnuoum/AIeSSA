import 'dart:async';

import 'package:app_for_specially_abled/services/chatBot.dart';
import 'package:app_for_specially_abled/services/locationService.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var url = "https://www.google.com/search?q=";

  TextEditingController webSearch = TextEditingController();
  FocusNode focus = FocusNode();

  int selectedIndex = 0;
  String command="";
  bool recording = false, _speechEnabled = false;
  late SharedPreferences sharedPreferences;
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech tts = TextToSpeech();
  ChatBot chatBot = ChatBot();
  bool locationStart = false;
  Location location = new Location();
  bool _serviceEnabled=false;
  late StreamSubscription<LocationData> locationStream;
  LocationService locationService = LocationService();
  Color? color = Colors.deepPurple[400];
  bool showFAB = true;

  @override
  void initState() {
    loadSharedPreference();
    _initSpeech();
    focus.addListener(onFocusChange);
    super.initState();
  }

  void onFocusChange() {
    setState(() {
      showFAB = !focus.hasFocus;
    });
  }

  void loadSharedPreference()async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
        onStatus: statusListener,
        onError: errorListener
    );
    setState(() {});
  }

  void initLocation()async{
    PermissionStatus _permissionGranted;


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.changeSettings(interval: 10000);

    location.enableBackgroundMode(enable: true);

    locationStream = location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      print(currentLocation);
      locationService.addLocation(lat: currentLocation.latitude.toString(), long: currentLocation.latitude.toString(), mail: sharedPreferences.getString("mail"));
    });

    print(location.getLocation());
    setState(() {
      locationStart = true;
    });




  }

  void disposeLocation(){
    locationStream.cancel();
    setState(() {
      locationStart = false;
    });
  }

  @override
  void dispose() {
    locationStream.cancel();
    super.dispose();
  }

  // Start listen
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult,cancelOnError: true,listenFor: Duration(minutes: 1));
  }

  // Stop listen
  void _stopListening() async {
    await _speechToText.stop();
  }

  // Speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      command = result.recognizedWords;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print('Received error status: $error');
  }

  void statusListener(String status) {
    print('Received listener status: $status, listening: ${_speechToText.isListening}');
    if((!_speechToText.isListening || status == "done") && recording){
      setState(() {
        recording = false;
      });
      print(command);
      var result = chatBot.chat(queryAsked: command.toLowerCase()).toString();
      print(result);
      tts.speak(result);
      if(result.contains("sign chat")){
        Navigator.pushNamed(context, "/signChat");
      }
      else if(result.contains("audio navigation")){
        Navigator.pushNamed(context, "/audioNavCustom");
      }
      else if(result.contains("learn")){
        Navigator.pushNamed(context, "/learn");
      }
      else if(result.contains("voice assign")){
        Navigator.pushNamed(context, "/voiceAssign");
      }
    }
  }

  Widget home(){
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height-65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/home_bg.png'),
                          fit: BoxFit.fill),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // CarouselSlider(
                              //   options:
                              //   CarouselOptions(autoPlay: true, viewportFraction: 1,aspectRatio: 720/305),
                              //   items: [
                              //     Text('Optimism is the faith that leads to achievement. Nothing can be done without hope and confidence'),
                              //     Text('success and happiness lies in you. Resolve to keep happy, and your joy and you shall form an invincible host against difficulties'),
                              //   ],
                              // ),
                              SizedBox(height: 20,),
                              Text(
                                'Welcome to AIeSSA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              SizedBox(height: 40,),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: TextField(
                                  focusNode: focus,
                                  controller: webSearch,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Web Search"
                                  ),
                                  onSubmitted: (query)async{
                                    if(await canLaunch("https://www.google.com/search?q=$query")){
                                      await launch("https://www.google.com/search?q=$query");
                                    }else {
                                      throw 'Could not launch $query';
                                    }
                                    webSearch.clear();
                                  },
                                ),
                              )
                              // Text(
                              //   'Sir',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold, fontSize: 20),
                              // ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(top: 30,right: 10,child: IconButton(onPressed: ()async{
                    await sharedPreferences.clear();
                    Navigator.pushReplacementNamed(context, "/login");
                  }, icon: Icon(Icons.logout),color: color,)),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.3,
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2,
                        children: <Widget>[
                          myCard(text: 'Sign Chat', icon: Icons.chat_bubble,route: "/signChat"),
                          myCard(
                              text: 'Audio Navigation', icon: Icons.assistant_navigation,route: "/audioNavCustom"),
                          myCard(text: 'Voice Assign', icon: Icons.mic,route: "/voiceAssign"),
                          myCard(text: 'Learn', icon: Icons.accessibility,route: "/learn"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myCard({required String text, required IconData icon, required String route}) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: color),
              SizedBox(height: 15),
              Text(text,textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }

  Widget homeScreen(){
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, "/signChat");
        }, child: Text("Sign Chat")),
        // ElevatedButton(onPressed: (){
        //   Navigator.pushNamed(context, "/audioNav");
        // }, child: Text("Audio Nav")),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, "/audioNavCustom");
        }, child: Text("Audio Navigation")),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, "/voiceAssign");
        }, child: Text("Voice Assign")),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, "/learn");
        }, child: Text("Learn")),
      ],
    );
  }


  Widget settingsScreen(){
    return Center(
      child: TextButton(
        child: Icon(locationStart?Icons.location_on:Icons.location_off,color: Colors.white,size: 25,),
        onPressed: (){
          if(locationStart){
            disposeLocation();
            setState(() {
              locationStart = false;
            });
          }
          else{
            initLocation();
            setState(() {
              locationStart = true;
            });
          }
        },
        style: TextButton.styleFrom(
            backgroundColor: locationStart?Colors.red:color,
            padding: EdgeInsets.all(30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)
            )
        ),
      ),
    );
  }

  void onTapItem(index){
    if(index==1)
      return;
    setState(() {
      selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {




    return Theme(
      data: ThemeData(
          accentColor: Colors.deepPurple[400]
      ),
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text("AIeSSA"),
        //   actions: [
        //     IconButton(onPressed: ()async{
        //       await sharedPreferences.clear();
        //       Navigator.pushReplacementNamed(context, "/login");
        //     }, icon: Icon(Icons.logout))
        //   ],
        // ),
        body: GestureDetector(
          onTap: (){
            focus.unfocus();
          },
          child: <Widget>[home(),SizedBox(),settingsScreen()][selectedIndex],
        ),
        floatingActionButton: !showFAB?SizedBox():FloatingActionButton(
          backgroundColor: recording?Colors.red:color,
          onPressed: !_speechEnabled?null:(){
            setState(() {
              recording = ! recording;
            });
            if(recording==true){
              _startListening();
            }
            else{
              _stopListening();
            }
          },
          child: Icon(Icons.mic),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Theme(
          data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent
          ),
          child: SizedBox(
            height: 65,
            child: BottomNavigationBar(
              selectedItemColor: color,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.transparent,),label: "",tooltip: ""),
                BottomNavigationBarItem(icon: Icon(Icons.location_on),label: "Live Tracking"),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              elevation: 5,
              onTap: onTapItem,
            ),
          ),
        ),
      ),
    );
  }
}
