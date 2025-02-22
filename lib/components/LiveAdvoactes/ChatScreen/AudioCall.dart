import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioCall extends StatefulWidget {
  final String
      contactName; // Pass the contact name when navigating to this screen
  const AudioCall({super.key, required this.contactName});

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {
  RTCPeerConnection? _peerConnection; // Make this nullable
  MediaStream? _localStream; // Make this nullable
  bool _isMuted = false; // Track mute state
  final String _callDuration = "00:00"; // Call duration placeholder

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _localStream = await _getUserMedia();
      _peerConnection = await _createPeerConnection();
    } catch (e) {
      print("Error initializing: $e");
      // Handle error (e.g., show an error message to the user)
    }
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false,
    };
    return await navigator.mediaDevices.getUserMedia(mediaConstraints);
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    RTCPeerConnection pc = await createPeerConnection(configuration);
    pc.addStream(_localStream!); // Use the null-safe operator
    return pc;
  }

  void _toggleMute() {
    if (_localStream != null) {
      setState(() {
        _isMuted = !_isMuted;
      });
      _localStream!.getAudioTracks().forEach((track) {
        track.enabled = !_isMuted; // Mute or unmute audio
      });
    }
  }

  void _endCall() {
    // Logic to end the call and navigate back
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _localStream?.dispose(); // Safely dispose if initialized
    _peerConnection?.close(); // Safely close if initialized
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.deepPurple.withOpacity(
              0.7), // Changed to a solid color for better visibility
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person,
                  size: 100,
                  color: Colors.white), // Placeholder for contact image
              const SizedBox(height: 20),
              Text(
                widget.contactName,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                _callDuration,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isMuted ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: _toggleMute,
                  ),
                  const SizedBox(width: 50),
                  IconButton(
                    icon: const Icon(
                      Icons.call_end,
                      color: Colors.red,
                      size: 36,
                    ),
                    onPressed: _endCall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
