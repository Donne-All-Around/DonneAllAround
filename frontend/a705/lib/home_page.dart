import 'package:a705/transaction_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _valueList = ['첫 번째', '두 번째', '세 번째'];
  var _selectedValue = '첫 번째';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Row(
            children: [
              const SizedBox(width: 10),
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
              const SizedBox(width: 10),
              DropdownButton(
                value: _selectedValue,
                items: _valueList.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/australia.png'),
                          radius: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value!;
                  });
                },
              ),
            ],
          ),
          leadingWidth: 200,
        ),
        body: Stack(children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.blue,
            child: const Text('HomePage'),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const TransactionPage();
                  },
                ));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFD954),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
