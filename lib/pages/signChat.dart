import 'package:app_for_specially_abled/services/uploadVideo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

class SignChat extends StatefulWidget {
  const SignChat({Key? key}) : super(key: key);

  @override
  State<SignChat> createState() => _SignChatState();
}

class _SignChatState extends State<SignChat> {

  List<Map> chat = [];

  SpeechToText _speechToText = SpeechToText();
  bool listening = false, chatting = false, _speechEnabled = false;
  String words="";
  UploadVideo uploadVideo = UploadVideo();

  final ImagePicker _picker = ImagePicker();


  TextToSpeech tts = TextToSpeech();

  Color? chatColor = Colors.blue[100],buttonColor = Colors.blue,chatBoxColor = Colors.blue[100];
  static double iconSize = 30, splashRadius = 70;
  TextEditingController chatController = TextEditingController(text: "");

  @override
  void initState() {
    _initSpeech();
    super.initState();
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

  // Init speech engine
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
    words = "";
  }

  // Stop listen
  void _stopListening() async {
    await _speechToText.stop();
    if(words.length!=0)
      setState(() {
        chat.add({"person":"you","content":words});
      });
  }

  // Speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    print(result.recognizedWords);
    setState(() {
      words = "${result.recognizedWords}";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print('Received error status: $error');
  }

  void statusListener(String status) {
    print(status);
    print(listening);
    print('Received listener status: $status, listening: ${_speechToText.isListening}');
    if((!_speechToText.isListening || status == "done") && listening){
      setState(() {
        listening = false;
      });
      if(words.length!=0)
        setState(() {
          chat.add({"person":"you","content":words});
        });
    }
  }



  Widget bottomNav(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Material(
          child: InkWell(
            radius: 50,
            borderRadius: BorderRadius.circular(splashRadius),
            onTap: () async {
              final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
              showLoading(context);
              print(video!.path);
              var result = await uploadVideo.upload(path: video.path);
              print(result);
              if(result=="error"){
                alertDialog("Something went wrong. Try again");
                return;
              }
              Navigator.pop(context);
              if(result["status"]=="done" && result["sentence"].length!=0) {
                setState(() {
                  chat.add({"person": "other", "content": result["sentence"]});
                });
              }
              else{
                alertDialog("Sorry.... No action detected");
                return;
              }
            },
            onLongPress: () {
              tts.speak("Convert sign to text");
            },
            child: Ink(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.accessibility,color: buttonColor,size: iconSize,),
            ),
          ),
        ),
        Material(
          child: InkWell(
            radius: 50,
            borderRadius: BorderRadius.circular(splashRadius),
            onTap: _speechEnabled?() {
              print("tapped");
              setState(() {
                listening = true;
                _startListening();
              });
            }:null,
            onLongPress: () {
              tts.speak("Convert speech to text");
            },
            child: Ink(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.mic,color: buttonColor,size: iconSize,),
            ),
          ),
        ),
        Material(
          child: InkWell(
            radius: 50,
            borderRadius: BorderRadius.circular(splashRadius),
            onTap: () {
              print("tapped");
              setState(() {
                chatting = true;
              });
            },
            onLongPress: () {
              tts.speak("Type in your message");
            },
            child: Ink(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.chat,color: buttonColor,size: iconSize,),
            ),
          ),
        ),
      ],
    );
  }

  Widget audioNav(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Center(child: Text(words)),
            )
        ),
        Expanded(
          child: CircleAvatar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            child: IconButton(
              icon: Icon(Icons.record_voice_over),
              onPressed: (){
                setState(() {
                  listening = false;
                });
                _stopListening();
              },
            ),
          ),
        )
      ],
    );
  }

  Widget chatNav(){
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              flex: 7,
              child: Container(
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: chatBoxColor,
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  autofocus: true,
                  controller: chatController,
                  scrollPhysics: BouncingScrollPhysics(),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Type in message",
                    border: InputBorder.none,
                  ),
                  onChanged: (val){
                    setState(() {});
                  },
                ),
              )
          ),
          Expanded(
            child: Tooltip(
              message: chatController.text.length!=0?"Message":"Close editor",
              verticalOffset: 0,
              child: IconButton(
                color: buttonColor,
                splashRadius: 25,
                icon: Icon(chatController.text.length!=0?Icons.send:Icons.close),
                onPressed: chatController.text.length!=0?(){
                  setState(() {
                    chat.add({"person":"you","content":chatController.text});
                  });
                  chatController.text="";
                }:(){
                  setState(() {
                    chatting = false;
                  });
                  chatController.clear();
                },
              ),
            ),
          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Chat'),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: ListView.builder(
                  reverse: true,
                  // controller: scrollController,
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  itemCount: chat.length,
                  itemBuilder: (context,index){
                    index=chat.length - 1 - index;
                    return GestureDetector(
                      onDoubleTap: (){
                        Navigator.pushNamed(context, "/textToSign",arguments: {"sentence":chat[index]["content"]});
                      },
                      onLongPress: (){
                        tts.speak(chat[index]["content"]);
                      },
                      child: Align(
                        alignment: chat[index]["person"]!="you"?Alignment.centerLeft:Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 12),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: chatColor,
                          ),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width*0.65
                          ),
                          child: Padding(padding: chat[index]["person"]=="you"?EdgeInsets.only(right: 5):EdgeInsets.only(left: 5),child: Text(chat[index]["content"],style: TextStyle(fontSize: 16),),),
                        ),
                      ),
                    );
                  },
                )
            ),
            Container(
              constraints: BoxConstraints(
                  maxHeight: 100,
                  minHeight: 65
              ),
              child: listening?audioNav():chatting?chatNav():bottomNav(),
            )
          ],
        ),
      ),
    );
  }
}
