import 'package:flutter/material.dart';

class ExchangeRecordCreatePage extends StatefulWidget {
  const ExchangeRecordCreatePage({super.key});

  @override
  State<ExchangeRecordCreatePage> createState() => ExchangeRecordCreatePageState();
}

class ExchangeRecordCreatePageState extends State<ExchangeRecordCreatePage> {
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
                '나의 환전',
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