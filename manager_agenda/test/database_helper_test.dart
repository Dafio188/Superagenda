import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager_agenda/database_helper.dart';
import 'package:manager_agenda/user.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set the database factory to the ffi implementation
  databaseFactory = databaseFactoryFfi;

  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return Directory.systemTemp.path;
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('Database helper test', () async {
    final dbHelper = DatabaseHelper();

    // Test user creation
    final user = User(username: 'testuser', password: 'password');
    final userId = await dbHelper.saveUser(user);
    expect(userId, 1);

    // Test user retrieval
    final retrievedUser = await dbHelper.getUser('testuser', 'password');
    expect(retrievedUser!.username, 'testuser');
  });
}
