import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: [
            FutureBuilder<int>(
              future: _getTempleCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return AdminCard(
                  title: 'Manage Temples',
                  // count: snapshot.data!,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageTemplesPage()));
                  },
                );
              },
            ),
            FutureBuilder<int>(
              future: _getFestivalCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return AdminCard(
                  title: 'Manage Festivals',

                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageFestivalsPage()));
                  },
                );
              },
            ),
            FutureBuilder<int>(
              future: _getDarshanCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return AdminCard(
                  title: 'Manage Darshans',
                  // count: snapshot.data!,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ManageDarshanPage()));
                  },
                );
              },
            ),
            AdminCard(
              title: 'View Users',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUsersPage()));
              },
            ),
            AdminCard(
              title: 'View Donations',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDonationsPage()));
              },
            ),
            AdminCard(
              title: 'Logout ',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginOptionsPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<int> _getTempleCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Temples').get();
    return snapshot.size;
  }

  Future<int> _getFestivalCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Festivals').get();
    return snapshot.size;
  }

  Future<int> _getDarshanCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Darshans').get();
    return snapshot.size;
  }
}

class AdminCard extends StatelessWidget {
  final String title;
  // final int? count;
  final VoidCallback? onTap;

  const AdminCard({Key? key, required this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueAccent,
                Colors.blue,
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ManageTemplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Temples'),
      ),
      body: Column(
        children: [
          Expanded(
            child: TempleList(),
          ),
          AddTempleButton(),
        ],
      ),
    );
  }
}

class TempleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Temples').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var temple = snapshot.data!.docs[index];
            return ListTile(
              title: Text(temple['tname']),
              subtitle: Text(temple['tlocation']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  temple.reference.delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddTempleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTemplePage()),
        );
      },
      child: const Text('Add Temple'),
    );
  }
}

class AddTemplePage extends StatefulWidget {
  @override
  _AddTemplePageState createState() => _AddTemplePageState();
}

class _AddTemplePageState extends State<AddTemplePage> {
  final TextEditingController _templeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Temple'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _templeNameController,
              decoration: const InputDecoration(labelText: 'Temple Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Temples').add({
                  'tname': _templeNameController.text,
                  'tlocation': _locationController.text,
                  'tdescription': _descriptionController.text,
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageDarshanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Darshan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DismissibleDarshanList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDarshanPage()),
          );
        },
        tooltip: 'Add Darshan',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DismissibleDarshanList extends StatelessWidget {
  const DismissibleDarshanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Darshans').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var darshan = snapshot.data!.docs[index];
            return Dismissible(
              key: Key(darshan.id),
              direction: DismissDirection.horizontal,
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Icon(Icons.check, color: Colors.white),
                ),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _moveToDarshanFinished(darshan);
                } else {
                  _deleteDarshan(darshan);
                }
              },
              child: Card(
                child: ListTile(
                  title: Text(darshan['templeName'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aadhar Number: ${darshan['aadharNumber'] ?? ''}'),
                      Text('Age: ${darshan['age'] ?? ''}'),
                      Text('First Name: ${darshan['firstName'] ?? ''}'),
                      Text('Last Name: ${darshan['lastName'] ?? ''}'),
                      Text('Number of People: ${darshan['numberOfPeople'] ?? ''}'),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _moveToDarshanFinished(QueryDocumentSnapshot darshan) {
    FirebaseFirestore.instance
        .collection('Darshans-Finished')
        .add(darshan.data() as Map<String, dynamic>);
    darshan.reference.delete();
  }

  void _deleteDarshan(QueryDocumentSnapshot darshan) {
    darshan.reference.delete();
  }
}

class DarshanList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Darshans').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var darshan = snapshot.data!.docs[index];
            return ListTile(
              title: Text(darshan['date']),
              subtitle: Text(darshan['did']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      darshan.reference.delete();
                    },
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


class AddDarshanPage extends StatefulWidget {
  @override
  _AddDarshanPageState createState() => _AddDarshanPageState();
}

class _AddDarshanPageState extends State<AddDarshanPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _didController = TextEditingController();
  final TextEditingController _templeNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Darshan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _didController,
              decoration: const InputDecoration(labelText: 'DID'),
            ),
            TextField(
              controller: _templeNameController,
              decoration: const InputDecoration(labelText: 'Temple Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Darshans').add({
                  'date': _dateController.text, // Change 'date' to the correct field name
                  'did': _didController.text,
                  'templeName': _templeNameController.text, // Rename 'dtemple' to 'templeName'
                });

                // ...
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageFestivalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Festivals'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FestivalList(),
          ),
          AddFestivalButton(),
        ],
      ),
    );
  }
}

class FestivalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Festivals').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var festival = snapshot.data!.docs[index];
            return ListTile(
              title: Text(festival['name']),
              // subtitle: Text(festival['date']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  festival.reference.delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddFestivalButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFestivalPage()),
        );
      },
      child: const Text('Add Festival'),
    );
  }
}

class AddFestivalPage extends StatefulWidget {
  @override
  _AddFestivalPageState createState() => _AddFestivalPageState();
}

class _AddFestivalPageState extends State<AddFestivalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Festival'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Festival Name'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _venueController,
              decoration: const InputDecoration(labelText: 'Venue'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Festivals').add({
                  'name': _nameController.text,
                  'date': _dateController.text,
                  'venue': _venueController.text,
                });

                _nameController.clear();
                _dateController.clear();
                _venueController.clear();

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppUser {
  final String email;
  final String creationDate;
  final String lastSignInDate;

  AppUser(this.email, this.creationDate, this.lastSignInDate);
}

class ViewUsersPage extends StatelessWidget {
  final List<Map<String, String>> userData = [
    {
      'email': 'kunapaneniaravindkumar@gmail.com',
      'creationDate': 'Mar 10, 2024',
      'lastSignInDate': 'Apr 18, 2024',
    },
    {
      'email': 'karthikeya.peeriga21@gmail.com',
      'creationDate': 'Mar 10, 2024',
      'lastSignInDate': 'Mar 20, 2024',
    },
    {
      'email': 'something@gmail.com',
      'creationDate': 'Feb 24, 2024',
      'lastSignInDate': 'Feb 24, 2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Users'),
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final user = userData[index];
          return UserCard(
            email: user['email']!,
            creationDate: user['creationDate']!,
            lastSignInDate: user['lastSignInDate']!,
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String email;
  final String creationDate;
  final String lastSignInDate;

  const UserCard({
    required this.email,
    required this.creationDate,
    required this.lastSignInDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('Email: $email'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Creation Date: $creationDate'),
            Text('Last Sign-In Date: $lastSignInDate'),
          ],
        ),
      ),
    );
  }
}

class ViewDonationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Donations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Donations').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var donation = snapshot.data!.docs[index];
              return DonationCard(
                adhaarNo: donation['AadhaarNo'],
                amount: donation['Amount'],
                donatorName: donation['DonatorName'],
                templeName: donation['TempleName'],
              );
            },
          );
        },
      ),
    );
  }
}
class DonationCard extends StatelessWidget {
  final String adhaarNo;
  final int amount;
  final String donatorName;
  final String templeName;

  const DonationCard({
    required this.adhaarNo,
    required this.amount,
    required this.donatorName,
    required this.templeName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text('AadhaarNo: $adhaarNo'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: $amount'),
            Text('DonatorName: $donatorName'),
            Text('TempleName: $templeName'),
          ],
        ),
      ),
    );
  }
}


