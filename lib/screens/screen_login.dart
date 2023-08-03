import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 50)),
          Center(
            child: Icon(Icons.collections_bookmark, color: Colors.deepPurpleAccent, size: 100),
          ),
          const SizedBox(height: 20.0),
          _userIdWidget(),
          const SizedBox(height: 20.0),
          _passwordWidget(),
          Container(
            height: 70,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
            child: ElevatedButton(
                onPressed: () => _login(),
                child: const Text("로그인")
            ),
          ),
          const SizedBox(height: 20.0),
          GestureDetector(
            child: const Text('회원 가입'),
            onTap: (){
              Get.to(() => const JoinPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _userIdWidget(){
    return TextFormField(

    );
  }

  Widget _passwordWidget() {
    return TextFormField(

    );
  }
}
