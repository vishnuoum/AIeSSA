import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Swaram"),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, "/signChat");
          }, child: Text("Sign Chat")),
          ElevatedButton(onPressed: (){
            Navigator.pushNamed(context, "/audioNav");
          }, child: Text("Noise Meter")),
          ElevatedButton(onPressed: (){}, child: Text("Voice Assign")),
          ElevatedButton(onPressed: (){}, child: Text("Learn")),
        ],
      )
    );
  }
}
