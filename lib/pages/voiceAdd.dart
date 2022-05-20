import 'dart:io';

import 'package:app_for_specially_abled/services/voiceService.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceAdd extends StatefulWidget {
  const VoiceAdd({Key? key}) : super(key: key);

  @override
  State<VoiceAdd> createState() => _VoiceAddState();
}

class _VoiceAddState extends State<VoiceAdd> {

  TextEditingController label=TextEditingController();
  var arg;
  bool recorded = false,recording = false;
  String path = "",tempPath="";
  final record = Record();

  VoiceService voiceService = VoiceService();

  @override
  void initState() {
    initPath();
    super.initState();
  }

  void initPath()async{
    Directory tempDir = await getTemporaryDirectory();
    tempPath = tempDir.path;
  }

  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.blue),),),
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
    arg = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.blue
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Align(child: Text("Add Voice",style: TextStyle(color: Colors.blue,fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
          SizedBox(height: 40,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]
            ),
            child: TextField(
              controller: label,
              focusNode: null,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Label'
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recorded?Text("Recording Done"):SizedBox(),
              IconButton(onPressed: ()async{
                if (await record.hasPermission() && !recording) {
                  recorded = false;
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
                  recorded = true;
                }
                setState(() {
                  recording = !recording;
                });
              }, icon: Icon(Icons.mic,color: recording?Colors.red:Colors.blue,),),
            ],
          ),
          SizedBox(height: 15,),
          TextButton(onPressed: ()async{
            FocusScope.of(context).unfocus();
            if(label.text.length!=0&&recorded) {
              showLoading(context);
              var result = await voiceService.uploadAudio(
                  label: label.text, path: "$tempPath/recording.wav",mail:arg["mail"]);
              Navigator.pop(context);
              if(result=="done"){
                print("done");
                alertDialog("Uploaded successfully");
                label.clear();
                setState(() {
                  recorded=false;
                });
              }
              else{
                print("error");
                alertDialog("Something went wrong. Try again");
              }
            }
            else{
              alertDialog("Please complete the form");
            }
          }, child: Text("Add",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.blue,primary: Colors.white,padding: EdgeInsets.all(18)),),
        ],
      ),
    );
  }
}
