import 'package:flutter/material.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/widget/health_facilities_widget.dart';

class HospitalScreen extends StatelessWidget {
  static const String routeName = '\HospitalScreen';

  @override
  Widget build(BuildContext context) {
    Widget _rowHeader(
      String text,
      int flex,
    ) {
      return Expanded(
        flex: flex,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              color: Colors.blue),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Health Facilities',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
          ),
          Row(children: [
            _rowHeader('Name', 2),
            _rowHeader('Email', 2),
            _rowHeader('Adress', 2),
            _rowHeader('Level', 1),
            _rowHeader('Country', 2),
            _rowHeader('Services', 3),
            _rowHeader('Action', 1),
          ]),
          HealthFacilityDataWidget(),
        ],
      ),
    );
  }
}
