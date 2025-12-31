import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online_kachehari/models/advocate_model.dart';
import 'package:flutter_online_kachehari/models/service_model.dart';

/// Service for handling search operations
/// Supports both Firestore and local JSON data
class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache for better performance
  List<AdvocateModel>? _cachedAdvocates;
  List<ServiceModel>? _cachedServices;
  DateTime? _lastCacheTime;

  // Cache duration: 5 minutes
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Search advocates by query
  /// Searches in: name, specialization, languages, education
  Future<List<AdvocateModel>> searchAdvocates(String query) async {
    if (query.isEmpty) return [];

    try {
      // Try Firestore first
      final firestoreResults = await _searchAdvocatesFromFirestore(query);
      if (firestoreResults.isNotEmpty) {
        return firestoreResults;
      }

      // Fallback to JSON data
      return await _searchAdvocatesFromJson(query);
    } catch (e) {
      print('Error searching advocates: $e');
      // Fallback to JSON on error
      try {
        return await _searchAdvocatesFromJson(query);
      } catch (jsonError) {
        print('Error loading from JSON: $jsonError');
        return [];
      }
    }
  }

  /// Search advocates from Firestore
  Future<List<AdvocateModel>> _searchAdvocatesFromFirestore(
      String query) async {
    final lowerQuery = query.toLowerCase().trim();

    try {
      // Search by name (case-insensitive)
      final nameQuery = await _firestore
          .collection('Advocates')
          .where('nameLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('nameLower', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(20)
          .get();

      // Search by specialization
      final specializationQuery = await _firestore
          .collection('Advocates')
          .where('specializationLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('specializationLower',
              isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(20)
          .get();

      // Combine results and remove duplicates
      final Set<String> seenIds = {};
      final List<AdvocateModel> results = [];

      for (var doc in [...nameQuery.docs, ...specializationQuery.docs]) {
        if (!seenIds.contains(doc.id)) {
          seenIds.add(doc.id);
          results.add(AdvocateModel.fromFirestore(doc.data(), doc.id));
        }
      }

      return results;
    } catch (e) {
      print('Firestore search error: $e');
      return [];
    }
  }

  /// Search advocates from local JSON file
  Future<List<AdvocateModel>> _searchAdvocatesFromJson(String query) async {
    // Use cache if available and fresh
    if (_cachedAdvocates != null && _isCacheValid()) {
      return _filterAdvocates(_cachedAdvocates!, query);
    }

    try {
      final String response =
          await rootBundle.loadString('assets/json/advocate.json');
      final List<dynamic> data = json.decode(response);

      _cachedAdvocates = data.asMap().entries.map((entry) {
        return AdvocateModel.fromJson(
          entry.value as Map<String, dynamic>,
          entry.key.toString(),
        );
      }).toList();

      _lastCacheTime = DateTime.now();

      return _filterAdvocates(_cachedAdvocates!, query);
    } catch (e) {
      print('Error loading advocates from JSON: $e');
      return [];
    }
  }

  /// Filter advocates by query
  List<AdvocateModel> _filterAdvocates(
      List<AdvocateModel> advocates, String query) {
    if (query.isEmpty) return advocates;

    final lowerQuery = query.toLowerCase().trim();
    return advocates
        .where((advocate) => advocate.matchesQuery(lowerQuery))
        .toList();
  }

  /// Search services by query
  Future<List<ServiceModel>> searchServices(String query) async {
    if (query.isEmpty) return [];

    try {
      // Try Firestore first
      final firestoreResults = await _searchServicesFromFirestore(query);
      if (firestoreResults.isNotEmpty) {
        return firestoreResults;
      }

      // Fallback to JSON data
      return await _searchServicesFromJson(query);
    } catch (e) {
      print('Error searching services: $e');
      // Fallback to JSON on error
      try {
        return await _searchServicesFromJson(query);
      } catch (jsonError) {
        print('Error loading from JSON: $jsonError');
        return [];
      }
    }
  }

  /// Search services from Firestore
  Future<List<ServiceModel>> _searchServicesFromFirestore(String query) async {
    final lowerQuery = query.toLowerCase().trim();

    try {
      final querySnapshot = await _firestore
          .collection('Services')
          .where('titleLower', isGreaterThanOrEqualTo: lowerQuery)
          .where('titleLower', isLessThanOrEqualTo: '$lowerQuery\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => ServiceModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Firestore service search error: $e');
      return [];
    }
  }

  /// Search services from local JSON file
  Future<List<ServiceModel>> _searchServicesFromJson(String query) async {
    // Use cache if available and fresh
    if (_cachedServices != null && _isCacheValid()) {
      return _filterServices(_cachedServices!, query);
    }

    try {
      final String response =
          await rootBundle.loadString('assets/json/services.json');
      final List<dynamic> data = json.decode(response);

      _cachedServices = data.asMap().entries.map((entry) {
        return ServiceModel.fromJson(
          entry.value as Map<String, dynamic>,
          entry.key.toString(),
        );
      }).toList();

      _lastCacheTime = DateTime.now();

      return _filterServices(_cachedServices!, query);
    } catch (e) {
      print('Error loading services from JSON: $e');
      return [];
    }
  }

  /// Filter services by query
  List<ServiceModel> _filterServices(
      List<ServiceModel> services, String query) {
    if (query.isEmpty) return services;

    final lowerQuery = query.toLowerCase().trim();
    return services
        .where((service) => service.matchesQuery(lowerQuery))
        .toList();
  }

  /// Get all advocates (for browsing)
  Future<List<AdvocateModel>> getAllAdvocates() async {
    try {
      // Try Firestore first
      final querySnapshot = await _firestore
          .collection('Advocates')
          .orderBy('name')
          .limit(50)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => AdvocateModel.fromFirestore(doc.data(), doc.id))
            .toList();
      }

      // Fallback to JSON
      return await _searchAdvocatesFromJson('');
    } catch (e) {
      print('Error getting all advocates: $e');
      return await _searchAdvocatesFromJson('');
    }
  }

  /// Get all services (for browsing)
  Future<List<ServiceModel>> getAllServices() async {
    try {
      // Try Firestore first
      final querySnapshot =
          await _firestore.collection('Services').orderBy('title').get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => ServiceModel.fromFirestore(doc.data(), doc.id))
            .toList();
      }

      // Fallback to JSON
      return await _searchServicesFromJson('');
    } catch (e) {
      print('Error getting all services: $e');
      return await _searchServicesFromJson('');
    }
  }

  /// Check if cache is still valid
  bool _isCacheValid() {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheDuration;
  }

  /// Clear cache (useful for refresh)
  void clearCache() {
    _cachedAdvocates = null;
    _cachedServices = null;
    _lastCacheTime = null;
  }

  /// Get search suggestions based on recent searches or popular items
  Future<List<String>> getSearchSuggestions(String query) async {
    if (query.isEmpty) {
      return [
        'Criminal Law',
        'Corporate Law',
        'Family Law',
        'Property Law',
        'Legal Notice',
        'Document Drafting',
        'Court Representation',
      ];
    }

    // Get matching advocates and services
    final advocates = await searchAdvocates(query);
    final services = await searchServices(query);

    List<String> suggestions = [];
    suggestions.addAll(advocates.take(3).map((a) => a.name));
    suggestions.addAll(services.take(3).map((s) => s.title));

    return suggestions.take(6).toList();
  }
}
