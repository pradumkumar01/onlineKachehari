import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:provider/provider.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Service> services = [
    Service(
      title: "Legal Consultation",
      description: "Expert legal advice tailored to your needs.",
      imageUrl: "assets/services/legal_consultation.jpg",
      isFavorite: false,
    ),
    Service(
      title: "Document Drafting",
      description: "Get professional help with your legal documents.",
      imageUrl: "assets/services/document_drafting.jpg",
      isFavorite: false,
    ),
    Service(
      title: "Court Representation",
      description: "Professional representation for your court cases.",
      imageUrl: "assets/services/court_representation.jpg",
      isFavorite: false,
    ),
    Service(
      title: "Case Review",
      description: "Thorough review of your legal case by experts.",
      imageUrl: "assets/services/case_review.jpg",
      isFavorite: false,
    ),
    Service(
      title: "Notary Services",
      description: "Secure and reliable notarization services.",
      imageUrl: "assets/services/notary_services.jpg",
      isFavorite: false,
    ),
  ];

  void toggleFavorite(int index) {
    setState(() {
      services[index].isFavorite = !services[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Services',
            style: TextStyle(
                fontFamily: 'serif',
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Implement search feature here
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add functionality to refresh services
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            double aspectRatio = constraints.maxWidth > 600 ? 0.6 : 0.75;

            return Container(
              color: themeData.isDarkMode ? Colors.black : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    return ServiceCard(
                      service: services[index],
                      onFavoriteToggle: () => toggleFavorite(index),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Service({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onFavoriteToggle;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);
    return GestureDetector(
      onTap: () {
        // Navigate to a service details page
      },
      child: Card(
        color: themeData.isDarkMode ? Colors.white : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 6,
        shadowColor:
            themeData.isDarkMode ? Colors.white : Colors.black.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      service.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: service.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                service.description,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Limit description lines
              ),
            ),
          ],
        ),
      ),
    );
  }
}
