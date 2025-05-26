import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D), // Dark background
      body: Column(
        children: [
          // Header dengan teks bisa diklik ke LoginScreen
          Container(
            color: Colors.grey[800],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Center(
                child: Text(
                  'Halaman Login',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
          const Spacer(),
          
          // Logo Alien Reddit
          Icon(Icons.android, size: 100, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            "Alien Quiz",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          
          // Tombol Start
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              elevation: 4,
            ),
            child: const Text("Let’s Starttt!!", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          
          const Spacer(),

          // Ikon sosial media
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white),
                FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
