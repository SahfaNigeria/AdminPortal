import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HealthFacilityDataWidget extends StatelessWidget {
  const HealthFacilityDataWidget({super.key});

  Widget FacilityData(int? flex, Widget widget) {
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
    final Stream<QuerySnapshot> _facilityStream = FirebaseFirestore.instance
        .collection('health_facilities')
        .snapshots(); // You can replace 'HealthFacilities' later
    return StreamBuilder<QuerySnapshot>(
      stream: _facilityStream,
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
            final facilityData = snapshot.data!.docs[index];
            return Container(
              child: Row(
                children: [
                  FacilityData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(facilityData['name'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  FacilityData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FacilityData(
                        2,
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                              facilityData['contact']['email'].toString(),
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  ),
                  FacilityData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                          facilityData['location']['address'].toString(),
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  FacilityData(
                    1,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(facilityData['level'].toString(),
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  FacilityData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                          facilityData['location']['country'].toString(),
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  FacilityData(
                    3,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                          facilityData['services']?.toString() ??
                              'No services available',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  FacilityData(
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
