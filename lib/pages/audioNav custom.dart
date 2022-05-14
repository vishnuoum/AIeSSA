import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_audio/tflite_audio.dart';

class AudioNavCustom extends StatefulWidget {
  const AudioNavCustom({Key? key}) : super(key: key);

  @override
  State<AudioNavCustom> createState() => _AudioNavCustomState();
}

class _AudioNavCustomState extends State<AudioNavCustom> {
  final isRecording = ValueNotifier<bool>(false);
  Stream<Map<dynamic, dynamic>>? result;

  ///example values for google's teachable machine model
  final String model = 'assets/models/audioModel.tflite';
  final String label = 'assets/models/labels.txt';
  final String inputType = 'rawAudio';
  final String audioDirectory = 'assets/sample_audio_44k_mono.wav';
  final int sampleRate = 44100;
  final int bufferSize = 11016;

  ///Optional parameters you can adjust to modify your input and output
  final bool outputRawScores = false;
  final int numOfInferences = 500;
  final int numThreads = 1;
  final bool isAsset = true;

  ///Adjust the values below when tuning model detection.
  final double detectionThreshold = 0.3;
  final int averageWindowDuration = 1000;
  final int minimumTimeBetweenSamples = 30;
  final int suppressionTime = 1500;

  Color textColor = Colors.blue;
  double fontSize = 25;

  @override
  void initState() {
    super.initState();
    TfliteAudio.loadModel(
      inputType: inputType,
      model: model,
      label: label,
    );

    // mfcc parameters
    TfliteAudio.setSpectrogramParameters(nMFCC: 40, hopLength: 16384);
  }

  void getResult() {

    ///example for recording recognition
    result = TfliteAudio.startAudioRecognition(
      sampleRate: sampleRate,
      bufferSize: bufferSize,
      numOfInferences: numOfInferences,
    );

    ///Below returns a map of values. The keys are:
    ///"recognitionResult", "hasPermission", "inferenceTime"
    result
        ?.listen((event) =>
        log("Recognition Result: " + event["recognitionResult"].toString()))
        .onDone(() => isRecording.value = false);
  }

  ///fetches the labels from the text file in assets
  Future<List<String>> fetchLabelList() async {
    List<String> _labelList = [];
    await rootBundle.loadString(this.label).then((q) {
      for (String i in const LineSplitter().convert(q)) {
        _labelList.add(i);
      }
    });
    return _labelList;
  }

  ///handles null exception if snapshot is null.
  String showResult(AsyncSnapshot snapshot, String key) =>
      snapshot.hasData ? snapshot.data[key].toString() : '0 ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Audio Nav'),
            ),

            ///Streambuilder for inference results
            body: StreamBuilder<Map<dynamic, dynamic>>(
                stream: result,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<dynamic, dynamic>> inferenceSnapshot) {
                  ///futurebuilder for getting the label list
                  return FutureBuilder(
                      future: fetchLabelList(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> labelSnapshot) {
                        switch (inferenceSnapshot.connectionState) {
                          case ConnectionState.none:
                          //Loads the asset file.
                            if (labelSnapshot.hasData) {
                              return labelListWidget(labelSnapshot.data);
                            } else {
                              return Center(child: const CircularProgressIndicator());
                            }
                          case ConnectionState.waiting:

                          ///Widets will let the user know that its loading when waiting for results
                            return Stack(children: <Widget>[
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: inferenceTimeWidget('calculating..')),
                              labelListWidget(labelSnapshot.data),
                            ]);

                        ///Widgets will display the final results.
                          default:
                            return Stack(children: <Widget>[
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: inferenceTimeWidget(showResult(
                                      inferenceSnapshot, 'inferenceTime') +
                                      'ms')),
                              labelListWidget(
                                  labelSnapshot.data,
                                  showResult(
                                      inferenceSnapshot, 'recognitionResult'))
                            ]);
                        }
                      });
                }),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ValueListenableBuilder(
                valueListenable: isRecording,
                builder: (context, value, widget) {
                  if (value == false) {
                    return FloatingActionButton(
                      onPressed: () {
                        isRecording.value = true;
                        setState(() {
                          getResult();
                        });
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.mic),
                    );
                  } else {
                    return FloatingActionButton(
                      onPressed: () {
                        log('Audio Recognition Stopped');
                        TfliteAudio.stopAudioRecognition();
                      },
                      backgroundColor: Colors.red,
                      child: const Icon(Icons.adjust),
                    );
                  }
                }));
  }

  ///If snapshot data matches the label, it will change colour
  Widget labelListWidget(List<String>? labelList, [String? result]) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(result==null?"Initializing...":result.toString(),style: TextStyle(color: ["Car Horn","Dog Bark","Gunshot","Siren"].contains(result.toString())?Colors.red:textColor,fontSize: fontSize,fontWeight: FontWeight.bold),)]
            // labelList!.map((labels) {
            //   if (labels == result) {
            //     return Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child: Text(labels.toString(),
            //             textAlign: TextAlign.center,
            //             style: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 25,
            //               color: Colors.green,
            //             )));
            //   } else {
            //     return Padding(
            //         padding: const EdgeInsets.all(5.0),
            //         child: Text(labels.toString(),
            //             textAlign: TextAlign.center,
            //             style: const TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             )));
            //   }
            // }).toList()
        ));
  }

  ///If the future isn't completed, shows 'calculating'. Else shows inference time.
  Widget inferenceTimeWidget(String result) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(result,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            )));
  }
}
