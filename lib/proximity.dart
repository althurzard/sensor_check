import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class Proximity extends StatefulWidget {
  const Proximity({super.key});

  @override
  _ProximityState createState() => _ProximityState();
}

////////////////////////////////////////////////////////////////////////////////
class _ProximityState extends State<Proximity> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    _streamSubscription = ProximitySensor.events.listen(
      (int event) {
        setState(() {
          _isNear = (event > 0) ? true : false;
        });
      },
      onError: (e) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Sensor Not Found"),
                content: Text(
                    "It seems that your device doesn't support Proximity Sensor"),
              );
            });
      },
      cancelOnError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proximity Sensor'),
      ),
      body: Center(
        child: Text(
          'Is Proximity sensor near?\n$_isNear\n',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
