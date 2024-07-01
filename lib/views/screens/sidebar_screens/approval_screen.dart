import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  static const String routeName = '\ApprovalScreen';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // alignment: ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Approval',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 36),
          ),
        ),
      ),
    );
  }
}
