import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_online_kachehari/components/LiveAdvoactes/ChatScreen/ChatScreen.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/services/razorpay_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveWakeels extends StatefulWidget {
  const LiveWakeels({super.key});

  @override
  State<LiveWakeels> createState() => _LiveWakeelsState();
}

class _LiveWakeelsState extends State<LiveWakeels> {
  List<Map<String, dynamic>> _lawyers = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late RazorpayService _razorpayService;

  @override
  void initState() {
    super.initState();
    _loadLawyerData();
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
      const SnackBar(
        // content: Text('Payment Successful! ID: ${response.paymentId}'),
        content: Text("Payment Successful!"),
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

  Future<void> _loadLawyerData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/advocate.json');
      final data = json.decode(response) as List;
      setState(() {
        _lawyers = data.map((json) => json as Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load data: $e";
        _isLoading = false;
      });
    }
  }

  void _initiatePayment(int index) {
    try {
      String email = _lawyers[index]['details']?.firstWhere(
            (d) => d['title'] == 'Email',
            orElse: () => {'content': 'support@app.com'},
          )['content'] ??
          'support@app.com';

      String phone = _lawyers[index]['details']?.firstWhere(
            (d) => d['title'] == 'Phone',
            orElse: () => {'content': '+919876543210'},
          )['content'] ??
          '+919876543210';

      _razorpayService.openPaymentGateway(
        advocateName: _lawyers[index]['name'] ?? 'Advocate',
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
    final size = MediaQuery.of(context).size;
    var themeData = Provider.of<ThemeProviderState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Live Advocates",
          style: TextStyle(
            fontFamily: "serif",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(_errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: themeData.isDarkMode
                          ? [Colors.black87, Colors.black]
                          : [Colors.grey[50]!, Colors.white],
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.height * 0.015,
                    ),
                    itemCount: _lawyers.length,
                    itemBuilder: (context, index) {
                      final item = _lawyers[index];
                      return _buildLiveAdvocateCard(
                          context, index, item, size, themeData);
                    },
                  ),
                ),
    );
  }

  Widget _buildLiveAdvocateCard(
    BuildContext context,
    int index,
    Map<String, dynamic> item,
    Size size,
    ThemeProviderState themeData,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.015),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: themeData.isDarkMode ? Colors.grey[900] : Colors.white,
            child: Column(
              children: [
                // Header with Status Bar
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.012,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: item['isOnline'] == true
                          ? [Colors.green.shade400, Colors.teal.shade400]
                          : [Colors.grey.shade400, Colors.grey.shade600],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (item['isOnline'] == true
                                      ? Colors.green
                                      : Colors.grey)
                                  .withOpacity(0.5),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        item['isOnline'] == true ? 'Online Now' : 'Offline',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Main Content
                Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    children: [
                      // Profile Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.deepPurple.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: size.width * 0.09,
                              backgroundColor: Colors.deepPurpleAccent,
                              backgroundImage: item['profileImage'] != null
                                  ? AssetImage(item['profileImage'])
                                  : const AssetImage(
                                      'assets/images/default_profile.png'),
                            ),
                          ),
                          SizedBox(width: size.width * 0.04),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? 'Unknown Name',
                                  style: TextStyle(
                                    fontFamily: "serif",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: themeData.isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.004),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02,
                                    vertical: size.height * 0.003,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['specialization'] ??
                                        'No Specialization',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      // Action Buttons Row
                      Row(
                        children: [
                          // Chat Button
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: item['isOnline'] == true
                                      ? () => _launchWhatsApp()
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.chat_rounded,
                                          color: item['isOnline'] == true
                                              ? Colors.deepPurple
                                              : Colors.grey,
                                          size: size.width * 0.05,
                                        ),
                                        SizedBox(height: size.height * 0.004),
                                        Text(
                                          'Chat',
                                          style: TextStyle(
                                            color: item['isOnline'] == true
                                                ? Colors.deepPurple
                                                : Colors.grey,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.02),
                          // Payment Button
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber.shade400,
                                    Colors.orange.shade400,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: item['isOnline'] == true
                                      ? () => _initiatePayment(index)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: size.height * 0.01,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.videocam_rounded,
                                          color: Colors.white,
                                          size: size.width * 0.05,
                                        ),
                                        SizedBox(height: size.height * 0.004),
                                        Text(
                                          '₹199',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> lawyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lawyer['name'] ?? 'Advocate Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: (lawyer['details'] as List?)
                  ?.map<Widget>((detail) => ListTile(
                        title: Text(detail['title'] ?? 'No Title'),
                        subtitle: Text(detail['content'] ?? 'No Content'),
                      ))
                  .toList() ??
              [const Text("No additional details available.")],
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
