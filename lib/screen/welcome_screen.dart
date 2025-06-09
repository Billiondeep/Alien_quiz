import 'package:alien_quiz/screen/admin/login/login_screen.dart';
import 'package:alien_quiz/screen/user/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: SafeArea(
        child: Column(
          children: [
            // Header login
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Logo Reddit (alien)
            const Icon(
              Icons.reddit,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),

            // Text title
            const Text(
              "Alien Quiz",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),

            // Tombol Start dengan bayangan
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shadowColor: Colors.black,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              ),
              child: const Text(
                "Let’s Starttt!!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const Spacer(),

            // Sosial media
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                  SizedBox(width: 32),
                  FaIcon(FontAwesomeIcons.xTwitter, color: Colors.white),
                  SizedBox(width: 32),
                  FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
