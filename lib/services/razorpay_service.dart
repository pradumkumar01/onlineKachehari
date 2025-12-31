import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PaymentNotificationService.dart';

class RazorpayService {
  Razorpay? _razorpay;
  Function(PaymentSuccessResponse)? onSuccess;
  Function(PaymentFailureResponse)? onFailure;
  Function(ExternalWalletResponse)? onExternalWallet;
  final PaymentNotificationService _paymentNotificationService =
      PaymentNotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentPaymentAmount;
  String? _currentAdvocateName;

  RazorpayService({
    this.onSuccess,
    this.onFailure,
    this.onExternalWallet,
  }) {
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    try {
      _razorpay = Razorpay();
      _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    } catch (e) {
      print('Error initializing Razorpay: $e');
      _razorpay = null;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Save payment success notification
    _savePaymentNotification(
      status: 'success',
      transactionId: response.paymentId ?? 'N/A',
    );

    if (onSuccess != null) {
      onSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Save payment failure notification
    _savePaymentNotification(
      status: 'failed',
      transactionId: 'N/A',
    );

    if (onFailure != null) {
      onFailure!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (onExternalWallet != null) {
      onExternalWallet!(response);
    }
  }

  void _savePaymentNotification({
    required String status,
    required String transactionId,
  }) {
    final user = _auth.currentUser;
    if (user != null) {
      _paymentNotificationService.savePaymentNotification(
        amount:
            _currentPaymentAmount != null ? '₹$_currentPaymentAmount' : 'N/A',
        paymentMethod: 'Razorpay',
        transactionId: transactionId,
        status: status,
        advocateName: _currentAdvocateName,
        serviceType: 'Online Kachehari Service',
      );
    }
  }

  void openPaymentGateway({
    required String advocateName,
    required int amount,
    required String email,
    required String phone,
  }) {
    if (_razorpay == null) {
      _initializeRazorpay();
    }

    if (_razorpay == null) {
      print('Razorpay is not available on this platform');
      return;
    }

    // Store payment details for notification
    _currentPaymentAmount = amount.toString();
    _currentAdvocateName = advocateName;

    try {
      var options = {
        'key': 'rzp_test_RpzKBPf4i46xxs', // Test API Key
        'amount': amount * 100, // Amount in paise
        'name': advocateName,
        'description': 'Consultation Fee',
        'prefill': {
          'contact': phone,
          'email': email,
        },
        'theme': {
          'color': '#7C3AED', // Deep Purple color matching your app
        }
      };

      _razorpay?.open(options);
    } catch (e) {
      print('Error opening Razorpay: $e');
    }
  }

  void dispose() {
    try {
      _razorpay?.clear();
    } catch (e) {
      print('Error disposing Razorpay: $e');
    }
    _razorpay = null;
  }
}
