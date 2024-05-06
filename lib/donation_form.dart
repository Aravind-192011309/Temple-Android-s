import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
    print('Payment success: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print('External wallet: ${response.walletName}');
  }

  void _openRazorpayDemoPayment() async {
    var options = {
      'key': 'rzp_test_your_key_id', // Replace with your Razorpay test key ID
      'amount': 100, // Amount in paise (e.g., 100 paise = ₹1)
      'name': 'Demo Payment',
      'description': 'This is a demo payment',
      'prefill': {
        'contact': '9876543210', // Replace with a valid phone number
        'email': 'example@example.com', // Replace with a valid email address
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Please fill in the details to make a donation:'),
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
        Text(
          'Disclaimer: Mobile app can only be used for on spot cash payments, for online transactions, please move to the website.',
          style: TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _openRazorpayDemoPayment,
          child: const Text('Donate'),
        ),
      ],
    );
  }
}