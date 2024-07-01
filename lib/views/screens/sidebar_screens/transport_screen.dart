import 'package:flutter/material.dart';

class TransportScreen extends StatelessWidget {
  static const String routeName = '\TransportScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // alignment: ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Transport',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
          ),
        ),
      ),
    );
  }
}
