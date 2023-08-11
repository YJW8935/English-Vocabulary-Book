import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:english_vocabulary_book/screens/screen_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_core/src/get_main.dart';

import '../main.dart';
import '../model/login_model.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.144:8080'));
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            Center(
              child: Icon(Icons.collections_bookmark,
                  color: Colors.deepPurpleAccent, size: 100),
            ),
            const SizedBox(height: 20),
            _userIdWidget(),
            const SizedBox(height: 10),
            _passwordWidget(),
            const SizedBox(height: 20),
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
              child: ElevatedButton(
                  // 로그인 버튼
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurpleAccent)),
                  onPressed: () => _login(),
                  child: const Text("로그인")),
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              child: const Text('회원 가입'),
              onTap: () {
                Get.to(() => RegisterScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _userIdWidget() {
    return TextFormField(
      controller: _idController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'ID',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          // == null or isEmpty
          return '아이디를 입력해주세요.';
        }
        return null;
      },
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      maxLength: 35,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
        counterText: '',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          // == null or isEmpty
          return '비밀번호를 입력해주세요.';
        }
        return null;
      },
    );
  }

  void _showErrorMessage(String message) {
    Get.snackbar('실패', message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,);
  }

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<void> _asyncMethod() async {
    userInfo = await storage.read(key: 'login');

    if (userInfo != null && userInfo != '') {
      Get.offAll(WordsList());
    } else {
      print('로그인이 필요합니다');
    }
  }

  // 로그인 버튼 누를 시
  Future<void> _login() async {
    final String id = _idController.text;
    final String password = _passwordController.text;

    if (id.isEmpty) {
      _showErrorMessage('아이디를 입력해주세요.');
      return;
    }

    if (password.isEmpty) {
      _showErrorMessage('비밀번호를 입력해주세요.');
      return;
    }

    try {
      final response = await _dio.post('/user/login', data: {
        'id': id,
        'password': password,
      });

      if (response.statusCode != null) {
        print("Response Status Code: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        final jsonBody = response.data['id'].toString();
        var val = jsonEncode(LoginModel(id, password));
        await storage.write(key: 'login', value: val);
        Get.offAll(WordsList());
      } else {
        print(response.statusCode);
        _showErrorMessage('아이디 또는 비밀번호가 틀립니다.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorMessage('서버 오류가 발생했습니다.');
    }
  }
}