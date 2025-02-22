import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class LawUpdate {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subCategory;
  final List<String> regions;
  final List<String> specificCountries;
  final DateTime effectiveDate;
  final List<DataSource> dataSources;
  final List<String> implications;
  final List<String> observations;

  LawUpdate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.regions,
    required this.specificCountries,
    required this.effectiveDate,
    required this.dataSources,
    required this.implications,
    required this.observations,
  });
}

class DataSource {
  final String sourceName;
  final String url;
  final String dataCollected;

  DataSource({
    required this.sourceName,
    required this.url,
    required this.dataCollected,
  });
}

class LawUpdates extends StatefulWidget {
  const LawUpdates({super.key});

  @override
  State<LawUpdates> createState() => _LawUpdatesState();
}

class _LawUpdatesState extends State<LawUpdates> {
  final List<LawUpdate> updates = [
    LawUpdate(
      id: "update_001",
      title: "New Data Protection Regulation",
      description:
          "A new regulation enhancing data protection rights for individuals.",
      category: "Data Protection",
      subCategory: "Privacy Law",
      regions: ["Europe"],
      specificCountries: ["EU"],
      effectiveDate: DateTime.parse("2023-05-01"),
      dataSources: [
        DataSource(
          sourceName: "European Commission",
          url: "https://example.com/eu-data-regulation",
          dataCollected: "Regulatory updates and compliance guidelines",
        ),
      ],
      implications: [
        "Businesses must enhance their data management practices.",
        "Increased penalties for non-compliance.",
      ],
      observations: [
        "Companies are investing more in data privacy technologies.",
        "Public awareness of data protection is increasing.",
      ],
    ),
    LawUpdate(
      id: "update_002",
      title: "Changes to Employment Law",
      description:
          "Revisions to employment law affecting remote work policies.",
      category: "Employment Law",
      subCategory: "Remote Work",
      regions: ["USA"],
      specificCountries: ["USA"],
      effectiveDate: DateTime.parse("2023-07-15"),
      dataSources: [
        DataSource(
          sourceName: "Department of Labor",
          url: "https://example.com/us-employment-law",
          dataCollected: "Employment law updates and guidance",
        ),
      ],
      implications: [
        "Employers must revise remote work policies to comply.",
        "Increased protections for remote workers.",
      ],
      observations: [
        "Companies are adapting to hybrid work environments.",
        "Employee feedback is shaping new workplace policies.",
      ],
    ),
    LawUpdate(
      id: "update_003",
      title: "New Environmental Protection Act",
      description: "Introduction of new measures to combat climate change.",
      category: "Environmental Law",
      subCategory: "Climate Change",
      regions: ["Global"],
      specificCountries: ["USA", "EU", "Australia"],
      effectiveDate: DateTime.parse("2023-09-01"),
      dataSources: [
        DataSource(
          sourceName: "Environmental Protection Agency",
          url: "https://example.com/epa-updates",
          dataCollected: "Legislation on environmental standards",
        ),
      ],
      implications: [
        "Stricter regulations on emissions for companies.",
        "Incentives for sustainable practices.",
      ],
      observations: [
        "Corporate sustainability is becoming a priority.",
        "Public demand for accountability is rising.",
      ],
    ),
    LawUpdate(
      id: "update_004",
      title: "Cybersecurity Legislation Update",
      description: "New cybersecurity laws aimed at protecting consumer data.",
      category: "Cybersecurity",
      subCategory: "Data Security",
      regions: ["USA"],
      specificCountries: ["USA"],
      effectiveDate: DateTime.parse("2023-10-01"),
      dataSources: [
        DataSource(
          sourceName: "Cybersecurity & Infrastructure Security Agency",
          url: "https://example.com/cybersecurity-update",
          dataCollected: "Cybersecurity legislation and guidelines",
        ),
      ],
      implications: [
        "Increased responsibility for businesses to safeguard data.",
        "Mandatory reporting of data breaches.",
      ],
      observations: [
        "Companies are enhancing their cybersecurity measures.",
        "Consumer awareness of data protection is rising.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return DefaultTabController(
      length: updates.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'Law Updates',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs: updates.map((update) => Tab(text: update.title)).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: Container(
          color: themeData.isDarkMode ? Colors.black : Colors.white,
          child: TabBarView(
            children: updates.map((update) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              update.title,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                            const Divider(height: 30, thickness: 1),
                            Text(
                              update.description,
                              style: TextStyle(
                                fontSize: 18,
                                color: themeData.isDarkMode
                                    ? Colors.white
                                    : Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildDetailRow("Category:", update.category),
                            _buildDetailRow("Subcategory:", update.subCategory),
                            _buildDetailRow(
                                "Regions:", update.regions.join(', ')),
                            _buildDetailRow("Specific Countries:",
                                update.specificCountries.join(', ')),
                            _buildDetailRow(
                                "Effective Date:",
                                "${update.effectiveDate.toLocal()}"
                                    .split(' ')[0]),
                            const SizedBox(height: 20),
                            Text(
                              "Implications:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeData.isDarkMode
                                    ? Colors.deepPurpleAccent
                                    : Colors.black,
                              ),
                            ),
                            ...update.implications.map((implication) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "- $implication",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            Text(
                              "Observations:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: themeData.isDarkMode
                                    ? Colors.deepPurpleAccent
                                    : Colors.black,
                              ),
                            ),
                            ...update.observations.map((observation) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "- $observation",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600]),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
            color: themeData.isDarkMode ? Colors.deepPurpleAccent : Colors.grey,
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
}
