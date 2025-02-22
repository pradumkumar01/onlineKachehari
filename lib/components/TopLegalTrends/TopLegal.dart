import 'package:flutter/material.dart';

class LegalTrend {
  final String id;
  final String title;
  final String description;
  final String category;
  final String subCategory;
  final List<String> regions;
  final List<String> specificCountries;
  final DateTime startDate;
  final DateTime endDate;
  final List<DataSource> dataSources;
  final int totalCases;
  final Map<String, int> yearlyBreakdown;
  final Map<String, int> jurisdictionBreakdown;
  final List<Legislation> relatedLegislation;
  final List<String> implications;
  final List<String> observations;

  LegalTrend({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.regions,
    required this.specificCountries,
    required this.startDate,
    required this.endDate,
    required this.dataSources,
    required this.totalCases,
    required this.yearlyBreakdown,
    required this.jurisdictionBreakdown,
    required this.relatedLegislation,
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

class Legislation {
  final String title;
  final DateTime effectiveDate;
  final String description;

  Legislation({
    required this.title,
    required this.effectiveDate,
    required this.description,
  });
}

class TopLegal extends StatefulWidget {
  const TopLegal({super.key});

  @override
  _TopLegalState createState() => _TopLegalState();
}

class _TopLegalState extends State<TopLegal> {
  final List<LegalTrend> trends = [
    LegalTrend(
      id: "trend_001",
      title: "Increase in Data Privacy Litigation",
      description:
          "A noticeable rise in lawsuits related to data privacy violations.",
      category: "Litigation",
      subCategory: "Data Privacy",
      regions: ["North America", "Europe"],
      specificCountries: ["USA", "UK", "Germany"],
      startDate: DateTime.parse("2022-01-01"),
      endDate: DateTime.parse("2024-01-01"),
      dataSources: [
        DataSource(
          sourceName: "Legal Analytics Database",
          url: "https://example.com/legal-analytics",
          dataCollected: "Number of cases filed",
        ),
      ],
      totalCases: 1500,
      yearlyBreakdown: {
        "2022": 400,
        "2023": 700,
        "2024": 400,
      },
      jurisdictionBreakdown: {
        "USA": 1000,
        "UK": 300,
        "Germany": 200,
      },
      relatedLegislation: [
        Legislation(
          title: "GDPR",
          effectiveDate: DateTime.parse("2018-05-25"),
          description: "General Data Protection Regulation in the EU.",
        ),
      ],
      implications: [
        "Increased compliance costs for businesses.",
        "Emergence of new legal firms specializing in data privacy.",
      ],
      observations: [
        "Firms are adopting more robust data management practices.",
        "Public awareness about data privacy rights is rising.",
      ],
    ),
    LegalTrend(
      id: "trend_002",
      title: "Rise of Remote Work Employment Laws",
      description:
          "New legislation addressing remote work rights and responsibilities.",
      category: "Employment Law",
      subCategory: "Remote Work",
      regions: ["Global"],
      specificCountries: ["USA", "Canada", "Australia"],
      startDate: DateTime.parse("2021-01-01"),
      endDate: DateTime.parse("2024-01-01"),
      dataSources: [
        DataSource(
          sourceName: "Remote Work Survey",
          url: "https://example.com/remote-work-survey",
          dataCollected: "Employee experiences and feedback",
        ),
      ],
      totalCases: 800,
      yearlyBreakdown: {
        "2021": 200,
        "2022": 300,
        "2023": 300,
      },
      jurisdictionBreakdown: {
        "USA": 500,
        "Canada": 200,
        "Australia": 100,
      },
      relatedLegislation: [
        Legislation(
          title: "Workplace Safety Act",
          effectiveDate: DateTime.parse("2022-03-15"),
          description: "Legislation ensuring safety for remote workers.",
        ),
      ],
      implications: [
        "Employers need to adapt policies for remote work.",
        "New compliance challenges regarding employee rights.",
      ],
      observations: [
        "Companies are investing in remote work technology.",
        "Employee satisfaction is linked to flexible work arrangements.",
      ],
    ),
    LegalTrend(
      id: "trend_003",
      title: "Growth of Cybersecurity Regulations",
      description:
          "An increase in laws aimed at enhancing cybersecurity practices across industries.",
      category: "Regulation",
      subCategory: "Cybersecurity",
      regions: ["Global"],
      specificCountries: ["USA", "EU", "India"],
      startDate: DateTime.parse("2021-01-01"),
      endDate: DateTime.parse("2024-01-01"),
      dataSources: [
        DataSource(
          sourceName: "Cybersecurity Compliance Reports",
          url: "https://example.com/cybersecurity-reports",
          dataCollected: "Compliance rates and breach reports",
        ),
      ],
      totalCases: 1200,
      yearlyBreakdown: {
        "2021": 300,
        "2022": 400,
        "2023": 500,
      },
      jurisdictionBreakdown: {
        "USA": 700,
        "EU": 400,
        "India": 100,
      },
      relatedLegislation: [
        Legislation(
          title: "Cybersecurity Information Sharing Act",
          effectiveDate: DateTime.parse("2022-06-30"),
          description:
              "Facilitates sharing of cybersecurity threat information.",
        ),
      ],
      implications: [
        "Increased investment in cybersecurity measures.",
        "Emergence of new roles focused on compliance.",
      ],
      observations: [
        "Companies are experiencing more data breaches.",
        "Regulatory fines are on the rise.",
      ],
    ),
    LegalTrend(
      id: "trend_004",
      title: "Expansion of Environmental Laws",
      description:
          "Growing number of regulations aimed at protecting the environment.",
      category: "Environmental Law",
      subCategory: "Sustainability",
      regions: ["Global"],
      specificCountries: ["USA", "Germany", "Japan"],
      startDate: DateTime.parse("2020-01-01"),
      endDate: DateTime.parse("2024-01-01"),
      dataSources: [
        DataSource(
          sourceName: "Environmental Protection Agency",
          url: "https://example.com/epa-reports",
          dataCollected: "Compliance data and reports",
        ),
      ],
      totalCases: 900,
      yearlyBreakdown: {
        "2020": 200,
        "2021": 300,
        "2022": 400,
      },
      jurisdictionBreakdown: {
        "USA": 500,
        "Germany": 300,
        "Japan": 100,
      },
      relatedLegislation: [
        Legislation(
          title: "Clean Air Act",
          effectiveDate: DateTime.parse("1970-12-31"),
          description:
              "Regulates air emissions from stationary and mobile sources.",
        ),
      ],
      implications: [
        "Increased regulatory scrutiny on businesses.",
        "Higher costs for compliance and reporting.",
      ],
      observations: [
        "Public demand for sustainability is increasing.",
        "More litigation related to environmental damages.",
      ],
    ),
    LegalTrend(
      id: "trend_005",
      title: "Evolving Intellectual Property Rights",
      description:
          "Changes in IP laws addressing digital content and technology advancements.",
      category: "Intellectual Property",
      subCategory: "IP Law",
      regions: ["Global"],
      specificCountries: ["USA", "EU", "China"],
      startDate: DateTime.parse("2021-01-01"),
      endDate: DateTime.parse("2024-01-01"),
      dataSources: [
        DataSource(
          sourceName: "Intellectual Property Office",
          url: "https://example.com/ip-office",
          dataCollected: "IP registrations and disputes",
        ),
      ],
      totalCases: 600,
      yearlyBreakdown: {
        "2021": 100,
        "2022": 200,
        "2023": 300,
      },
      jurisdictionBreakdown: {
        "USA": 300,
        "EU": 200,
        "China": 100,
      },
      relatedLegislation: [
        Legislation(
          title: "Copyright Act",
          effectiveDate: DateTime.parse("1976-01-01"),
          description: "Establishes copyright laws for creative works.",
        ),
      ],
      implications: [
        "More litigation around copyright issues.",
        "Increased focus on protecting digital content.",
      ],
      observations: [
        "Companies are investing in IP protection.",
        "Rise in online piracy concerns.",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: trends.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'Top Legal Trends',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs: trends.map((trend) => Tab(text: trend.title)).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: TabBarView(
          children: trends.map((trend) {
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
                            trend.title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const Divider(height: 30, thickness: 1),
                          Text(
                            trend.description,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildDetailRow("Category:", trend.category),
                          _buildDetailRow("Subcategory:", trend.subCategory),
                          _buildDetailRow("Regions:", trend.regions.join(', ')),
                          _buildDetailRow("Specific Countries:",
                              trend.specificCountries.join(', ')),
                          const SizedBox(height: 20),
                          const Text(
                            "Yearly Breakdown:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...trend.yearlyBreakdown.entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      "${entry.key}: ${entry.value}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600]),
                                    ),
                                  )),
                          const SizedBox(height: 20),
                          const Text(
                            "Implications:",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...trend.implications.map((implication) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "- $implication",
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
