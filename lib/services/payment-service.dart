import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com//v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51ILjDrLhkDqyKqlqXiYf9RNa0UPwxn6RKx5DP7zdDqJjWMQ4SxgEWgR4dfvTxOjJ3Z8vfZboKoFYzF74STQQWXzx00dTqCcqO8';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  static init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51ILjDrLhkDqyKqlqI0xIaYKBwKATtvaVgIaTIdcqCmwY7K17Q2k7ku4apvloAGGVBhIsflbYT0hvWMbYXjBBUULJ00YguA9dbW",
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  static StripeTransactionResponse payWithExistingCard(
      {String amount, String currency, card}) {
    return new StripeTransactionResponse(
      message: 'Transaction successful',
      success: true,
    );
  }

  static Future<StripeTransactionResponse> payWithNewCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent = await StripeService.createPaymentIntent(
        amount,
        currency,
      );
      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );
      if (response.status == 'succeeded') {
        return new StripeTransactionResponse(
          message: 'Transaction successful',
          success: true,
        );
      } else {
        return new StripeTransactionResponse(
          message: 'Transaction failed',
          success: false,
        );
      }
    } catch (err) {
      return new StripeTransactionResponse(
        message: 'Transaction failed: ${err.toString()}',
        success: false,
      );
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        StripeService.paymentApiUrl,
        body: body,
        headers: headers,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print('err charing user: ${err.toString()}');
    }
    return null;
  }
}
