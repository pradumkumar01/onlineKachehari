import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_online_kachehari/screens/UserProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/Notification.dart';

// void main() => runApp(const FeedsPage());

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  String currentUserName = "John Doe";
  List<Map<String, String>> data = [];

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/feedData.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      data = jsonData.map((item) => Map<String, String>.from(item)).toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addNewPost() {
    if (titleController.text.isNotEmpty || subtitleController.text.isNotEmpty) {
      setState(() {
        data.insert(0, {
          "title": titleController.text,
          "subtitle": subtitleController.text,
          "image": _image?.path ?? "assets/images/bg3.jpg",
          "username": currentUserName,
        });
      });
      titleController.clear();
      subtitleController.clear();
      _image = null;
    }
  }

  void _deletePost(int index) {
    setState(() {
      data.removeAt(index);
    });
  }

  void _handleBackPress() {
    Navigator.pop(context);
  }

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Feeds",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: _handleBackPress,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("assets/images/f_img.jpeg"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextField(
                            controller: subtitleController,
                            decoration: const InputDecoration(
                              hintText: "Write your thoughts...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPostButton(Icons.photo, "Media", Colors.blue),
                      ElevatedButton(
                        onPressed: _addNewPost,
                        child: const Text("Post"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[300],
                thickness: 1.0,
              ),
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  elevation: 10,
                  color: Colors.transparent.withOpacity(0.9),
                  child: Container(
                    height: 350,
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.deepPurple,
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/bg3.jpg"),
                            ),
                            title: Text(item["username"] ?? "",
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(item["subtitle"] ?? "",
                                style: const TextStyle(color: Colors.white)),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              onSelected: (value) {
                                if (value == "Delete") {
                                  _deletePost(index);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  height: 30,
                                  value: "Delete",
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: item["image"] != null &&
                                        File(item["image"]!).existsSync()
                                    ? FileImage(File(item["image"]!))
                                    : const AssetImage('assets/images/bg4.jpg')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: <Widget>[
                                  Icon(Icons.thumb_up, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("Like",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.comment, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("Comments",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.share, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text("Share",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              // Do nothing as we are already on the Feeds page
              break;
            case 3:
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
              break;
            case 4:
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildPostButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: _pickImage,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
