import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  static const String routeName = '\FeedbackScreen';
  final Stream<QuerySnapshot> feedbackStream =
      FirebaseFirestore.instance.collection('user_feedback').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: feedbackStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error loading feedback");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var feedbackData = snapshot.data!.docs[index];
            return ListTile(
              title: Text(feedbackData['feedbackContent']),
              subtitle: Text(
                  "${feedbackData['userName']} (${feedbackData['userRole']})"),
              trailing: Text(feedbackData['feedbackType']),
            );
          },
        );
      },
    );
  }
}
