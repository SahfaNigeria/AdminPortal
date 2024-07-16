import 'package:flutter/material.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/widget/chw_info_widget.dart';

class CWHScreen extends StatelessWidget {
  static const String routeName = '\CWHScreen';

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
            // alignment: ,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Community Health Workers',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                )),
          ),
          Row(children: [
            _rowHeader('Pics', 1),
            _rowHeader('Name', 2),
            _rowHeader('Country', 2),
            _rowHeader('State', 2),
            _rowHeader('Village', 2),
            _rowHeader('Reg Number', 2),
            _rowHeader('Role', 2),
            _rowHeader('Hospital', 2),
            _rowHeader('Phone', 2),
            _rowHeader('Approve', 2),
            _rowHeader('More', 1),
          ]),
          ChwDataWidget()
        ],
      ),
    );
  }
}
