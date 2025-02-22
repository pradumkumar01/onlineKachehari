import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalNewsItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime publicationDate;
  final String sourceUrl;

  LegalNewsItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.publicationDate,
    required this.sourceUrl,
  });
}

class LegalNews extends StatefulWidget {
  const LegalNews({super.key});

  @override
  State<LegalNews> createState() => _LegalNewsState();
}

class _LegalNewsState extends State<LegalNews> {
  final List<LegalNewsItem> newsItems = [
    LegalNewsItem(
      id: "news_001",
      title: "Supreme Court Ruling on Data Privacy",
      description:
          "The Supreme Court ruled in favor of stricter data privacy regulations, impacting how companies handle consumer data.",
      category: "Court Rulings",
      publicationDate: DateTime.parse("2023-10-01"),
      sourceUrl: "https://example.com/supreme-court-data-privacy",
    ),
    LegalNewsItem(
      id: "news_002",
      title: "New Environmental Regulations Announced",
      description:
          "The government announced new regulations aimed at reducing carbon emissions across various industries.",
      category: "Environmental Law",
      publicationDate: DateTime.parse("2023-09-15"),
      sourceUrl: "https://example.com/new-environmental-regulations",
    ),
    LegalNewsItem(
      id: "news_003",
      title: "Changes to Employment Law Passed",
      description:
          "Legislation has been passed to enhance protections for gig economy workers in several states.",
      category: "Employment Law",
      publicationDate: DateTime.parse("2023-08-30"),
      sourceUrl: "https://example.com/employment-law-changes",
    ),
    LegalNewsItem(
      id: "news_004",
      title: "Cybersecurity Bill Signed into Law",
      description:
          "A new cybersecurity bill has been signed into law, establishing stricter requirements for data protection.",
      category: "Cybersecurity",
      publicationDate: DateTime.parse("2023-07-20"),
      sourceUrl: "https://example.com/cybersecurity-bill",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return DefaultTabController(
      length: newsItems.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'Legal News',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs: newsItems.map((news) => Tab(text: news.title)).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: Container(
          color: themeData.isDarkMode ? Colors.black : Colors.white,
          child: TabBarView(
            children: newsItems.map((news) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        Text(
                          news.description,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow("Category:", news.category),
                        _buildDetailRow("Published on:",
                            "${news.publicationDate.toLocal()}".split(' ')[0]),
                        const SizedBox(height: 20),
                        const Text(
                          "Source:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        InkWell(
                          onTap: () => _launchURL(news.sourceUrl),
                          child: Text(
                            news.sourceUrl,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                themeData.isDarkMode ? Colors.deepPurpleAccent : Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
