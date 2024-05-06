import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tms/payment_webview.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tms/profile.dart';
import 'about.dart';
import 'contact.dart';
import 'darshan_ticket_history.dart';
import 'home.dart';
import 'main.dart';
import 'our_festivals.dart';

class TemplesPage extends StatefulWidget {
  const TemplesPage({Key? key}) : super(key: key);

  @override
  _TemplesPageState createState() => _TemplesPageState();
}

class _TemplesPageState extends State<TemplesPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allTemples = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredTemples = [];
  bool isSearching = false;

  void filterTemples(String searchTerm) {
    setState(() {
      if (searchTerm.isNotEmpty) {
        filteredTemples = allTemples
            .where((temple) =>
            (temple['tname'] as String)
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
            .toList();
        isSearching = true;
      } else {
        filteredTemples = allTemples;
        isSearching = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temples'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SearchBar(
                  onSearch: filterTemples,
                ),
                const SizedBox(height: 20),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('Temples').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      allTemples = snapshot.data!.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>();
                      if (!isSearching) {
                        return Column(
                          children: [
                            for (var document in allTemples) ...[
                              TempleCard(
                                templeName: document['tname'] ?? '',
                                location: document['tlocation'] ?? '',
                                description: document['tdescription'] ?? '',
                                onDarshanBooking: () {
                                  _showDarshanForm(context, document.data() as Map<String, dynamic>);
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      } else {
                        if (filteredTemples.isEmpty) {
                          return const Text('Temple doesn\'t exist on our app yet');
                        }
                        return Column(
                          children: [
                            for (var document in filteredTemples) ...[
                              TempleCard(
                                templeName: document['tname'] ?? '',
                                location: document['tlocation'] ?? '',
                                description: document['tdescription'] ?? '',
                                onDarshanBooking: () {
                                  _showDarshanForm(context, document.data() as Map<String, dynamic>);
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
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
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: "TMS")),
                );              },
            ),
            ListTile(
              title: Text('Our Festivals'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OurFestivalsPage()),
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
        ),
      ),
    );
  }

  void _showDarshanForm(BuildContext context, Map<String, dynamic> templeData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Pass the templeData to the DarshanForm widget
        return AlertDialog(
          title: Text('Darshan Booking for ${templeData['tname']}'),
          content: DarshanForm(templeData: templeData),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class TempleCard extends StatelessWidget {
  final String templeName;
  final String location;
  final String description;
  final VoidCallback? onDarshanBooking;

  const TempleCard({
    Key? key,
    required this.templeName,
    required this.location,
    required this.description,
    this.onDarshanBooking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temple Name: $templeName',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text('Location: $location'),
            const SizedBox(height: 8),
            Text('Description: $description'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (onDarshanBooking != null) {
                      onDarshanBooking!();
                    }
                  },
                  child: const Text('Darshan Booking'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Call _openRazorpayCheckout method directly
                    _openRazorpayCheckout(context);
                  },
                  child: const Text('Make a Donation'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openRazorpayCheckout(BuildContext context) async {
    var options = {
      'key': 'rzp_test_Ifx3bbwOEc6Vm2', // Your Razorpay test key
      'amount': 10000, // 100 INR in paise
      'name': 'Temple Management system',
      'description': 'Payment for $templeName',
      'prefill': {
        'contact': '9876543210', // Replace with customer's mobile number
        'email': 'Aravind@example.com', // Replace with customer's email
      },
      'external': {
        'wallets': ['paytm'] // Add wallets you want to support
      }
    };

    try {
      final _razorpay = Razorpay();
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (data) {
        // Handle payment success
      });
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (data) {
        // Handle payment error
      });
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (data) {
        // Handle external wallet
      });
    } catch (e) {
      // Handle error
    }
  }
}

class DarshanForm extends StatefulWidget {
  final Map<String, dynamic> templeData;

  const DarshanForm({
    Key? key,
    required this.templeData,
  }) : super(key: key);

  @override
  _DarshanFormState createState() => _DarshanFormState();
}

class _DarshanFormState extends State<DarshanForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _numberOfPeopleController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  late TextEditingController _templenameController;

  @override
  void initState() {
    super.initState();
    _templenameController = TextEditingController(text: widget.templeData['tname']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _templenameController,
            decoration: const InputDecoration(labelText: 'Temple Name'),
          ),
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _numberOfPeopleController,
            decoration: const InputDecoration(labelText: 'Number of People'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _aadharController,
            decoration: const InputDecoration(labelText: 'Aadhar Card Number'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _submitDarshanDetails();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitDarshanDetails() {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final int age = int.tryParse(_ageController.text.trim()) ?? 0;
    final int numberOfPeople = int.tryParse(_numberOfPeopleController.text.trim()) ?? 0;
    final String aadharNumber = _aadharController.text.trim();
    final String templeName = _templenameController.text.trim();

    FirebaseFirestore.instance.collection('Darshans').add({
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'numberOfPeople': numberOfPeople,
      'aadharNumber': aadharNumber,
      'templeName': templeName,
    });

    _firstNameController.clear();
    _lastNameController.clear();
    _ageController.clear();
    _numberOfPeopleController.clear();
    _aadharController.clear();
    _templenameController.clear();
    Navigator.of(context).pop();
  }
}

class DonationForm extends StatefulWidget {
  final String templeName;

  const DonationForm({
    Key? key,
    required this.templeName,
  }) : super(key: key);

  @override
  _DonationFormState createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _donatorNameController = TextEditingController();

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    // You can save the donation details to Firestore here
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  void _openRazorpayCheckout() async {
    var options = {
      'key': 'rzp_test_Ifx3bbwOEc6Vm2', // Your Razorpay test key
      'amount': int.parse(_amountController.text.trim()) * 100, // Amount in paise
      'name': 'Your App Name',
      'description': 'Payment for your app',
      'prefill': {
        'contact': '9876543210', // Replace with customer's mobile number
        'email': 'customer@example.com', // Replace with customer's email
      },
      'external': {
        'wallets': ['paytm'] // Add wallets you want to support
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Please fill in the details to make a donation:'),
        const SizedBox(height: 10),
        TextField(
          controller: _aadharController,
          decoration: const InputDecoration(labelText: 'Aadhaar Number'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _donatorNameController,
          decoration: const InputDecoration(labelText: 'Donator Name'),
        ),
        const SizedBox(height: 20),
        const Text(
          'Disclaimer: Mobile app can only be used for on spot cash payments, for online transactions, please move to the website.',
          style: TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _openRazorpayCheckout,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search temples...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        widget.onSearch(value);
      },
    );
  }
}
