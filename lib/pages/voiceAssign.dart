import 'dart:io';

import 'package:app_for_specially_abled/services/voiceService.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_to_speech/text_to_speech.dart';

class VoiceAssign extends StatefulWidget {
  const VoiceAssign({Key? key}) : super(key: key);

  @override
  State<VoiceAssign> createState() => _VoiceAssignState();
}

class _VoiceAssignState extends State<VoiceAssign> {

  VoiceService voiceService = VoiceService();
  TextToSpeech tts = TextToSpeech();
  late SharedPreferences sharedPreferences;
  dynamic result=[];
  bool loading = true;
  String txt = "Loading";
  bool recording = false;
  String path = "",tempPath="";
  final record = Record();


  @override
  void initState() {
    initSharedPreferences();
    initPath();
    super.initState();
  }

  void initSharedPreferences()async{
    sharedPreferences = await SharedPreferences.getInstance();
    init();
  }

  void initPath()async{
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;
  }

  void init()async{
    var res = await voiceService.getUserLabels(mail: sharedPreferences.getString("mail"));
    print(res);
    if(res == "error"){
      setState(() {
        txt = "Something went wrong";
      });
      Future.delayed(Duration(seconds: 5),(){
        init();
      });
    }
    else{
      setState(() {
        result = res;
        loading = false;
        txt = "Loading";
      });
    }
  }

  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.deepPurple[400]),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return WillPopScope(onWillPop: ()async => false,child: alert);
    });
  }

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text("Voice Assign"),
        actions: [
          TextButton.icon(onPressed: (){
            Navigator.pushNamed(context, "/voiceAdd",arguments: {'mail':sharedPreferences.getString("mail")});
          }, icon: Icon(Icons.add,color: Colors.white,), label: Text("Add audio",style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: loading?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth:5,),),
            SizedBox(height: 10,),
            Text(txt)
          ],
        ),
      ):result.length==0?Center(
        child: Text("No audios to show",style: TextStyle(color: Colors.grey,fontSize: 20),),
      ):
      GridView.builder(// to disable GridView's scrolling
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10
          ),
          itemCount: result.length,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple[400]),
              onPressed: (){
                tts.speak(result[index]["label"]);
              },
              child: Center(child: Text(result[index]["label"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,)),
            );
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !loading&&result.length>=1?FloatingActionButton(
        backgroundColor: recording?Colors.red:Colors.deepPurple[400],
        onPressed: ()async{
          if (await record.hasPermission() && !recording) {
            // Start recording
            await record.start(
              path: "$tempPath/recording.wav",
              encoder: AudioEncoder.AAC, // by default
              bitRate: 128000, // by default
              samplingRate: 44100, // by default
            );
          }
          else if(recording){
            await record.stop();
            showLoading(context);
            var res = await voiceService.classifyAudio(path: "$tempPath/recording.wav", mail: sharedPreferences.getString("mail"));
            Navigator.pop(context);
            if(res=="error"){
              alertDialog("Something went wrong. Try again");
            }
            else{
              tts.speak(res);
            }
          }
          setState(() {
            recording = !recording;
          });
        },
        child: Icon(Icons.mic),
      ):Container(),
    );
  }
}
