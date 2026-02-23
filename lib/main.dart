import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

// Controller with reactive state
class CounterController extends GetxController {
  RxInt count = 0.obs;          // reactive count
  Rx<Color> bgColor = Rx<Color>(Colors.blueGrey.shade800);  // reactive background color

  final Random _random = Random();

  void increment() {
    count++;
    _randomizeColor();
  }

  void decrement() {
    count--;
    _randomizeColor();
  }

  void reset() {
    count.value = 0;
    bgColor.value = Colors.blueGrey.shade800;
  }

  void _randomizeColor() {
    bgColor.value = Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CounterController()); // register controller

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatelessWidget {
  final CounterController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {  // watch all .obs variables in controller
      final textColor = c.bgColor.value.computeLuminance() > 0.5 ? Colors.black : Colors.white;

      return Scaffold(
        backgroundColor: c.bgColor.value,

        appBar: AppBar(
          title: const Text('GetX Counter + Random Color'),
          centerTitle: true,
          foregroundColor: textColor,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Count',
                style: TextStyle(fontSize: 48, color: textColor.withOpacity(0.85)),
              ),
              const SizedBox(height: 16),
              Text(
                '${c.count}',
                style: TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: c.reset,
                child: const Text('Reset'),
              ),
            ],
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: c.decrement,
                backgroundColor: Colors.redAccent.shade700,
                child: const Icon(Icons.remove, size: 36),
              ),
              FloatingActionButton(
                onPressed: c.increment,
                backgroundColor: Colors.greenAccent.shade700,
                child: const Icon(Icons.add, size: 36),
              ),
            ],
          ),
        ),
      );
    });
  }
}