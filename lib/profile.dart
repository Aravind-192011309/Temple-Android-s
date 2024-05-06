import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileDisplayPage(),
    );
  }
}

class ProfileDisplayPage extends StatefulWidget {
  @override
  _ProfileDisplayPageState createState() => _ProfileDisplayPageState();
}

class _ProfileDisplayPageState extends State<ProfileDisplayPage> {
  String _name = 'John Doe';
  String _phoneNumber = '1234567890';
  String _address = '123 Main St';
  String _email = 'johndoe@example.com';

  void _editProfile() async {
    final editedProfile = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileEditPage(
          name: _name,
          phoneNumber: _phoneNumber,
          address: _address,
          email: _email,
        ),
      ),
    );

    if (editedProfile != null) {
      setState(() {
        _name = editedProfile['name'];
        _phoneNumber = editedProfile['phoneNumber'];
        _address = editedProfile['address'];
        _email = editedProfile['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Temple Management System')),
            );
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person, color: Colors.indigoAccent),
              title: Text(
                'Name',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _name,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.indigoAccent),
              title: Text(
                'Phone Number',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _phoneNumber,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.home, color: Colors.indigoAccent),
              title: Text(
                'Address',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _address,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.email, color: Colors.indigoAccent),
              title: Text(
                'Email',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _email,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editProfile,
        child: Icon(Icons.edit),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String address;
  final String email;

  ProfileEditPage({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.email,
  });

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _addressController = TextEditingController(text: widget.address);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
      'email': _emailController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.indigoAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person, color: Colors.indigoAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone, color: Colors.indigoAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home, color: Colors.indigoAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.indigoAccent),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigoAccent),
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigoAccent,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
