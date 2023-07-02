import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            alignment: Alignment.topRight,
            onPressed: () => Get.back(),
          ),
          title: const Text('Setting'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Setting Page'),
        ),
      );
}
