import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online_kachehari/models/advocate_model.dart';
import 'package:flutter_online_kachehari/models/service_model.dart';

/// Utility class to migrate data from JSON files to Firestore
/// Run this once to populate your Firestore database
class DataMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Migrate advocates from JSON to Firestore
  /// This should be run once during app setup or from an admin panel
  Future<void> migrateAdvocatesToFirestore() async {
    try {
      print('Starting advocates migration...');

      // Load JSON data
      final String response =
          await rootBundle.loadString('assets/json/advocate.json');
      final List<dynamic> data = json.decode(response);

      // Batch write for better performance
      WriteBatch batch = _firestore.batch();
      int count = 0;

      for (var item in data) {
        final advocate = AdvocateModel.fromJson(
          item as Map<String, dynamic>,
          _firestore.collection('Advocates').doc().id,
        );

        // Create document reference
        final docRef = _firestore.collection('Advocates').doc(advocate.id);

        // Add to batch
        batch.set(docRef, advocate.toFirestore());
        count++;

        // Firestore batch limit is 500 operations
        if (count % 500 == 0) {
          await batch.commit();
          batch = _firestore.batch();
          print('Migrated $count advocates...');
        }
      }

      // Commit remaining operations
      if (count % 500 != 0) {
        await batch.commit();
      }

      print('✅ Successfully migrated $count advocates to Firestore');
    } catch (e) {
      print('❌ Error migrating advocates: $e');
      rethrow;
    }
  }

  /// Migrate services from JSON to Firestore
  Future<void> migrateServicesToFirestore() async {
    try {
      print('Starting services migration...');

      // Load JSON data
      final String response =
          await rootBundle.loadString('assets/json/services.json');
      final List<dynamic> data = json.decode(response);

      // Batch write for better performance
      WriteBatch batch = _firestore.batch();
      int count = 0;

      for (var item in data) {
        final service = ServiceModel.fromJson(
          item as Map<String, dynamic>,
          _firestore.collection('Services').doc().id,
        );

        // Create document reference
        final docRef = _firestore.collection('Services').doc(service.id);

        // Add to batch
        batch.set(docRef, service.toFirestore());
        count++;
      }

      // Commit batch
      await batch.commit();

      print('✅ Successfully migrated $count services to Firestore');
    } catch (e) {
      print('❌ Error migrating services: $e');
      rethrow;
    }
  }

  /// Migrate all data at once
  Future<void> migrateAllData() async {
    try {
      print('🚀 Starting complete data migration...');

      await migrateAdvocatesToFirestore();
      await migrateServicesToFirestore();

      print('✅ All data migrated successfully!');
    } catch (e) {
      print('❌ Error during migration: $e');
      rethrow;
    }
  }

  /// Check if Firestore already has data
  Future<bool> hasExistingData() async {
    try {
      final advocatesSnapshot =
          await _firestore.collection('Advocates').limit(1).get();

      return advocatesSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking existing data: $e');
      return false;
    }
  }

  /// Clear all migrated data (use with caution!)
  Future<void> clearMigratedData() async {
    try {
      print('⚠️ Clearing all migrated data...');

      // Delete all advocates
      final advocatesSnapshot = await _firestore.collection('Advocates').get();
      WriteBatch batch = _firestore.batch();

      for (var doc in advocatesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Delete all services
      final servicesSnapshot = await _firestore.collection('Services').get();
      batch = _firestore.batch();

      for (var doc in servicesSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      print('✅ All migrated data cleared');
    } catch (e) {
      print('❌ Error clearing data: $e');
      rethrow;
    }
  }

  /// Create Firestore indexes (for better query performance)
  /// Note: Indexes are created automatically when queries fail
  /// But you can also create them manually in Firebase Console
  void logRequiredIndexes() {
    print('''
    📋 Required Firestore Indexes:
    
    1. Collection: Advocates
       Fields: nameLower (Ascending), isOnline (Ascending)
    
    2. Collection: Advocates
       Fields: specializationLower (Ascending), isOnline (Ascending)
    
    3. Collection: Services
       Fields: titleLower (Ascending)
    
    4. Collection: Users
       Fields: nameLower (Ascending), isActive (Ascending)
    
    Create these indexes in Firebase Console:
    https://console.firebase.google.com/project/_/firestore/indexes
    ''');
  }
}

/// Extension method to easily run migration
extension MigrationHelper on DataMigrationService {
  /// Run migration with safety checks
  Future<void> safelyMigrateData({bool force = false}) async {
    if (!force) {
      final hasData = await hasExistingData();
      if (hasData) {
        print('⚠️ Data already exists in Firestore. Skipping migration.');
        print('Use force=true to re-migrate (will not delete existing data)');
        return;
      }
    }

    await migrateAllData();
  }
}
