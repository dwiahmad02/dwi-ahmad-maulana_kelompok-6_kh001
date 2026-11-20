import 'package:flutter/material.dart';

import '../models/admin.dart';
import '../service/admin_service.dart';
import '../service/api_service.dart';

// ==================== DETAIL USER ====================
class UserDetailScreen extends StatelessWidget {
  final int userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail User #$userId'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getUser(userId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final u = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _row(Icons.numbers, 'ID', '${u['id']}'),
              _row(Icons.person, 'Name', '${u['name']}'),
              _row(Icons.email, 'Email', '${u['email']}'),
              _row(Icons.location_city, 'City', '${u['city']}'),
            ],
          );
        },
      ),
    );
  }
}

// ==================== DETAIL ADMIN (+ HAPUS) ====================
class AdminDetailScreen extends StatelessWidget {
  final int adminId;
  const AdminDetailScreen({super.key, required this.adminId});

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Admin?'),
        content: Text('Admin dengan ID $adminId akan dihapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final success = await AdminService.deleteAdmin(adminId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? 'Admin $adminId berhasil dihapus'
          : 'Gagal menghapus admin'),
    ));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Admin #$adminId'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Admin>(
        future: AdminService.getAdmin(adminId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final a = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _row(Icons.numbers, 'ID', '${a.id}'),
              _row(Icons.person, 'Name', a.name),
              _row(Icons.email, 'Email', a.email),
              _row(Icons.apartment, 'Department', a.department),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  onPressed: () => _delete(context),
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus Admin'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _row(IconData icon, String label, String value) {
  return Card(
    child: ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      subtitle: Text(value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ),
  );
}