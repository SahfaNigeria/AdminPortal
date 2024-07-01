import 'package:flutter/material.dart';

class HospitalScreen extends StatelessWidget {
  static const String routeName = '\HospitalScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // alignment: ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Hospital',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
          ),
        ),
      ),
    );
  }
}
