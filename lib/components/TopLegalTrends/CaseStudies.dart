import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class CaseStudy {
  final String id;
  final String caseTitle;
  final String description;
  final List<String> involvedParties;
  final String caseNumber;
  final String judgeName;
  final String outcome;
  final String verdictDetails;
  final DateTime studyDate;

  CaseStudy({
    required this.id,
    required this.caseTitle,
    required this.description,
    required this.involvedParties,
    required this.caseNumber,
    required this.judgeName,
    required this.outcome,
    required this.verdictDetails,
    required this.studyDate,
  });
}

class CaseStudies extends StatefulWidget {
  const CaseStudies({super.key});

  @override
  State<CaseStudies> createState() => _CaseStudiesState();
}

class _CaseStudiesState extends State<CaseStudies> {
  final List<CaseStudy> caseStudies = [
    CaseStudy(
      id: "case_001",
      caseTitle: "Land Acquisition Dispute",
      description:
          "A study on the legal aspects of land acquisition by the government.",
      involvedParties: ["Government", "Landowners"],
      caseNumber: "LA1234",
      judgeName: "Justice R. S. Sharma",
      outcome: "Pending",
      verdictDetails: "N/A",
      studyDate: DateTime.parse("2023-05-01"),
    ),
    CaseStudy(
      id: "case_002",
      caseTitle: "Consumer Rights Protection",
      description:
          "A case study on consumer rights violations and legal remedies.",
      involvedParties: ["Consumer", "Retailer"],
      caseNumber: "CRP5678",
      judgeName: "Judge P. K. Verma",
      outcome: "Resolved",
      verdictDetails: "In favor of the consumer.",
      studyDate: DateTime.parse("2023-07-15"),
    ),
    CaseStudy(
      id: "case_003",
      caseTitle: "Intellectual Property Theft",
      description: "Examining a case of IP theft involving a tech startup.",
      involvedParties: ["Tech Startup", "Competitor"],
      caseNumber: "IPT9012",
      judgeName: "Justice M. N. Rao",
      outcome: "Pending",
      verdictDetails: "N/A",
      studyDate: DateTime.parse("2023-08-20"),
    ),
    CaseStudy(
      id: "case_004",
      caseTitle: "Labor Dispute Resolution",
      description:
          "Analysis of a labor dispute between employees and management.",
      involvedParties: ["Employees", "Company Management"],
      caseNumber: "LD3456",
      judgeName: "Judge A. S. Mehta",
      outcome: "Settled",
      verdictDetails: "Agreed on compensation for employees.",
      studyDate: DateTime.parse("2023-09-10"),
    ),
    CaseStudy(
      id: "case_005",
      caseTitle: "Environmental Regulations Compliance",
      description: "A study on compliance with new environmental regulations.",
      involvedParties: ["Corporation", "Environmental Agency"],
      caseNumber: "ERC7890",
      judgeName: "Justice L. K. Bansal",
      outcome: "Pending",
      verdictDetails: "N/A",
      studyDate: DateTime.parse("2023-10-01"),
    ),
    CaseStudy(
      id: "case_006",
      caseTitle: "Marriage and Divorce Law",
      description: "Exploring legal aspects surrounding marriage and divorce.",
      involvedParties: ["Husband", "Wife"],
      caseNumber: "MD1122",
      judgeName: "Judge S. R. Gupta",
      outcome: "Pending",
      verdictDetails: "N/A",
      studyDate: DateTime.parse("2023-11-05"),
    ),
    CaseStudy(
      id: "case_007",
      caseTitle: "Cyber Crime Case",
      description: "Analyzing a case of cyberbullying and harassment.",
      involvedParties: ["Victim", "Accused"],
      caseNumber: "CC3344",
      judgeName: "Justice K. P. Jain",
      outcome: "Pending",
      verdictDetails: "N/A",
      studyDate: DateTime.parse("2023-11-15"),
    ),
    CaseStudy(
      id: "case_008",
      caseTitle: "Discrimination in Employment",
      description: "Case study on discrimination claims in hiring practices.",
      involvedParties: ["Applicant", "Company"],
      caseNumber: "DE5566",
      judgeName: "Judge R. N. Choudhary",
      outcome: "Resolved",
      verdictDetails: "Company to revise hiring policies.",
      studyDate: DateTime.parse("2023-09-25"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return DefaultTabController(
      length: caseStudies.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            'Case Studies',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs:
                caseStudies.map((study) => Tab(text: study.caseTitle)).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
          ),
        ),
        body: Container(
          color: themeData.isDarkMode ? Colors.black : Colors.white,
          child: TabBarView(
            children: caseStudies.map((study) {
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
                          study.caseTitle,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        Text(
                          study.description,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow("Involved Parties:",
                            study.involvedParties.join(', ')),
                        _buildDetailRow("Case Number:", study.caseNumber),
                        _buildDetailRow("Judge Name:", study.judgeName),
                        _buildDetailRow("Outcome:", study.outcome),
                        _buildDetailRow(
                            "Verdict Details:", study.verdictDetails),
                        _buildDetailRow("Study Date:",
                            "${study.studyDate.toLocal()}".split(' ')[0]),
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
