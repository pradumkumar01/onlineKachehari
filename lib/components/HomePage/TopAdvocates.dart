import 'dart:convert'; // Import this for JSON decoding
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for rootBundle
import 'package:flutter_online_kachehari/components/TopAdvocate/TopAdvocates.dart';
import 'package:flutter_online_kachehari/components/TopAdvocate/SingleAdvocate.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/services/razorpay_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TopAdvocates extends StatefulWidget {
  const TopAdvocates({super.key});

  @override
  State<TopAdvocates> createState() => _TopAdvocatesState();
}

class _TopAdvocatesState extends State<TopAdvocates> {
  List<Map<String, dynamic>> liveAdvocates =
      []; // Updated to hold advocate data
  late RazorpayService _razorpayService;

  @override
  void initState() {
    super.initState();
    _loadAdvocates(); // Load advocates data on initialization
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpayService = RazorpayService(
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
      onExternalWallet: _onExternalWallet,
    );
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful! ID: ${response.paymentId}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    // Launch WhatsApp after payment success
    Future.delayed(const Duration(seconds: 1), () {
      _launchWhatsApp();
    });
  }

  void _launchWhatsApp() {
    String url = 'whatsapp://send?phone=+6392293279';
    launchUrl(Uri.parse(url));
  }

  void _onPaymentFailure(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'Unknown Error'}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _loadAdvocates() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/json/advocate.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        // Load full advocate data
        liveAdvocates =
            jsonData.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    } catch (e) {
      print("Error loading advocates data: $e");
    }
  }

  void _initiatePayment(int index) {
    try {
      String email = liveAdvocates[index]['details']?.firstWhere(
            (d) => d['title'] == 'Email',
            orElse: () => {'content': 'support@app.com'},
          )['content'] ??
          'support@app.com';

      String phone = liveAdvocates[index]['details']?.firstWhere(
            (d) => d['title'] == 'Phone',
            orElse: () => {'content': '+919876543210'},
          )['content'] ??
          '+919876543210';

      _razorpayService.openPaymentGateway(
        advocateName: liveAdvocates[index]['name'] ?? 'Advocate',
        amount: 199,
        email: email,
        phone: phone.replaceAll(RegExp(r'[^\d+]'), ''),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initiating payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return SizedBox(
      // height: 161,
      child: liveAdvocates.isEmpty
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: liveAdvocates.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SingleAdvocate(
                          advocate: liveAdvocates[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: themeData.isDarkMode
                          ? Colors.grey[900]
                          : Colors.white,
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.3),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.deepPurple[100],
                              child: ClipOval(
                                child: Image.asset(
                                  liveAdvocates[index]['profileImage'] ??
                                      'assets/lawyer/default.jpg',
                                  fit: BoxFit.cover,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                            ),
                            // if (liveAdvocates[index]['isOnline'] == true)
                            //   Positioned(
                            //     bottom: 0,
                            //     right: 0,
                            //     child: Container(
                            //       width: 12,
                            //       height: 12,
                            //       decoration: BoxDecoration(
                            //         color: Colors.green,
                            //         shape: BoxShape.circle,
                            //         border: Border.all(
                            //           color: Colors.white,
                            //           width: 2,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          liveAdvocates[index]['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          // width: 85,
                          child: Text(
                            liveAdvocates[index]['specialization'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 32,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _initiatePayment(index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              '₹199',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
