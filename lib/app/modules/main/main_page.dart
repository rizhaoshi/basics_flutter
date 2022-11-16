import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MainPage'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'MainPage',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}