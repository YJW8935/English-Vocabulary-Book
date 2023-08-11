import 'package:dio/dio.dart';
import 'package:english_vocabulary_book/screens/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.144:8080'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            Center(
              child: Icon(Icons.collections_bookmark,
                  color: Colors.orangeAccent, size: 100),
            ),
            const SizedBox(height: 20),
            _userIdWidget(),
            const SizedBox(height: 20),
            _passwordWidget(),
            Container(
              height: 70,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
              child: ElevatedButton(
                // 회원가입 버튼
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.orangeAccent)),
                  onPressed: () => _register(),
                  child: const Text("회원가입")),
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

  Future<void> _register() async {
    final String id = _idController.text;
    final String password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      _showErrorMessage('아이디와 비밀번호를 입력해주세요.');
      return;
    }

    if (!_isIdValid(id) || !_isPasswordValid(password)) {
      _showErrorMessage('조건에 맞지 않습니다.\n다시 작성해주세요.');
      return;
    }

    try {
      final response = await _dio.post('/user/sign-up', data: {
        'id': id,
        'password': password,
      });

      if (response.statusCode == 201) {
        print('회원 가입 성공');
        _showSuccessMessage('로그인을 진행해주세요.');
        Get.offAll(LoginScreen()); // 회원 가입 성공 후 로그인 화면으로 이동
      } else {
        print('회원 가입 실패: ${response.statusCode}');
        _showErrorMessage('회원 가입에 실패했습니다.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorMessage('회원 가입에 실패했습니다.');
    }
  }

  bool _isIdValid(String id) {
    final RegExp idRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    return id.length >= 6 && id.length <= 35 && idRegExp.hasMatch(id);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 && password.length <= 35;
  }

  void _showErrorMessage(String message) {
    Get.snackbar('실패', message,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,);
  }

  void _showSuccessMessage(String message) {
    Get.snackbar('회원가입 성공!', message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,);
  }

}
