import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '\DashboardScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // alignment: ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'DashBoard',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
          ),
        ),
      ),
    );
  }
}
