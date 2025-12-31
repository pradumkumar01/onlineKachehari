import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/screens/AllTickets_customerSupport.dart';
import 'package:flutter_online_kachehari/services/ticket_service.dart';
import 'package:provider/provider.dart';

class Customersupport extends StatefulWidget {
  const Customersupport({super.key});

  @override
  State<Customersupport> createState() => _CustomersupportState();
}

class _CustomersupportState extends State<Customersupport>
    with SingleTickerProviderStateMixin {
  // Animation controller for raising issue button
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TicketService _ticketService = TicketService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _reasonController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    // Validate inputs
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a title');
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      _showError('Please enter a reason');
      return;
    }
    if (_messageController.text.trim().isEmpty) {
      _showError('Please enter a message');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _ticketService.createTicket(
        title: _titleController.text.trim(),
        reason: _reasonController.text.trim(),
        message: _messageController.text.trim(),
      );

      // Clear form
      _titleController.clear();
      _reasonController.clear();
      _messageController.clear();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket submitted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Support",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "serif",
              fontSize: 21,
              fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          color: Colors.deepPurple,
        ),
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            alignment: Alignment.center,
            height: 500,
            width: 350,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.white, Colors.deepPurpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 23, right: 23, top: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Hero(
                          tag: 'profile_icon',
                          child: Card(
                            elevation: 5,
                            shape: const CircleBorder(
                                side: BorderSide(color: Colors.grey)),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35)),
                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return AllticketsCustomersupport();
                            }));
                          },
                          child: const AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: 0.8,
                            child: Text('View all tickets',
                                style: TextStyle(
                                  fontFamily: "serif",
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 21, right: 21),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _titleController,
                            textAlign: TextAlign.center,
                            enabled: !_isSubmitting,
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif',
                              ),
                            ),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 21, right: 21),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _reasonController,
                            textAlign: TextAlign.center,
                            enabled: !_isSubmitting,
                            decoration: const InputDecoration(
                              hintText: 'Reason',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif',
                              ),
                            ),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 21, right: 21),
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _messageController,
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            enabled: !_isSubmitting,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif',
                              ),
                            ),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'serif'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  _controller.forward().then((_) {
                                    _controller.reverse();
                                  });
                                  _submitTicket();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Raise issue",
                                  style: TextStyle(
                                      fontFamily: "serif",
                                      fontSize: 21,
                                      color: Colors.white),
                                ),
                        ),
                      ),
                    ],
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
