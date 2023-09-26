import 'package:flutter/material.dart';

class BuyRecordPage extends StatefulWidget {
  const BuyRecordPage({super.key});

  @override
  State<BuyRecordPage> createState() => BuyRecordPageState();
}

class BuyRecordPageState extends State<BuyRecordPage> {
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
                '구매 내역',
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