import 'package:flutter/material.dart';

class TeamDescriptionScreen extends StatelessWidget {
  final String description;
  const TeamDescriptionScreen({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الوصف"),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: SelectableText(description,
            style: const TextStyle(
              height: 2.5,
                fontWeight: FontWeight.w500
            ),),
          ),
        ),
      ),
    );
  }
}
