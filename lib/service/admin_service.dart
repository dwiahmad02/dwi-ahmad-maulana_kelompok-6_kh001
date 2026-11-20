import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../constant/nim_config.dart';
import '../models/admin.dart';

class AdminService {
  static const _fileName = 'admins.json';

  static List<Map<String, dynamic>> _defaultAdmins() => [
    {
      'id': adminIdFromNim, // 2000 + N
      'name': 'Admin Utama',
      'email': 'admin@example.com',
      'department': 'IT',
    },
    {
      'id': 2001,
      'name': 'Siti Rahma',
      'email': 'siti@example.com',
      'department': 'Keuangan',
    },
    {
      'id': 2002,
      'name': 'Andi Pratama',
      'email': 'andi@example.com',
      'department': 'Akademik',
    },
  ];

  static Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  static Future<void> _write(List<Map<String, dynamic>> data) async {
    final f = await _file();
    await f.writeAsString(jsonEncode(data));
  }

  static Future<List<Map<String, dynamic>>> _read() async {
    final f = await _file();
    if (!await f.exists()) {
      await _write(_defaultAdmins());
      return _defaultAdmins();
    }
    final data = jsonDecode(await f.readAsString()) as List;
    return data.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // GET semua admin
  static Future<List<Admin>> getAdmins() async {
    final data = await _read();
    return data.map(Admin.fromJson).toList();
  }

  // GET satu admin berdasarkan ID
  static Future<Admin> getAdmin(int id) async {
    final data = await _read();
    final found = data.where((e) => e['id'] == id);
    if (found.isEmpty) {
      throw Exception('Admin dengan ID $id tidak ditemukan');
    }
    return Admin.fromJson(found.first);
  }

  // DELETE admin berdasarkan ID
  static Future<bool> deleteAdmin(int id) async {
    final data = await _read();
    final before = data.length;
    data.removeWhere((e) => e['id'] == id);
    if (data.length == before) return false;
    await _write(data);
    return true;
  }

  static Future<void> resetToDefault() async {
    await _write(_defaultAdmins());
  }
}