import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChwDataWidget extends StatelessWidget {
  const ChwDataWidget({super.key});

  Widget chwUserDataWidget(int? flex, Widget widget) {
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
    final Stream<QuerySnapshot> _chwStream = FirebaseFirestore.instance
        .collection('Community Health Workers')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _chwStream,
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
            final chwUserData = snapshot.data!.docs[index];
            return Container(
              child: Row(
                children: [
                  chwUserDataWidget(
                    1,
                    Container(
                      width: 40,
                      height: 40,
                      // child: Image.network(chwUserData['']),
                    ),
                  ),
                  chwUserDataWidget(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(chwUserData['fullName'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  chwUserDataWidget(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(chwUserData['countryValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  chwUserDataWidget(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(chwUserData['stateValue'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  chwUserDataWidget(
                    2,
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(chwUserData['villageTown'],
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  chwUserDataWidget(
                    2,
                    Text(chwUserData['qualificationNumber'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  chwUserDataWidget(
                    2,
                    Text(chwUserData['position'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  chwUserDataWidget(
                    2,
                    Text(chwUserData['healthFacility'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  chwUserDataWidget(
                    2,
                    Text(chwUserData['phoneNumber'],
                        style: TextStyle(fontSize: 12)),
                  ),
                  chwUserDataWidget(
                    2,
                    chwUserData['approved'] == false
                        ? TextButton(
                            onPressed: () async {
                              await _firestore
                                  .collection('Community Health Workers')
                                  .doc(chwUserData['cwhId'])
                                  .update({'approved': true});
                            },
                            child: Text(
                              'No',
                              style: TextStyle(fontSize: 12),
                            ))
                        : TextButton(
                            onPressed: () async {
                              await _firestore
                                  .collection('Community Health Workers')
                                  .doc(chwUserData['cwhId'])
                                  .update({'approved': false});
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(fontSize: 12),
                            )),
                  ),
                  chwUserDataWidget(
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
