import 'package:flutter/material.dart';

import '../models/admin.dart';
import '../service/admin_service.dart';
import 'detail_screens.dart';

class AdminListTab extends StatefulWidget {
  const AdminListTab({super.key});

  @override
  State<AdminListTab> createState() => _AdminListTabState();
}

class _AdminListTabState extends State<AdminListTab> {
  late Future<List<Admin>> futureAdmins;

  @override
  void initState() {
    super.initState();
    futureAdmins = AdminService.getAdmins();
  }

  void refresh() {
    setState(() => futureAdmins = AdminService.getAdmins());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () async {
              await AdminService.resetToDefault();
              refresh();
            },
            icon: const Icon(Icons.restore),
            label: const Text('Reset Data Admin'),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Admin>>(
            future: futureAdmins,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('${snap.error}'));
              }
              final admins = snap.data ?? [];
              if (admins.isEmpty) {
                return const Center(child: Text('Tidak ada data admin'));
              }
              return RefreshIndicator(
                onRefresh: () async => refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: admins.length,
                  itemBuilder: (context, i) {
                    final a = admins[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Text(
                            a.name.isNotEmpty ? a.name[0].toUpperCase() : '?',
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(a.name,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('ID ${a.id} • ${a.department}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminDetailScreen(adminId: a.id),
                            ),
                          );
                          refresh();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}