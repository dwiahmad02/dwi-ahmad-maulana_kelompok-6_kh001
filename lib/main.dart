import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ), //ThemeData
      home: const HomePage(),
    ); //MaterialApp
  }
} //MyApp

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentindex =0;

  final List<Widget> pages = const [
    HomeContent(),
    //Content2(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Flutter App"),
      ), //AppBar
      body: pages[currentindex],

      bottomNavigationBar: BottomNavigationBar(
          currentIndex : currentindex,

        onTap: (index){
            setState(() {
              currentindex = index;
            });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
      ), //BottomNavigationBar
    ); //Scafflod
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Selamat Datang",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          )),
          Container(
          width: 300,
          height: 20,
          color: Colors.blue,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 20)),
          Container(
            width: 400,
            height: 20,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  )),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Container(
                        height: 50,
                        color: Colors.green,
                      ))
            ],
          )
        ],
      ),
    );
  }
}