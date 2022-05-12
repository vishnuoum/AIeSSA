import 'package:flutter/material.dart';
import 'package:text_to_speech/text_to_speech.dart';

class SignChat extends StatefulWidget {
  const SignChat({Key? key}) : super(key: key);

  @override
  State<SignChat> createState() => _SignChatState();
}

class _SignChatState extends State<SignChat> {

  List<Map> chat = [
    {"person":"you","content":"Hello"},
    {"person":"other","content":"Hello"},
  ];

  TextToSpeech tts = TextToSpeech();

  Color? chatColor = Colors.blue[100],buttonColor = Colors.blue;
  static double iconSize = 30, splashRadius = 70;
  
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
                flex: 20,
                child: ListView.builder(
                  reverse: true,
                  // controller: scrollController,
                  padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                  itemCount: chat.length,
                  itemBuilder: (context,index){
                    index=chat.length - 1 - index;
                    return Align(
                      alignment: chat[index]["person"]!="you"?Alignment.centerLeft:Alignment.centerRight,
                      child: Container(
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
                    );
                  },
                )
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    child: InkWell(
                      radius: 50,
                      borderRadius: BorderRadius.circular(splashRadius),
                      onTap: () {},
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
                      onTap: () {},
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
                      onTap: () {},
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
