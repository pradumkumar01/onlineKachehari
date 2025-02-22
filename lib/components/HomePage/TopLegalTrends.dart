import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/CaseStudies.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/CourtHearing.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/LawUpdates.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/LegalNews.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/NewAmendments.dart';
import 'package:flutter_online_kachehari/components/TopLegalTrends/TopLegal.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class TopLegalTrends extends StatefulWidget {
  const TopLegalTrends({super.key});

  @override
  State<TopLegalTrends> createState() => _TopLegalTrendsState();
}

class _TopLegalTrendsState extends State<TopLegalTrends> {
  // Fake data for Top Trending items
  final List<Map<String, dynamic>> trendingItems = [
    {
      'icon': Icons.trending_up,
      'title': 'Law Updates',
      'navigation': (context) => const LawUpdates(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Legal News',
      'navigation': (context) => const LegalNews(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Court Hearings',
      'navigation': (context) => const CourtHearings(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Case Studies',
      'navigation': (context) => const CaseStudies(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'New Amendments',
      'navigation': (context) => const NewAmendments(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return SizedBox(
      height: 161,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trendingItems.length,
        separatorBuilder: (context, index) {
          return const Padding(padding: EdgeInsets.only(right: 0));
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  trendingItems[index]["navigation"](context),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.deepPurple[100],
                            child: Icon(trendingItems[index]['icon'],
                                size: 30, color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        trendingItems[index]['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: themeData.isDarkMode
                              ? Colors.deepPurpleAccent
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              trendingItems[index]["navigation"](context),
                        ),
                      );
                    },
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color:
                            themeData.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
