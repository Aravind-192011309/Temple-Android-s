import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tms/temples.dart';
import 'package:tms/usersignin.dart';

import 'about.dart';
import 'adminlogin.dart';
import 'contact.dart';
import 'darshan_ticket_history.dart';
import 'main.dart';
import 'our_festivals.dart';
import 'profile.dart'; // Import the ProfilePage widget

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Temple Management System')),
            );
          },
          child: Text(title),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: const Color(0xFFF5F5DC), // Set the background color to beige
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Temple\n',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Management\n',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'System',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/temple1.png', // Add the path to your image file
                          fit: BoxFit.cover, // Adjust the fit as needed
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Offering Pujas to murtis of Ganesha, Muruga and Shiva, it was founded on the traditions of Saiva Siddhanta and known as the Palaniswami Sivan Temple. It quickly became a popular site for the ever-growing populace of newly arriving Hindus, some of whom personally knew of the Sage from Sri Lanka, YogaSwami, who initiated the American Guru. grow over the years, and on traditional festival days, the small temple could hardly accommodate the crowd of devotees. In 1988, to better facilitate the Hindu community, the temple was moved to a larger site in Concord, CA. The site was chosen due to availability and the fact that it had always been a place of worship. The Temple has brought the priest from all of India to oversee the daily rituals. The first few years have been most generally spent in maintaining the buildings and a dependable schedule of religious events.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Loading indicator
            } else {
              final bool isUserLoggedIn = snapshot.data != null;
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      'Temple Management System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Home'),
                    onTap: () {
                      // Navigate to the Home screen when Home is clicked
                    },
                  ),
                  ListTile(
                    title: Text('Our Festivals'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OurFestivalsPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Darshan Ticket History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DarshanTicketHistoryPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Temples'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TemplesPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('About'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Contact'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Forgot Password'),
                    onTap: () {
                      // Navigate to the ForgotPasswordPage when Forgot Password is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                      );
                    },
                  ),
                  if (isUserLoggedIn) // Show "Profile" if user is logged in
                    ListTile(
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                    ),
                  // ListTile(
                  //   title: Text('User Login'),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => RegistrationForm()),
                  //     );
                  //   },
                  // ),
                  // ListTile(
                  //   title: Text('Admin Login'),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  //     );
                  //   },
                  // ),
                  ListTile(
                    title: Text('Reviews'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReviewsPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('LOGOUT'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginOptionsPage()),
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('ReviewData').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<QueryDocumentSnapshot> reviewList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviewList.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> reviewData = reviewList[index].data() as Map<String, dynamic>;

              final String name = reviewData['Name'] ?? '';
              final String templeName = reviewData['TempleName'] ?? '';
              final String review = reviewData['ReviewMessage'] ?? '';
              final String rating = reviewData['ReviewScore'] ?? '';

              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reviewer: $name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Temple Name: $templeName',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Rating: $rating',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Review: $review',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the review form
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReviewFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ReviewFormPage extends StatefulWidget {
  @override
  _ReviewFormPageState createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final nameController = TextEditingController();
  final templeNameController = TextEditingController();
  final reviewController = TextEditingController();
  final ratingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: templeNameController,
              decoration: InputDecoration(labelText: 'Temple Name'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: ratingController,
              decoration: InputDecoration(labelText: 'Rating (1-5)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: reviewController,
              decoration: InputDecoration(labelText: 'Review Message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save review to Firestore
                FirebaseFirestore.instance.collection('ReviewData').add({
                  'Name': nameController.text,
                  'TempleName': templeNameController.text,
                  'ReviewMessage': reviewController.text,
                  'ReviewScore': ratingController.text,
                });
                // Clear text fields
                nameController.clear();
                templeNameController.clear();
                reviewController.clear();
                ratingController.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter your email to reset password',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement password reset functionality here
                // You can use FirebaseAuth.instance.sendPasswordResetEmail() to send a password reset email
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temple Management System',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(title: 'Temple Management System'),
    );
  }
}
