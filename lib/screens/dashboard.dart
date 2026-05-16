import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medidor+', style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
