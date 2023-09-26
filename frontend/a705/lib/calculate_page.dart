import 'package:flutter/material.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: Color(0xFFFFD954),
            ),
            child:  Center(
              child: RichText(
                text:  TextSpan(
                  children:  [
                    const TextSpan(
                      text: "이익/손실",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const TextSpan(
                      text: "계산",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton.outlined(
                            icon: const Icon(Icons.info_outline_rounded),
                            color: Colors.white,
                            onPressed:() {} ,
                        ),
                      ),
                    ),
                  ],
                  // textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black38),
            ),
          ),
        ],
      ),
    );
  }
}

