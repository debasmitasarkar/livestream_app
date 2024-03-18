import 'package:flutter/material.dart';
import 'package:livestream_example/educator_home_page.dart';
import 'package:livestream_example/student_home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const EducatorHomePage(
                      userId: 'educator', // same id as backend
                      userToken: 'EDUCATOR_ROKEN',
                    ))),
            child: const Text('Educator'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const StudentPage(
                      userId: 'student', // same id as backend
                      userToken: 'STUDENT_TOKEN',
                    ))),
            child: const Text('Student'),
          )
        ],
      )),
    );
  }
}
