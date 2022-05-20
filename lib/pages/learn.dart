import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Learn extends StatefulWidget {
  const Learn({Key? key}) : super(key: key);

  @override
  State<Learn> createState() => _LearnState();
}

class _LearnState extends State<Learn> {

  final ImagePicker _picker = ImagePicker();
  var res;

  Color textColor = Colors.blue;

  List<String> alpha = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];

  @override
  void initState() {
    loadModel();
    super.initState();
  }

  void loadModel()async{
    res = await Tflite.loadModel(
        model: "assets/models/handModel.tflite",
        labels: "assets/models/handModelLabels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print(res);
  }

  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Result'),
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

  Future<void> scan(BuildContext cont) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Please select an option."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Open Camera'),
              onPressed: () async{
                Navigator.of(context).pop();
                print('Camera');
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  // if(recognitions![0]["confidence"]<0.85){
                  //   alertDialog("Could not find hand");
                  //   return;
                  // }
                  alertDialog(recognitions.toString());
                }
                catch(e){
                  print("Exception $e");
                }
              },
            ),
            TextButton(
              child: Text('Open Gallery'),
              onPressed: ()async {
                Navigator.of(context).pop();
                print('Gallery');
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                try {
                  print(image!.path);
                  var recognitions = await Tflite.runModelOnImage(
                    path: image.path,   // required
                  );
                  print(recognitions);
                  // if(recognitions![0]["confidence"]<0.85){
                  //   alertDialog("Could not find hand");
                  //   return;
                  // }
                  alertDialog(recognitions.toString());
                }
                catch(e){
                  print("Exception $e");
                }
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
        title: Text("Learn"),
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            SizedBox(height: 20,),
            Image.asset("assets/signs/signs.gif",height: 150,),
            SizedBox(height: 20,),
            Text("Learn Alphabets",style: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 25),),
            SizedBox(height: 20,),
            GridView.builder(// to disable GridView's scrolling
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                itemCount: 26,
                itemBuilder: (BuildContext context, int index) {
                  return ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, "/player",arguments: {'path':"assets/signs/${alpha[index]}.mp4","letter":alpha[index]});
                    },
                    child: Center(child: Text(alpha[index].toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
