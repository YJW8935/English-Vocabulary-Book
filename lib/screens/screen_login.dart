
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:english_vocabulary_book/screens/screen_register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
            const SizedBox(height: 20),
            _passwordWidget(),
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
      maxLength: 13,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Password',
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

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Get.offAll(WordsList());
    } else {
      print('로그인이 필요합니다');
    }
  }

  // 로그인 버튼 누를 시
  _login() async {
    if (await loginAction(_idController.text, _passwordController.text) == true) {
      print('로그인 성공');
      Get.offAll(() => const WordsList());
    } else {
      print('로그인 실패');
    }
  }

  loginAction(id, password) async {
    try {
      Dio dio = new Dio();
      var param = {'id': '$id', 'password': '$password'};

      Response response = await dio.post('http://192.168.0.131:8080', data: param);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.data['user_id'].toString());
        var val = jsonEncode(LoginModel('$id', '$password'));
        await storage.write(key: 'login', value: val);
        print('로그인 성공');
        return true;
      } else {
        print('error');
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: ((context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: Text("로그인 실패"),
              content: Text("로그인에 실패하였습니다. 아이디/비밀번호를 확인해주세요."),
              actions: <Widget>[
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text("네"),
                  ),
                )
              ],
            );
          }),
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}