import 'package:flutter/material.dart';

class DirectTransactionPage extends StatefulWidget {
  const DirectTransactionPage({super.key});

  @override
  State<DirectTransactionPage> createState() => _DirectTransactionPageState();
}

class _DirectTransactionPageState extends State<DirectTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(),
    ));
  }
}
