import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
// import 'package:sensors_plus/sensors_plus.dart';

class GyroscopeOrientationDetector extends StatefulWidget {
  const GyroscopeOrientationDetector({super.key});

  @override
  _GyroscopeOrientationDetectorState createState() =>
      _GyroscopeOrientationDetectorState();
}

class _GyroscopeOrientationDetectorState
    extends State<GyroscopeOrientationDetector> {
  //late GyroscopeEvent gyroscopeData = GyroscopeEvent(0, 0, 0);
  late List<double> gyroscopeData = [0, 0, 0];
  static const double shakeThreshold = 10.0; // Adjust this threshold as needed
  int score = 0;
  StreamSubscription? _accelSubscription;
  @override
  void initState() {
    super.initState();
    initSensors();
    // Initialize the gyroscope sensor
    // _streamSubscriptions.add(
    //   gyroscopeEvents.listen(
    //     (GyroscopeEvent event) {
    //       setState(() {
    //         gyroscopeData = event;
    //         detectShake();
    //       });
    //     },
    //     onError: (e) {
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return const AlertDialog(
    //               title: Text("Sensor Not Found"),
    //               content: Text(
    //                   "It seems that your device doesn't support User Accelerometer Sensor"),
    //             );
    //           });
    //     },
    //     cancelOnError: true,
    //   ),
    // );
  }

  Future<void> initSensors() async {
    try {
      bool accelerometerAvailable =
          await SensorManager().isSensorAvailable(Sensors.GYROSCOPE);
      if (accelerometerAvailable) {
        final stream = await SensorManager().sensorUpdates(
          sensorId: Sensors.GYROSCOPE,
          interval: Sensors.SENSOR_DELAY_GAME,
        );
        _accelSubscription = stream.listen((sensorEvent) {
          setState(() {
            gyroscopeData = sensorEvent.data;
            detectShake();
          });
        });
      } else {
        showError();
      }
    } catch (e) {
      showError();
    }
  }

  void showError() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Sensor Not Found"),
            content: Text(
                "It seems that your device doesn't support Gyroscope Sensor"),
          );
        });
  }

  void detectShake() {
    if (gyroscopeData.isNotEmpty) {
      // Calculate the magnitude of angular velocity
      double magnitude = gyroscopeData[0].abs() +
          gyroscopeData[1].abs() +
          gyroscopeData[2].abs();

      // Check if the magnitude exceeds the shake threshold
      if (magnitude > shakeThreshold) {
        setState(() {
          // Increase the score when a shake is detected
          score++;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _accelSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Gyroscope'),
        ),
        body: Column(
          children: [
            Text(
              'Gyroscope: X:${gyroscopeData[0].toStringAsFixed(1)}, Y:${gyroscopeData[1].toStringAsFixed(1)}, Z:${gyroscopeData[2].toStringAsFixed(1)}',
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Shake the phone to score points!',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Score: $score',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
