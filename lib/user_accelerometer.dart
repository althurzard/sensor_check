import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class TiltGame extends StatefulWidget {
  const TiltGame({super.key});

  @override
  _TiltGameState createState() => _TiltGameState();
}

class _TiltGameState extends State<TiltGame> {
  List<double> _userAccelerometerValues = [0, 0, 0];
  double sensitivity = 0.2; // Adjust this sensitivity as needed
  double characterX = 0.0;
  double characterY = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize the user accelerometer sensor
    userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        if (mounted) {
          setState(() {
            _userAccelerometerValues = [event.x, event.y, event.z];
            moveCharacter();
          });
        }
      },
      onError: (e) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Sensor Not Found"),
              content: Text(
                  "It seems that your device doesn't support the Accelerometer Sensor"),
            );
          },
        );
      },
      cancelOnError: true,
    );
  }

  void moveCharacter() {
    // Check accelerometer values and move the character accordingly
    double deltaX = _userAccelerometerValues[0];
    double deltaY = _userAccelerometerValues[1];

    // Adjust sensitivity and character speed
    deltaX *= sensitivity;
    deltaY *= sensitivity;

    setState(() {
      characterX += deltaX;
      characterY += deltaY;

      // Limit character's movement within the screen boundaries
      if (characterX < 0) characterX = 0;
      if (characterX > 1) characterX = 1;
      if (characterY < 0) characterY = 0;
      if (characterY > 1) characterY = 1;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userAccelerometerEvents.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accelerometer'),
      ),
      body: Column(
        children: [
          Text(
            'User Accelerometer: X:${_userAccelerometerValues[0].toStringAsFixed(1)}, Y:${_userAccelerometerValues[1].toStringAsFixed(1)}, Z:${_userAccelerometerValues[2].toStringAsFixed(1)}',
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.blue,
              margin: EdgeInsets.only(
                left: characterX * 200,
                top: characterY * 200,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AccelerometerExample extends StatefulWidget {
  const AccelerometerExample({super.key});

  @override
  _AccelerometerExampleState createState() => _AccelerometerExampleState();
}

class _AccelerometerExampleState extends State<AccelerometerExample> {
  double accelerationX = 0.0;
  double accelerationY = 0.0;
  double accelerationZ = 0.0;
  String text = '';
  List<String> steps = [];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int stepCount = 0;
  bool isPeak = false;
  bool isDownward = false;
  bool isUpward = false;

  @override
  void initState() {
    super.initState();

    // Listen to accelerometer events
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          // Extract the acceleration values
          accelerationX = event.x;
          accelerationY = event.y;
          accelerationZ = event.z;
        });

        // Interpret the acceleration data
        interpretAcceleration(event);
        detectPeak(event);
      }
    }));
  }

  void interpretAcceleration(AccelerometerEvent event) {
    // Calculate the magnitude of acceleration
    double magnitude =
        event.x * event.x + event.y * event.y + event.z * event.z;

    // Check the direction of acceleration
    if (magnitude < 1.0) {
      text = "Device is still";
    } else {
      if (event.x > 0) {
        text = "Device is accelerating towards east";
      } else if (event.x < 0) {
        text = "Device is decelerating towards west";
      }

      if (event.y > 0) {
        text = "Device is accelerating towards north";
      } else if (event.y < 0) {
        text = "Device is decelerating towards south";
      }

      if (event.z > 0) {
        text = "Device is moving upward";
      } else if (event.z < 0) {
        text = "Device is moving downward";
      }
    }
  }

  void detectPeak(AccelerometerEvent event) {
    // Calculate the magnitude of acceleration
    double magnitude =
        event.x * event.x + event.y * event.y + event.z * event.z;

    // Define a threshold for peak detection (adjust as needed)
    double threshold = 10.0;

    // Check if the magnitude exceeds the threshold
    if (magnitude > threshold) {
      if (!isPeak) {
        // This is the start of a new peak (step)
        stepCount++;
        isPeak = true;
      }
    } else {
      // Reset the peak flag when acceleration falls below the threshold
      isPeak = false;
    }

    // You can update the step count here or use it as needed
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Accelerometer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Acceleration X: ${accelerationX.toStringAsFixed(2)} m/s²'),
            Text('Acceleration Y: ${accelerationY.toStringAsFixed(2)} m/s²'),
            Text('Acceleration Z: ${accelerationZ.toStringAsFixed(2)} m/s²'),
            Text(
              text,
            ),
            Text(
              'Step count: $stepCount',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
