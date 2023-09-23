import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:sensor_app/generated_images.dart';
import 'package:sensor_app/isolate_utils.dart';

class CompassWidget extends StatefulWidget {
  const CompassWidget({super.key});

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget> {
  List<double>? _magnetometerValues;
  StreamSubscription? _accelSubscription;

  double _azimuth = 0.0; // To store compass orientation
  double _calculateAzimuth(double x, double y) {
    double radians = -1 * atan2(y, x);
    double degrees = radians * (180 / pi);
    return (degrees + 360) % 360;
  }

  @override
  void dispose() {
    super.dispose();
    _accelSubscription?.cancel();
  }

  Future<void> initSensors() async {
    try {
      bool accelerometerAvailable =
          await SensorManager().isSensorAvailable(Sensors.MAGNETIC_FIELD);
      if (accelerometerAvailable) {
        final stream = await SensorManager().sensorUpdates(
          sensorId: Sensors.MAGNETIC_FIELD,
          interval: Sensors.SENSOR_DELAY_GAME,
        );
        _accelSubscription = stream.listen((sensorEvent) {
          setState(() {
            setState(() {
              _magnetometerValues = sensorEvent.data;
              _azimuth =
                  _calculateAzimuth(sensorEvent.data[0], sensorEvent.data[1]);
            });
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
                "It seems that your device doesn't support Magnetometer Sensor"),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    initSensors();
    // _streamSubscriptions.add(
    //   magnetometerEvents.listen(
    //     (MagnetometerEvent event) {
    //       setState(() {
    //         _magnetometerValues = <double>[event.x, event.y, event.z];
    //         _azimuth = _calculateAzimuth(event.x, event.y);
    //       });
    //     },
    //     onError: (e) {
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return const AlertDialog(
    //               title: Text("Sensor Not Found"),
    //               content: Text(
    //                   "It seems that your device doesn't support Magnetometer Sensor"),
    //             );
    //           });
    //     },
    //     cancelOnError: true,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Magnetometer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    'Magnetometer: X:${magnetometer?[0]}, Y:${magnetometer?[1]}, Z:${magnetometer?[2]} '),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(200, 200), // Adjust the size as needed
                    painter: CompassPainter(),
                  ),
                ),
                Transform.rotate(
                  angle: ((_azimuth ?? 0) * pi) / 180,
                  child: Image.asset(
                    Img.compassNeedle.path,
                    width: 150,
                    height: 150,
                  ), // Replace with your compass needle image
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    // Draw the circle
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Draw cardinal directions (N, E, S, W)
    final textPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final textStyle = TextStyle(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

    final directions = ['N', 'E', 'S', 'W'];
    final angle = 2 * pi / directions.length;

    for (var i = 0; i < directions.length; i++) {
      final textSpan = TextSpan(
        text: directions[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: radius);
      final x = centerX - textPainter.width / 2 + radius * cos(i * angle);
      final y = centerY - textPainter.height / 2 + radius * sin(i * angle);
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
