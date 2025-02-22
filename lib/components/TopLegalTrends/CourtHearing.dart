import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class CourtHearing {
  final String id;
  final String caseTitle;
  final String description;
  final String court;
  final DateTime hearingDate;
  final String hearingTime;
  final List<String> involvedParties;
  final String caseNumber;
  final String judgeName;
  final String outcome;
  final String verdictDetails;

  CourtHearing({
    required this.id,
    required this.caseTitle,
    required this.description,
    required this.court,
    required this.hearingDate,
    required this.hearingTime,
    required this.involvedParties,
    required this.caseNumber,
    required this.judgeName,
    required this.outcome,
    required this.verdictDetails,
  });
}

class CourtHearings extends StatefulWidget {
  const CourtHearings({super.key});

  @override
  State<CourtHearings> createState() => _CourtHearingsState();
}

class _CourtHearingsState extends State<CourtHearings> {
  final List<CourtHearing> hearings = [
    CourtHearing(
      id: "hearing_001",
      caseTitle: "Vishal vs. State of Maharashtra",
      description:
          "Hearing regarding a property dispute.This hearing pertains to a property dispute between Vishal Sharma and the State of Maharashtra. It likely involves legal arguments regarding ownership, property rights, or land use, possibly involving issues such as zoning, inheritance, or contracts.",
      court: "Bombay High Court",
      hearingDate: DateTime.parse("2023-11-10"),
      hearingTime: "11:00 AM",
      involvedParties: ["Vishal Sharma", "State of Maharashtra"],
      caseNumber: "BHC1234",
      judgeName: "Justice A.B.Patel",
      outcome: "Pending",
      verdictDetails: "N/A",
    ),
    // Add more hearings as needed...
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    var themeData = Provider.of<ThemeProviderState>(context);

    return DefaultTabController(
      length: hearings.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            'Court Hearings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            isScrollable: true,
            tabs: hearings
                .map((hearing) => Tab(text: hearing.caseTitle))
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
            children: hearings.map((hearing) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 10.0 : 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hearing.caseTitle,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        const Divider(height: 30, thickness: 1),
                        Text(
                          hearing.description,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            color: themeData.isDarkMode
                                ? Colors.white
                                : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow("Court:", hearing.court, isSmallScreen),
                        _buildDetailRow(
                            "Hearing Date:",
                            "${hearing.hearingDate.toLocal()}".split(' ')[0],
                            isSmallScreen),
                        _buildDetailRow("Hearing Time:", hearing.hearingTime,
                            isSmallScreen),
                        _buildDetailRow("Involved Parties:",
                            hearing.involvedParties.join(', '), isSmallScreen),
                        _buildDetailRow(
                            "Case Number:", hearing.caseNumber, isSmallScreen),
                        _buildDetailRow(
                            "Judge:", hearing.judgeName, isSmallScreen),
                        _buildDetailRow(
                            "Outcome:", hearing.outcome, isSmallScreen),
                        _buildDetailRow("Verdict Details:",
                            hearing.verdictDetails, isSmallScreen),
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

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}
