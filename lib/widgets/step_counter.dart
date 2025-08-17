import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounter extends StatefulWidget {
  const StepCounter({super.key});

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
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

  void _onError(Object error) {
    setState(() {
      _steps = 'step count not available';
    });
  }

  Future<void> _initPedometer() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      setState(() {
        _steps = 'Permission denied';
      });
      return;
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount, onError: _onError);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Steps taken: $_steps',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}