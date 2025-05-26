import 'package:flutter/material.dart';
import 'home_admin.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: Column(
        children: [
          Container(
            color: Colors.grey[800],
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black45, offset: Offset(2, 4), blurRadius: 4)],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Login', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.android, color: Colors.white)
                  ],
                ),
                const SizedBox(height: 20),
                const TextField(decoration: InputDecoration(labelText: 'Username')),
                const TextField(decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeAdmin()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
