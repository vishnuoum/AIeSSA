import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final Map arguments;
  const Player({Key? key,required this.arguments}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {

  late VideoPlayerController _controller;
  bool init = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        widget.arguments["path"])
      ..initialize().then((_) {
        setState(() {
          init = true;
        });
      });
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(65,64,65,1),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: !init?Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.deepPurple[400])
        ),
      ):Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: ElevatedButton(child: Icon(Icons.replay),onPressed: (){
              _controller.play();
            },style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),),
          ),
          Positioned(top: 120,left: 50,child: Text(widget.arguments["letter"].toUpperCase(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 45),)),
          //FURTHER IMPLEMENTATION
        ],
      ),
    );
  }
}
