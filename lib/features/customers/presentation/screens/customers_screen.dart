import 'package:flutter/material.dart';

import '../widgets/custom_drawer.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("العملاء"),
      ),

      drawer: const CustomDrawer(),
    );
  }
}
