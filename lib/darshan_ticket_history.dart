import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DarshanTicketHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Darshan Ticket History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Darshans').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return Center(
              child: Text('No darshan tickets booked yet.'),
            );
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
              return DarshanCard(
                aadharNumber: data['aadharNumber'],
                age: data['age'],
                firstName: data['firstName'],
                lastName: data['lastName'],
                numberOfPeople: data['numberOfPeople'],
                templeName: data['templeName'],
              );
            },
          );
        },
      ),
    );
  }
}

class DarshanCard extends StatelessWidget {
  final String aadharNumber;
  final int age;
  final String firstName;
  final String lastName;
  final int numberOfPeople;
  final String templeName;

  const DarshanCard({
    required this.aadharNumber,
    required this.age,
    required this.firstName,
    required this.lastName,
    required this.numberOfPeople,
    required this.templeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aadhar Number: $aadharNumber',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'First Name: $firstName',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Last Name: $lastName',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Number of People: $numberOfPeople',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Temple Name: $templeName',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
