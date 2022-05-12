import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NoiseMeterClass extends StatefulWidget {
  const NoiseMeterClass({Key? key}) : super(key: key);

  @override
  State<NoiseMeterClass> createState() => _NoiseMeterClassState();
}

class _NoiseMeterClassState extends State<NoiseMeterClass> {

  double maxDB=120,currentDb=0.0,max=0.0,min=0.0,alertDB=80.0;

  Color? dbColor = Colors.blue,valueColor = Colors.blue[300];

  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;

  @override
  void initState() {
    super.initState();
    _noiseMeter = new NoiseMeter();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    print(noiseReading.meanDecibel);
    setState(() {
      currentDb = noiseReading.meanDecibel;
      max = noiseReading.meanDecibel>max?noiseReading.meanDecibel:max;
      min = min==0.0?noiseReading.meanDecibel:noiseReading.meanDecibel<min?noiseReading.meanDecibel:min;
    });
    if(noiseReading.meanDecibel>alertDB){
      HapticFeedback.vibrate();
    }
  }

  void onError(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      currentDb = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Noise Meter"),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: CircularPercentIndicator(
                  radius: 100,
                  animation: true,
                  animateFromLastPercent: true,
                  percent: currentDb/maxDB,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(currentDb.toStringAsFixed(2),style: TextStyle(color: valueColor,fontSize: 35,fontWeight: FontWeight.bold),),
                      Text("DB",style: TextStyle(color: dbColor,fontSize: 20,fontWeight: FontWeight.bold),)
                    ],
                  )
                )
              ),
              flex: 25,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(max.toStringAsFixed(2),style: TextStyle(fontSize: 25,color: dbColor,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("MAX",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  SizedBox(width: 50,),
                  Column(
                    children: [
                      Text(min.toStringAsFixed(2),style: TextStyle(fontSize: 25,color: dbColor,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("MIN",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  )
                ],
              ),
              flex: 5,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mic),
        foregroundColor: Colors.white,
        backgroundColor: _isRecording?Colors.red:Colors.blue,
        onPressed: _isRecording?stop:start,
      ),
    );
  }
}
