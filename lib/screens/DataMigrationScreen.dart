import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/services/data_migration_service.dart';

/// Example screen showing how to run data migration
/// This is for demonstration/admin purposes only
///
/// Add this to your app temporarily to migrate data from JSON to Firestore
/// Remove it after migration is complete
class DataMigrationScreen extends StatefulWidget {
  const DataMigrationScreen({super.key});

  @override
  State<DataMigrationScreen> createState() => _DataMigrationScreenState();
}

class _DataMigrationScreenState extends State<DataMigrationScreen> {
  final DataMigrationService _migrationService = DataMigrationService();

  bool _isMigrating = false;
  bool _hasExistingData = false;
  String _statusMessage = 'Ready to migrate data';
  bool _isCheckingData = true;

  @override
  void initState() {
    super.initState();
    _checkExistingData();
  }

  Future<void> _checkExistingData() async {
    setState(() {
      _isCheckingData = true;
      _statusMessage = 'Checking existing data...';
    });

    try {
      final hasData = await _migrationService.hasExistingData();
      setState(() {
        _hasExistingData = hasData;
        _statusMessage = hasData
            ? '✅ Data already exists in Firestore'
            : 'No data found. Ready to migrate.';
        _isCheckingData = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error checking data: $e';
        _isCheckingData = false;
      });
    }
  }

  Future<void> _migrateAdvocates() async {
    setState(() {
      _isMigrating = true;
      _statusMessage = 'Migrating advocates...';
    });

    try {
      await _migrationService.migrateAdvocatesToFirestore();
      setState(() {
        _statusMessage = '✅ Advocates migrated successfully!';
        _isMigrating = false;
        _hasExistingData = true;
      });

      _showSuccessDialog('Advocates migrated successfully!');
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error migrating advocates: $e';
        _isMigrating = false;
      });

      _showErrorDialog('Failed to migrate advocates: $e');
    }
  }

  Future<void> _migrateServices() async {
    setState(() {
      _isMigrating = true;
      _statusMessage = 'Migrating services...';
    });

    try {
      await _migrationService.migrateServicesToFirestore();
      setState(() {
        _statusMessage = '✅ Services migrated successfully!';
        _isMigrating = false;
      });

      _showSuccessDialog('Services migrated successfully!');
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error migrating services: $e';
        _isMigrating = false;
      });

      _showErrorDialog('Failed to migrate services: $e');
    }
  }

  Future<void> _migrateAll() async {
    setState(() {
      _isMigrating = true;
      _statusMessage = 'Migrating all data...';
    });

    try {
      await _migrationService.migrateAllData();
      setState(() {
        _statusMessage = '✅ All data migrated successfully!';
        _isMigrating = false;
        _hasExistingData = true;
      });

      _showSuccessDialog('All data migrated successfully!');
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error migrating data: $e';
        _isMigrating = false;
      });

      _showErrorDialog('Failed to migrate data: $e');
    }
  }

  Future<void> _clearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Confirm Delete'),
        content: const Text(
          'This will delete all migrated data from Firestore. This action cannot be undone. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text('Delete All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isMigrating = true;
      _statusMessage = 'Clearing data...';
    });

    try {
      await _migrationService.clearMigratedData();
      setState(() {
        _statusMessage = '✅ Data cleared successfully';
        _isMigrating = false;
        _hasExistingData = false;
      });

      _showSuccessDialog('All data cleared successfully!');
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error clearing data: $e';
        _isMigrating = false;
      });

      _showErrorDialog('Failed to clear data: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showIndexInfo() {
    _migrationService.logRequiredIndexes();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Required Firestore Indexes'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Create these indexes in Firebase Console:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Collection: Advocates'),
              Text('   Fields: nameLower (Asc), isOnline (Desc)'),
              SizedBox(height: 8),
              Text('2. Collection: Advocates'),
              Text('   Fields: specializationLower (Asc), isOnline (Desc)'),
              SizedBox(height: 8),
              Text('3. Collection: Services'),
              Text('   Fields: titleLower (Asc)'),
              SizedBox(height: 12),
              Text(
                'Or wait for Firebase to show index links when you first search.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Data Migration', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _hasExistingData ? Colors.green[50] : Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isCheckingData
                          ? Icons.hourglass_empty
                          : _hasExistingData
                              ? Icons.check_circle
                              : Icons.info,
                      size: 48,
                      color: _isCheckingData
                          ? Colors.grey
                          : _hasExistingData
                              ? Colors.green
                              : Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Text
            const Text(
              'Migrate data from JSON files to Firestore for better performance and scalability.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Migration Buttons
            if (!_isMigrating && !_isCheckingData) ...[
              ElevatedButton.icon(
                onPressed: _migrateAll,
                icon: const Icon(Icons.upload),
                label: const Text('Migrate All Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _migrateAdvocates,
                      icon: const Icon(Icons.person),
                      label: const Text('Advocates Only'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _migrateServices,
                      icon: const Icon(Icons.business),
                      label: const Text('Services Only'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Utility Buttons
              OutlinedButton.icon(
                onPressed: _checkExistingData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
              ),
              const SizedBox(height: 8),

              OutlinedButton.icon(
                onPressed: _showIndexInfo,
                icon: const Icon(Icons.info_outline),
                label: const Text('Show Required Indexes'),
              ),

              if (_hasExistingData) ...[
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _clearData,
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Clear All Data'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ],

            // Loading Indicator
            if (_isMigrating || _isCheckingData) ...[
              const SizedBox(height: 24),
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),
            ],

            const Spacer(),

            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '📝 Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                      '1. Click "Migrate All Data" to transfer JSON to Firestore'),
                  Text('2. Wait for success message'),
                  Text('3. Click "Show Required Indexes"'),
                  Text('4. Create indexes in Firebase Console'),
                  Text('5. Test search functionality'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
