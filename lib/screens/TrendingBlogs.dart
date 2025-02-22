import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class TrendingBlogs extends StatefulWidget {
  const TrendingBlogs({super.key});

  @override
  State<TrendingBlogs> createState() => _TrendingBlogsState();
}

class _TrendingBlogsState extends State<TrendingBlogs> {
  // Define a list of blog data
  var blogs = [
    {
      'title': 'How to build a startup',
      'author': 'John Doe',
      'description':
          'A comprehensive guide to building a successful startup from scratch.',
      'imageUrl':
          'https://images.pexels.com/photos/3153204/pexels-photo-3153204.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'AI in the Modern World',
      'author': 'Jane Smith',
      'description':
          'Exploring the impact of Artificial Intelligence in today’s society.',
      'imageUrl':
          'https://images.pexels.com/photos/3178818/pexels-photo-3178818.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'Healthy Living: A New Approach',
      'author': 'Alice Johnson',
      'description':
          'Tips and tricks on how to maintain a healthy lifestyle in a busy world.',
      'imageUrl':
          'https://images.pexels.com/photos/4240505/pexels-photo-4240505.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'The Future of Work',
      'author': 'Michael Brown',
      'description':
          'Analyzing how automation and remote work will shape the future job market.',
      'imageUrl':
          'https://images.pexels.com/photos/4240606/pexels-photo-4240606.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'Travel on a Budget',
      'author': 'Sarah Wilson',
      'description':
          'The ultimate guide to affordable travel experiences across the globe.',
      'imageUrl':
          'https://images.pexels.com/photos/4240503/pexels-photo-4240503.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    // 5 More blogs added
    {
      'title': 'Mastering Photography',
      'author': 'Robert Green',
      'description':
          'Learn how to capture stunning photos using your smartphone or DSLR.',
      'imageUrl':
          'https://images.pexels.com/photos/3194523/pexels-photo-3194523.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'Investing in the Stock Market',
      'author': 'Laura White',
      'description':
          'Beginner’s guide to understanding the stock market and making smart investments.',
      'imageUrl':
          'https://images.pexels.com/photos/3768894/pexels-photo-3768894.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'Minimalism in Modern Life',
      'author': 'David Clark',
      'description':
          'How to embrace a minimalist lifestyle and declutter your life and mind.',
      'imageUrl':
          'https://images.pexels.com/photos/4458554/pexels-photo-4458554.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'The Rise of Electric Cars',
      'author': 'Emma Thompson',
      'description':
          'Exploring the growth of electric vehicles and their impact on the environment.',
      'imageUrl':
          'https://images.pexels.com/photos/4050351/pexels-photo-4050351.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
    {
      'title': 'Learning to Code: Where to Start',
      'author': 'James Baker',
      'description':
          'A step-by-step guide for beginners looking to learn programming languages.',
      'imageUrl':
          'https://images.pexels.com/photos/7669729/pexels-photo-7669729.jpeg?auto=compress&cs=tinysrgb&w=600'
    },
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Trending Blogs",
          style: TextStyle(
            fontFamily: "serif",
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          color: Colors.deepPurple,
        ),
      ),
      body: Container(
        color: themeData.isDarkMode ? Colors.black : Colors.white,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final blog = blogs[index];
            return Card(
              elevation: 5,
              shadowColor: themeData.isDarkMode ? Colors.white : Colors.black,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Blog Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(blog['imageUrl']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Blog Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog['title']!,
                            style: const TextStyle(
                              fontFamily: "serif",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            blog['description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "serif",
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "By ${blog['author']}",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Read Now Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add functionality for "Read Now"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Read Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "serif",
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(),
          itemCount: blogs.length,
        ),
      ),
    );
  }
}
