import 'package:app_for_specially_abled/services/chatBot.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;
  String command="";
  bool recording = false, _speechEnabled = false;
  late SharedPreferences sharedPreferences;
  SpeechToText _speechToText = SpeechToText();
  TextToSpeech tts = TextToSpeech();
  ChatBot chatBot = ChatBot();

  @override
  void initState() {
    loadSharedPreference();
    _initSpeech();
    super.initState();
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
      // else if(result.contains("voice assign")){
      //   Navigator.pushNamed(context, "/voiceAssign");
      // }
    }
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
    return ListView(
      children: [
        ListTile(title: Text("Settings"),onTap: (){},)
      ],
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


    Color navbarSelect = Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text("AIeSSA"),
      ),
      body: <Widget>[homeScreen(),SizedBox(),settingsScreen()][selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: recording?Colors.red:Colors.blue,
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
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.transparent,),label: "",tooltip: ""),
            BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          elevation: 5,
          onTap: onTapItem,
        ),
      ),
    );
  }
}
