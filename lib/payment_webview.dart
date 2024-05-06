import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({Key? key}) : super(key: key);

  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController controller) async {
          _controller = controller;
          String clientSecret = 'YOUR_CLIENT_SECRET'; // Replace with your actual client secret
          _loadStripeCheckout(clientSecret);
        },
      ),
    );
  }

  void _loadStripeCheckout(String clientSecret) {
    String htmlContents = '''
      <html>
      <head>
        <title>Payment Gateway</title>
        <script src="https://js.stripe.com/v3/"></script>
      </head>
      <body>
        <button id="checkout-button">Checkout</button>
        <div id="error-message"></div>
        <script>
          var stripe = Stripe('pk_test_51P71SASEjgZQApG7R2yXEknYYyE2h3MrUwjpWJB8Bqv7XQw2MYOXZJnDxIrOV8dM0oT23UpEcklP3ziXKYj8JwfU00klRqymYN');
          var checkoutButton = document.getElementById('checkout-button');
          checkoutButton.addEventListener('click', function () {
            stripe.redirectToCheckout({
              sessionId: '$clientSecret'
            }).then(function (result) {
              // Handle result.error if needed
            });
          });
        </script>
      </body>
      </html>
    ''';

    _controller.loadUrl(Uri.dataFromString(htmlContents, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }
}
