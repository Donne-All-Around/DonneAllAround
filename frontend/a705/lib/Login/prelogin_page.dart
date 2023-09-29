import 'package:flutter/material.dart';


class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();

}

class _PreLoginPageState extends State<PreLoginPage> {

  final _key = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
            body: Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          '휴대폰 번호로',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          '로그인 해주세요!',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        phoneNumberInput(),

                      ],
                    ),
                  ],
                ),
              ),
            ),

          ),

        ));
  }


  TextFormField phoneNumberInput() {
    return TextFormField(
      controller: _phoneController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: BorderSide(color: Colors.black),
        ),
        hintText: '휴대폰 번호 ( - 없이 숫자만 입력)',
        hintStyle: const TextStyle(fontSize: 14),
        labelStyle: const TextStyle(
          fontSize: 20,
          // textAlign: TextAlign.center,
        ),
        // contentPadding: EdgeInsets.all(20.0),
      ),
    );
  }

  TextFormField smsCodeInput() {
    return TextFormField(
      controller: _smsCodeController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          // borderSide: BorderSide(color: Colors.black),
        ),
        hintText: '인증번호 입력',
        // suffixText: formatRemainingTime(_remainingTime),
        // suffixStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        // contentPadding: EdgeInsets.all(20.0),
      ),
    );
  }

}