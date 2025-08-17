import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';

  @override
  void initState() {
    super.initState();
    _initPedometer();
  }
  
  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() == PermissionStatus.granted;
    }
    return granted;
  }

  void _onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void _onError(error) {
    print('Step Count Error: $error');
  }

  Future<void> _initPedometer() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount).onError(_onError);
  }

    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Pedometer')),
        body: Center(child: Text('Steps taken: $_steps')),
      ),
    );
  }
}