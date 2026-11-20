import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'service/api_service.dart';
import 'screens/admin_list_tab.dart';
import 'screens/detail_screens.dart';
import 'constant/nim_config.dart';

void main() {
  runApp(const MyApp());
}

// ==========================================
// MAIN APP
// ==========================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('id');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Method Tester',
      locale: locale,
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: HomeScreen(
        onLanguageChanged: (value) {
          setState(() {
            locale = Locale(value);
          });
        },
      ),
    );
  }
}

// ==========================================
// PAGE 1 - USER LIST + ADMIN LIST (TAB)
// ==========================================

class HomeScreen extends StatefulWidget {
  final Function(String) onLanguageChanged;

  const HomeScreen({super.key, required this.onLanguageChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService.getUsers();
  }

  void refreshData() {
    setState(() {
      futureUsers = ApiService.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('API Method Tester'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.restore),
              tooltip: 'Reset Data User',
              onPressed: () async {
                await ApiService.resetToDefault();
                refreshData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data User di-reset')),
                  );
                }
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.language),
              onSelected: widget.onLanguageChanged,
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
                PopupMenuItem(value: 'en', child: Text('English')),
              ],
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'User'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApiTesterScreen()),
            ).then((_) => refreshData());
          },
          icon: const Icon(Icons.api),
          label: const Text('Test API'),
        ),
        body: TabBarView(
          children: [
            _buildUserList(language),
            const AdminListTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList(AppLocalizations language) {
    return FutureBuilder<List<dynamic>>(
      future: futureUsers,
      builder: (context, snapshot) {
        // LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ERROR
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 12),
                Text(language.errorMessage),
                ElevatedButton(
                  onPressed: refreshData,
                  child: Text(language.retry),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return Center(child: Text(language.noData));
        }

        return RefreshIndicator(
          onRefresh: () async => refreshData(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final name = user['name']?.toString() ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID ${user['id']} • ${user['email']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            UserDetailScreen(userId: user['id'] as int),
                      ),
                    ).then((_) => refreshData());
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ==========================================
// PAGE 2 - API METHOD TESTER (USER CRUD)
// ==========================================

class ApiTesterScreen extends StatefulWidget {
  final int? initialId;

  const ApiTesterScreen({super.key, this.initialId});

  @override
  State<ApiTesterScreen> createState() => _ApiTesterScreenState();
}

class _ApiTesterScreenState extends State<ApiTesterScreen> {
  String selectedMethod = 'GET';

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = false;

  dynamic result;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialId != null) {
      idController.text = widget.initialId.toString();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // ==========================================
  // SEND REQUEST
  // ==========================================

  Future<void> sendRequest() async {
    final id = int.tryParse(idController.text);

    // Validasi ID (POST memakai ID otomatis dari NIM)
    if (selectedMethod != 'POST' && id == null) {
      showMessage('Masukkan ID pengguna yang valid');
      return;
    }

    // Validasi nama (POST, PUT, PATCH)
    if (selectedMethod != 'GET' &&
        selectedMethod != 'DELETE' &&
        nameController.text.trim().isEmpty) {
      showMessage('Nama tidak boleh kosong');
      return;
    }

    // Validasi email (POST dan PUT)
    if ((selectedMethod == 'POST' || selectedMethod == 'PUT') &&
        emailController.text.trim().isEmpty) {
      showMessage('Email tidak boleh kosong');
      return;
    }

    setState(() {
      isLoading = true;
      result = null;
      errorMessage = null;
    });

    try {
      dynamic response;

      switch (selectedMethod) {
        case 'GET':
          response = await ApiService.getUser(id!);
          break;

        case 'POST':
          response = await ApiService.createUser(
            nameController.text.trim(),
            emailController.text.trim(),
          );
          break;

        case 'PUT':
          response = await ApiService.updateUser(
            id!,
            nameController.text.trim(),
            emailController.text.trim(),
          );
          break;

        case 'PATCH':
          response = await ApiService.patchUser(
            id!,
            nameController.text.trim(),
          );
          break;

        case 'DELETE':
          final success = await ApiService.deleteUser(id!);
          response = {
            'success': success,
            'message': success
                ? 'Pengguna berhasil dihapus'
                : 'Gagal menghapus pengguna (ID tidak ditemukan)',
          };
          break;
      }

      if (!mounted) return;
      setState(() {
        result = response;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // SNACKBAR
  // ==========================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ==========================================
  // UI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final isGet = selectedMethod == 'GET';
    final isPost = selectedMethod == 'POST';
    final isPut = selectedMethod == 'PUT';
    final isPatch = selectedMethod == 'PATCH';
    final isDelete = selectedMethod == 'DELETE';

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Method Tester'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Request Configuration',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih HTTP method dan masukkan data yang ingin dikirim.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // METHOD DROPDOWN
            const Text(
              'HTTP Method',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedMethod,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.api),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'GET', child: Text('GET - Retrieve Data')),
                DropdownMenuItem(
                    value: 'POST', child: Text('POST - Create Data')),
                DropdownMenuItem(
                    value: 'PUT', child: Text('PUT - Replace Data')),
                DropdownMenuItem(
                    value: 'PATCH', child: Text('PATCH - Update Data')),
                DropdownMenuItem(
                    value: 'DELETE', child: Text('DELETE - Remove Data')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMethod = value!;
                  result = null;
                  errorMessage = null;
                });
              },
            ),
            const SizedBox(height: 20),

            // ID INPUT
            if (!isPost) ...[
              const Text(
                'User ID',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Contoh: $userIdFromNim',
                  prefixIcon: const Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // NAME INPUT
            if (!isGet && !isDelete) ...[
              const Text(
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan nama pengguna',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // EMAIL INPUT
            if (isPost || isPut) ...[
              const Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Masukkan email pengguna',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isGet
                    ? 'GET: Mengambil data pengguna berdasarkan ID.'
                    : isPost
                    ? 'POST: Menambah pengguna baru dengan ID otomatis '
                    '$userIdFromNim (1000 + N).'
                    : isPut
                    ? 'PUT: Mengganti nama dan email pengguna.'
                    : isPatch
                    ? 'PATCH: Mengubah nama pengguna dan menambahkan '
                    '" - Flutter Developer".'
                    : 'DELETE: Menghapus pengguna berdasarkan ID.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : sendRequest,
                icon: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(isLoading ? 'Sending Request...' : 'Send Request'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // RESPONSE RESULT
            if (result != null || errorMessage != null) ...[
              const Text(
                'Response Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: errorMessage != null
                      ? Colors.red.withValues(alpha: 0.08)
                      : Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: errorMessage != null ? Colors.red : Colors.green,
                  ),
                ),
                child: SelectableText(
                  errorMessage != null
                      ? errorMessage!
                      : const JsonEncoder.withIndent('  ').convert(result),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}