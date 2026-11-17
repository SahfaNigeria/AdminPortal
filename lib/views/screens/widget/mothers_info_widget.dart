import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MothersDataWidget extends StatelessWidget {
  const MothersDataWidget({super.key});

  Widget MothersData(int? flex, Widget widget) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: widget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _motherStream =
        FirebaseFirestore.instance.collection('New Mothers').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _motherStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final midwifeUserData = snapshot.data!.docs[index];
            return Container(
              child: Row(
                children: [
                  MothersData(
                    1,
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.network(midwifeUserData['profileImage']),
                    ),
                  ),
                  MothersData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['full name'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  MothersData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['villageTown'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  MothersData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['stateValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  MothersData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['countryValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  MothersData(
                    1,
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'More',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
