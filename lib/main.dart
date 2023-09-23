import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensor_app/generated_images.dart';
import 'package:sensor_app/proximity.dart';
import 'package:sensor_app/snake_game.dart';
import 'package:sensor_app/square.dart';
import 'package:sensor_app/user_accelerometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Matrix4, radians;
import 'compass.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    const textstyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sensors Example'),
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            'Proximity Sensor',
                            style: textstyle,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Proximity()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Text(
                            'Accelerometer',
                            style: textstyle,
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const AccelerometerSquare()));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Text(
                              'Gyroscope',
                              style: textstyle,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const GyroscopeOrientationDetector()));
                            },
                          )
                        ],
                      ),
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Text(
                              'Magnetometer',
                              style: textstyle,
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const CompassWidget()));
                            },
                          )
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}

class RotationDetection extends StatelessWidget {
  const RotationDetection(
      {required this.rotationX,
      required this.rotationY,
      required this.rotationZ,
      super.key});
  final double rotationX;
  final double rotationY;
  final double rotationZ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Rotation Rates (degrees/second)',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text('X: ${rotationX.toStringAsFixed(2)}'),
          Text('Y: ${rotationY.toStringAsFixed(2)}'),
          Text('Z: ${rotationZ.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
