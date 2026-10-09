// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ), //ThemeData
//       home: const HomePage(),
//     ); //MaterialApp
//   }
// } //MyApp
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int currentindex =0;
//
//   final List<Widget> pages = const [
//     HomeContent(),
//     //Content2(),
//   ];
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Registration Activity "),
//       ), //AppBar
//       body: pages[currentindex],
//
//       bottomNavigationBar: BottomNavigationBar(
//           currentIndex : currentindex,
//
//         onTap: (index){
//             setState(() {
//               currentindex = index;
//             });
//         },
//
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'settings',
//           ),
//         ],
//       ), //BottomNavigationBar
//     ); //Scafflod
//   }
// }
//
// class HomeContent extends StatelessWidget {
//   const HomeContent({super.key});
//
//   @override
//   Widget build(BuildContext context){
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("layout activity registration ",
//           style: TextStyle(
//             color: Colors.green,
//             fontWeight: FontWeight.w800,
//             fontSize: 24,
//           )),
//           Container(
//           width: 300,
//           height: 20,
//           color: Colors.blue,
//           ),
//           const Padding(padding: EdgeInsets.only(bottom: 20)),
//           Container(
//             width: 400,
//             height: 20,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                   child: Container(
//                     height: 50,
//                     decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
//                   )),
//                   const SizedBox(width: 16),
//                   Expanded(
//                       child: Container(
//                         height: 50,
//                         color: Colors.green,
//                       ))
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'constant/colors.dart';
import 'theme/app_theme.dart';
import 'widgets/app_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primary,
        title: const Text('Design System Demo'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Git Hub',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tekan tombol di bawah untuk terhubung dengan Git Hub saya.',
              style: TextStyle(color: AppColors.text),
            ),

            const SizedBox(height: 24),

            AppButton(
              label: 'Buka Git Hub',
              icon: Icons.location_on,
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              },
              url: 'https://github.com/dwiahmad02',
            ),

            const SizedBox(height: 16),

            AppButton(
              label: 'Tes Tombol',
              icon: Icons.touch_app,
              onPressed: () {
                debugPrint('Tombol berhasil ditekan!');
              },
              url: 'https://github.com/dwiahmad02',
            ),
          ],
        ),
      ),
    );
  }
}