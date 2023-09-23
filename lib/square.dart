import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

class AccelerometerSquare extends StatefulWidget {
  const AccelerometerSquare({super.key});

  @override
  _AccelerometerSquareState createState() => _AccelerometerSquareState();
}

class _AccelerometerSquareState extends State<AccelerometerSquare> {
  double _smallSquareX = 0.0;
  double _smallSquareY = 0.0;
  double _smallSquareSize = 50.0;
  double _accelX = 0.0;
  double _accelY = 0.0;
  double _accelZ = 0.0;
  StreamSubscription? _accelSubscription;
  @override
  void initState() {
    super.initState();
    initSensors();
    // Listen to accelerometer sensor events
    // accelerometerEvents.listen(
    //   (AccelerometerEvent event) {
    //     i++;
    //     if (mounted) {
    //       setState(() {
    //         _accelX = event.x;
    //         _accelY = event.y;
    //         _accelZ = event.z;
    //         _moveSmallSquare();
    //       });
    //     }
    //   },
    //   onError: (e) {
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return const AlertDialog(
    //             title: Text("Sensor Not Found"),
    //             content: Text(
    //                 "It seems that your device doesn't support Gyroscope Sensor"),
    //           );
    //         });
    //   },
    //   cancelOnError: true,
    // );
  }

  Future<void> initSensors() async {
    try {
      bool accelerometerAvailable =
          await SensorManager().isSensorAvailable(Sensors.ACCELEROMETER);
      if (accelerometerAvailable) {
        final stream = await SensorManager().sensorUpdates(
          sensorId: Sensors.ACCELEROMETER,
          interval: Sensors.SENSOR_DELAY_GAME,
        );
        _accelSubscription = stream.listen((sensorEvent) {
          setState(() {
            _accelX = sensorEvent.data[0];
            _accelY = sensorEvent.data[1];
            _accelZ = sensorEvent.data[2];
            _moveSmallSquare();
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
                "It seems that your device doesn't support Acceleromete Sensor"),
          );
        });
  }

  void _moveSmallSquare() {
    // Update the position of the small square based on accelerometer data
    const double accelerationScale = 1.5;
    const double boundaryMargin = 10.0;

    _smallSquareX += _accelX * accelerationScale;
    _smallSquareY -=
        _accelY * accelerationScale; // Invert Y-axis for UI coordinates

    // Keep the small square within the boundaries of the larger square
    if (_smallSquareX < boundaryMargin) {
      _smallSquareX = boundaryMargin;
    }
    if (_smallSquareY < boundaryMargin) {
      _smallSquareY = boundaryMargin;
    }
    if (_smallSquareX > 300.0 - _smallSquareSize - boundaryMargin) {
      _smallSquareX = 300.0 - _smallSquareSize - boundaryMargin;
    }
    if (_smallSquareY > 300.0 - _smallSquareSize - boundaryMargin) {
      _smallSquareY = 300.0 - _smallSquareSize - boundaryMargin;
    }
  }

  @override
  void dispose() {
    // Stop listening to sensor events when the widget is disposed
    _accelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accelerometer'),
        ),
        body: Column(
          children: [
            Text(
              'Accelerometer: X:${_accelX.toStringAsFixed(1)}, Y:${_accelY.toStringAsFixed(1)}, Z:${_accelZ.toStringAsFixed(1)}',
            ),
            Center(
              child: Container(
                width: 300.0,
                height: 300.0,
                color: Colors.lightBlue,
                child: Stack(
                  children: [
                    Positioned(
                      left: _smallSquareX,
                      top: _smallSquareY,
                      child: Container(
                        width: _smallSquareSize,
                        height: _smallSquareSize,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
