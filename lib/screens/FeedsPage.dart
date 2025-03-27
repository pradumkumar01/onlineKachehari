import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  List articles = [];
  bool isLoading = true;
  bool hasMore = true;
  bool hasError = false;
  String errorMessage = '';
  int page = 1;
  final String apiKey =
      "6a8cd98a579946128b490e86537c754f"; // Replace with your actual API Key
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchLawTrends();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchLawTrends() async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await http.get(Uri.parse(
          "https://newsapi.org/v2/everything?q=law+trends&pageSize=5&page=$page&apiKey=$apiKey"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["articles"].isEmpty) {
          setState(() {
            hasMore = false;
          });
        } else {
          setState(() {
            articles.addAll(data["articles"]);
            page++;
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
      });
      print("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchLawTrends();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 60, 4, 213),
                Color.fromRGBO(37, 6, 105, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Latest Law Trends 2025",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isLoading = true;
                articles.clear();
                page = 1;
                hasMore = true;
                hasError = false;
                errorMessage = '';
              });
              fetchLawTrends();
            },
          )
        ],
      ),
      body: isLoading && articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text("Error: $errorMessage"))
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      isLoading = true;
                      articles.clear();
                      page = 1;
                      hasMore = true;
                      hasError = false;
                      errorMessage = '';
                    });
                    await fetchLawTrends();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(10),
                    itemCount: articles.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == articles.length) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final article = articles[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: article["urlToImage"] != null
                              ? Image.network(article["urlToImage"],
                                  fit: BoxFit.cover)
                              : Icon(Icons.article,
                                  size: 50, color: Colors.grey),
                          title: Text(
                            article["title"] ?? "No Title",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(article["description"] ?? "No Description"),
                          trailing: Text(
                            article["publishedAt"]?.substring(0, 10) ??
                                "Unknown Date",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
