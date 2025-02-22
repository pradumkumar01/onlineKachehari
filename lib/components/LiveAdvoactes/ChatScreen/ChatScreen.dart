import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> advocate;

  const ChatScreen({super.key, required this.advocate});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          messageContent: _messageController.text.trim(),
          messageType: "sender",
          senderId: 2,
          timestamp: DateTime.now(),
        ));
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          messages.add(ChatMessage(
            messageContent: pickedFile.path,
            messageType: "sender",
            senderId: 2,
            isImage: true,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final advocateName = widget.advocate['name'] ?? 'Unknown';
    final isOnline = widget.advocate['isOnline'] ?? false;
    final profileImage =
        widget.advocate['profileImage'] ?? 'assets/images/default_profile.png';

    final textScale = MediaQuery.of(context).textScaleFactor;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        // forceMaterialTransparency: true,
        bottom: screenWidth < 600
            ? PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  color: Colors.deepPurple,
                  height: 10,
                ),
              )
            : null,
        backgroundColor: Colors.deepPurple,
        leading: Container(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                tooltip: "Back",
              ),
            ],
          ),
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              child: CircleAvatar(
                backgroundImage: AssetImage(profileImage),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  advocateName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12 * textScale,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.white70,
                    fontSize: 8 * textScale,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.call,
              color: Colors.white,
              size: 20,
            ),
            tooltip: "Call",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white, size: 20),
            tooltip: "Video Call",
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 20),
            tooltip: "More Options",
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message.messageType == "sender";

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.deepPurple : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft:
                            isSender ? const Radius.circular(20) : Radius.zero,
                        bottomRight:
                            isSender ? Radius.zero : const Radius.circular(20),
                      ),
                    ),
                    child: message.isImage
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.file(
                                File(message.messageContent),
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text(
                                    "Image load failed",
                                    style: TextStyle(color: Colors.red),
                                  );
                                },
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('hh:mm a').format(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12 * textScale,
                                  color: isSender
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.messageContent,
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('hh:mm a').format(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12 * textScale,
                                  color: isSender
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.deepPurple),
                  tooltip: "Attach File",
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  tooltip: "Send Message",
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String messageContent;
  final String messageType;
  final int senderId;
  final DateTime timestamp;
  final bool isImage;

  ChatMessage({
    required this.messageContent,
    required this.messageType,
    required this.senderId,
    required this.timestamp,
    this.isImage = false,
  });
}
