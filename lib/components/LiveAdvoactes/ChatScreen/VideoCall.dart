import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCall extends StatefulWidget {
  final String
      contactName; // Pass the contact name when navigating to this screen
  const VideoCall({super.key, required this.contactName});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  RTCPeerConnection? _peerConnection; // Make this nullable
  MediaStream? _localStream; // Make this nullable
  bool _isMuted = false; // Track mute state
  bool _isCameraOff = false; // Track camera state
  final String _callDuration = "00:00"; // Placeholder for call duration

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
      // Handle error (e.g., show an error message)
    }
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': true, // Enable video
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
    if (_localStream != null) {
      pc.addStream(_localStream!); // Safely access the local stream
    }
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

  void _toggleCamera() {
    if (_localStream != null) {
      setState(() {
        _isCameraOff = !_isCameraOff;
      });
      _localStream!.getVideoTracks().forEach((track) {
        track.enabled = !_isCameraOff; // Enable or disable video
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
        // Video feed
        _localStream != null
            ? RTCVideoView(
                (_localStream!.getVideoTracks().isNotEmpty
                    ? _localStream!.getVideoTracks()[0]
                    : null) as RTCVideoRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              )
            : const Center(
                child:
                    CircularProgressIndicator()), // Loading indicator while initializing
        // Overlay for call controls
        Container(
          color: Colors.deepPurple.withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.contactName,
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  _callDuration,
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const Spacer(),
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
                      icon: Icon(
                        _isCameraOff ? Icons.videocam_off : Icons.videocam,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: _toggleCamera,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
