import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_online_kachehari/screens/UserProfile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_online_kachehari/screens/HomePage.dart';
import 'package:flutter_online_kachehari/screens/Notification.dart';
import 'package:flutter_online_kachehari/services/InstagramReelsService.dart';
import 'package:flutter_online_kachehari/services/NewsService.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() => runApp(const FeedsPage());

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key});

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  String currentUserName = "John Doe";
  List<Map<String, dynamic>> data = [];

  File? _image;
  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController reelUrlController = TextEditingController();

  final NewsService _newsService = NewsService();
  bool _isLoadingReel = false;
  bool _isLoadingNews = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Initialize empty data list - news will be loaded on demand
    setState(() {
      data = [];
    });

    // Load news after initial data
    _loadNews();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _loadNews() async {
    if (_isLoadingNews) return;

    setState(() {
      _isLoadingNews = true;
    });

    try {
      final newsList = await _newsService.fetchNews();

      setState(() {
        // Add news articles to the feed
        for (var news in newsList) {
          data.insert(0, {
            "title": news['title'] ?? 'No Title',
            "subtitle": news['description'] ?? 'No Description',
            "image": news['image'] ?? 'assets/images/bg4.jpg',
            "username": news['source'] ?? 'News',
            "author": news['author'] ?? 'Unknown',
            "publishedAt": news['publishedAt'] ?? '',
            "url": news['url'] ?? '',
            "isNews": true,
          });
        }
        _isLoadingNews = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingNews = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading news: ${e.toString()}')),
      );
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
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "News Feed",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: _handleBackPress,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Create Post Section
            // _buildCreatePostSection(),
            const SizedBox(height: 12),
            // Divider
            Container(
              height: 8,
              color: Colors.grey[200],
            ),
            // Fetch News Button
            Container(
              height: 8,
              color: Colors.grey[200],
            ),
            // News Feed
            _buildNewsFeed(),

            _buildFetchNewsSection(),
          ],
        ),
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

  Widget _buildCreatePostSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage("assets/images/f_img.jpeg"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: subtitleController,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.photo, "Photo", Colors.blue, _pickImage),
              _buildActionButton(
                  Icons.video_library, "Video", Colors.red, () {}),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: _addNewPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:
                      const Text("Post", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildFetchNewsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          _isLoadingNews
              ? const SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                    ),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: InkWell(
                    onTap: _loadNews,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildNewsFeed() {
    if (data.isEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: Text(
            "No posts yet. Click 'Fetch News' to load articles.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) =>
          Container(height: 8, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final item = data[index];
        final isNews = item['isNews'] == true;

        if (isNews) {
          return _buildNewsCard(item, index);
        } else {
          return _buildPostCard(item, index);
        }
      },
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item, int index) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // News Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['username'] ?? 'News Source',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item['publishedAt'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "Delete") {
                      _deletePost(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "Delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Delete", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // News Image
          if (item['image'] != null &&
              item['image'].toString().startsWith('http'))
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.network(
                item['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  );
                },
              ),
            ),
          // News Title and Description
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item['subtitle'] ?? 'No Description',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    if (item['url'] != null &&
                        item['url'].toString().isNotEmpty) {
                      _launchUrl(item['url']);
                    }
                  },
                  child: Text(
                    'Read Full Article',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNewsActionButton(Icons.thumb_up_outlined, 'Like'),
                _buildNewsActionButton(Icons.comment_outlined, 'Comment'),
                _buildNewsActionButton(Icons.share_outlined, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> item, int index) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/f_img.jpeg"),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['username'] ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Just now',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "Delete") {
                      _deletePost(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "Delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text("Delete", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Post Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              item['subtitle'] ?? 'No content',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Post Image
          if (item['image'] != null)
            ClipRRect(
              child: Container(
                color: Colors.grey[300],
                child: item['image'].toString().startsWith('http')
                    ? Image.network(
                        item['image'],
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      )
                    : Image.file(
                        File(item['image']),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
              ),
            ),
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNewsActionButton(Icons.thumb_up_outlined, 'Like'),
                _buildNewsActionButton(Icons.comment_outlined, 'Comment'),
                _buildNewsActionButton(Icons.share_outlined, 'Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    reelUrlController.dispose();
    super.dispose();
  }
}
