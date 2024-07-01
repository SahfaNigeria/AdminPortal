import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MidWifeDataWidget extends StatelessWidget {
  const MidWifeDataWidget({super.key});

  Widget midWifeData(int? flex, Widget widget) {
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
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _midwifeStream = FirebaseFirestore.instance
        .collection('Health Professionals')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _midwifeStream,
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
                  midWifeData(
                    1,
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.network(midwifeUserData['midWifeImage']),
                    ),
                  ),
                  midWifeData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['fullName'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  midWifeData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['countryValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  midWifeData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['stateValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  midWifeData(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(midwifeUserData['villageTown'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  midWifeData(
                    2,
                    Text(midwifeUserData['qualificationNumber'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  midWifeData(
                    2,
                    Text(midwifeUserData['position'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  midWifeData(
                    2,
                    Text(midwifeUserData['healthFacility'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  midWifeData(
                    2,
                    Text(midwifeUserData['phoneNumber'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  midWifeData(
                    2,
                    midwifeUserData['approved'] == false
                        ? TextButton(
                            onPressed: () async {
                              await _firestore
                                  .collection('Health Professionals')
                                  .doc(midwifeUserData['midWifeId'])
                                  .update({'approved': true});
                            },
                            child: Text(
                              'No',
                              style: TextStyle(fontSize: 12),
                            ))
                        : TextButton(
                            onPressed: () async {
                              await _firestore
                                  .collection('Health Professionals')
                                  .doc(midwifeUserData['midWifeId'])
                                  .update({'approved': false});
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(fontSize: 12),
                            )),
                  ),
                  midWifeData(
                      1,
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'More',
                            style: TextStyle(fontSize: 10),
                          ))),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
