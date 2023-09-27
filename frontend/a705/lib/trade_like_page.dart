import 'package:flutter/material.dart';

class TradeLikePage extends StatefulWidget {
  const TradeLikePage({super.key});

  @override
  State<TradeLikePage> createState() => TradeLikePageState();
}

class TradeLikePageState extends State<TradeLikePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          elevation: 0,
          title: const Text(
            '관심 목록',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )
          ),
          centerTitle: true,
        ),
      )
    );
  }
}