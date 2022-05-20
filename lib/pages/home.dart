import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedIndex = 0;

  bool recording = false;

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
        }, child: Text("Audio Nav Custom")),
        ElevatedButton(onPressed: (){}, child: Text("Voice")),
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
        onPressed: (){
          setState(() {
            recording = ! recording;
          });
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
