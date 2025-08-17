import 'package:flutter/material.dart';
import 'package:pedometer_flutter/widgets/step_counter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedometer')),
      body: const StepCounter(),
    );
  }
}