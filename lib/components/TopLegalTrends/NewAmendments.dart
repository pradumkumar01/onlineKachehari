import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class Amendment {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime effectiveDate;
  final String details;

  Amendment({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.effectiveDate,
    required this.details,
  });
}

class NewAmendments extends StatefulWidget {
  const NewAmendments({super.key});

  @override
  State<NewAmendments> createState() => _NewAmendmentsState();
}

class _NewAmendmentsState extends State<NewAmendments> {
  final List<Amendment> amendments = [
    Amendment(
      id: "amendment_001",
      title: "Amendment to the Right to Information Act",
      description:
          "Enhances provisions for transparency in governance, allowing citizens greater access to information.",
      category: "Government",
      effectiveDate: DateTime.parse("2023-06-01"),
      details:
          "This amendment increases the penalties for public authorities that fail to provide requested information under the RTI Act. It also mandates timely responses and establishes stricter oversight mechanisms to ensure compliance.",
    ),
    Amendment(
      id: "amendment_002",
      title: "Amendment to the Industrial Disputes Act",
      description:
          "Strengthens workers' rights and provides new mechanisms for resolving industrial disputes effectively.",
      category: "Labor Law",
      effectiveDate: DateTime.parse("2023-08-15"),
      details:
          "The amendment introduces mandatory mediation and arbitration processes for resolving disputes before they escalate to strikes or lockouts. It also enhances job security for workers and promotes fair wages.",
    ),
    Amendment(
      id: "amendment_003",
      title: "Amendment to the Environmental Protection Act",
      description:
          "Revises regulations for pollution control and emphasizes sustainable practices in industrial operations.",
      category: "Environmental Law",
      effectiveDate: DateTime.parse("2023-09-20"),
      details:
          "The amendment imposes stricter penalties for environmental violations, including hefty fines and operational shutdowns for non-compliance. It encourages industries to adopt green technologies and practices to reduce their ecological footprint.",
    ),
    Amendment(
      id: "amendment_004",
      title: "Amendment to the Consumer Protection Act",
      description:
          "Enhances consumer rights and protection measures in the context of e-commerce and digital transactions.",
      category: "Consumer Rights",
      effectiveDate: DateTime.parse("2023-10-01"),
      details:
          "This amendment introduces provisions for consumer redressal in online transactions, ensuring that consumers have access to fair practices. It mandates transparency in advertising and prohibits misleading information in product descriptions.",
    ),
    Amendment(
      id: "amendment_005",
      title: "Amendment to the Juvenile Justice Act",
      description:
          "Strengthens provisions for juvenile rehabilitation, emphasizing reintegration into society.",
      category: "Juvenile Justice",
      effectiveDate: DateTime.parse("2023-11-01"),
      details:
          "The amendment focuses on creating a supportive environment for juvenile offenders by enhancing rehabilitation programs. It includes provisions for mental health support, vocational training, and family counseling to aid reintegration.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return DefaultTabController(
      length: amendments.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'New Amendments',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs: amendments
                .map((amendment) => Tab(text: amendment.title))
                .toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: Container(
          color: themeData.isDarkMode ? Colors.black : Colors.white,
          child: TabBarView(
            children: amendments.map((amendment) {
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
                          amendment.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        Text(
                          amendment.description,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow("Category:", amendment.category),
                        _buildDetailRow(
                            "Effective Date:",
                            "${amendment.effectiveDate.toLocal()}"
                                .split(' ')[0]),
                        const SizedBox(height: 20),
                        const Text(
                          "Details:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          amendment.details,
                          style: TextStyle(
                            fontSize: 16,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.grey[600],
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
            style: TextStyle(
                fontSize: 16,
                color:
                    themeData.isDarkMode ? Colors.white70 : Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
