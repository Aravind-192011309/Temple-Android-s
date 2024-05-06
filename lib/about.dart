import 'package:flutter/material.dart';
import 'package:tms/home.dart';
import 'about.dart';
import 'contact.dart';
import 'darshan_ticket_history.dart';
import 'main.dart';
import 'our_festivals.dart';
import 'temples.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
          child: Text('About'), // Add a Text widget as the child
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
      body: Stack(
        children: [

          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/temple2.png', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.transparent, // Set background color to transparent
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 170),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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
            ),
          ),
        ],
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
}
