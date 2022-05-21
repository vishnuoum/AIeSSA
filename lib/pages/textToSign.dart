import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class TextToSign extends StatefulWidget {
  final Map arguments;
  const TextToSign({Key? key,required this.arguments}) : super(key: key);

  @override
  State<TextToSign> createState() => _TextToSignState();
}

class _TextToSignState extends State<TextToSign> {


  List words = [];
  bool loading = true;
  int index=0;
  dynamic controllerList = [];
  List<String> stopWords = ["am"];
  List<String> videoList = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k",
                            "l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","after","again","against","age","all","alone","also","and",
                            "ask","at","be","beautiful","before","best","better","busy","but","bye","can","cannot","change","college","come","computer",
                            "day","distance","do","do not","does not","engineer","fight","finish","from","glitter","go","god","gold","good","great",
                            "hand","hands","happy","hello","help","her","here","his","home","homepage","how","invent","it","keep","language","laugh",
                            "learn","me","more","my","name","next","not","now","of","on","our","out","pretty","right","sad","safe","see","self","sign",
                            "sing","so","sound","stay","study","talk","television","thank","thank you","that","they","this","those","time","to","type",
                            "us","walk","wash","way","we","welcome","what","when","where","which","who","whole","whose","why","will","with","without","words",
                            "work","world","wrong","you","your","yourself"];


  @override
  void initState() {
    initVideo();
    super.initState();
  }

  List convert(){
    print("initVideo");
    List words = widget.arguments["sentence"].split(" ");
    List toPlay = [];
    words.forEach((word) {
      print(word);
      word = word.trim().toLowerCase();
      if(!stopWords.contains(word)){
        if(!videoList.contains(word)){
          for(int i=0;i<word.length;i++){
            toPlay.add(word[i]);
          }
        }
        else{
          toPlay.add(word);
        }
      }
    });
    return toPlay;
  }

  void initVideo() async {
    print("initVideo");
    words = convert();
    print(words);
    for(int i=0;i<words.length;i++){
      print("controller ${words[i]}");
      VideoPlayerController _controller = VideoPlayerController.asset("assets/signs/${words[i]}.mp4");
      await _controller.initialize();
      if(i<words.length-1) {
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            _controller.pause();
            setState(() {
              index=i+1;
            });
            Future.delayed(Duration(seconds: 1),(){
              controllerList[i+1].play();
            });
            print(i+1);
          }
        });
      }
      controllerList.add(_controller);
    }
    setState(() {
      loading = false;
    });
    print(loading);
    controllerList[0].play();
    print(controllerList[0]);
  }

  @override
  void dispose() {
    controllerList.forEach((_controller){
      _controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(65,64,65,1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.blue
        ),
        elevation: 0,
      ),
      body: loading?Center(
        child: CircularProgressIndicator(),
      ):Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: controllerList[0].value.size.width,
                height: controllerList[0].value.size.height,
                child: VideoPlayer(controllerList[index]),
              ),
            ),
          ),
          Positioned(top: 120,left: 50,child: Text(words[index].toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 45),)),
          //FURTHER IMPLEMENTATION
        ],
      ),
    );
  }
}