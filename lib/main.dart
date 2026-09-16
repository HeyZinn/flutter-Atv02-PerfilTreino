import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
      
        appBar: AppBar(
          title: Text("Montador de Perfil de Treino"),
          centerTitle: true,
          bottom: PreferredSize(preferredSize: const Size.fromHeight(20.0), child: Divider(
            color: Colors.grey,
            height: 20.0,
          )),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Text("OBJETIVO DO TREINO",
              style: Theme.of(context).textTheme.titleMedium,
              ),
              
            ],
            ),
        ),
          
        ),
    );
    
  }
}

