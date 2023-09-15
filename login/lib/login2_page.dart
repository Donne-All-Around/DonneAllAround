import 'package:flutter/material.dart';

class LoginTwoPage extends StatefulWidget {
  const LoginTwoPage({super.key});

  @override
  State<LoginTwoPage> createState() => _LoginTwoPageState();
}

class _LoginTwoPageState extends State<LoginTwoPage> {
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
            body: const SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
  }
  
}