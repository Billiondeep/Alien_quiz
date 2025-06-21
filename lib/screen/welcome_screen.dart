import 'package:alien_quiz/screen/admin/login/login_screen.dart';
import 'package:alien_quiz/screen/user/welcome/home/import/import_screen.dart';
import 'package:alien_quiz/screen/user/welcome/name_input_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  final Map<String, dynamic>? sharedJson;

  const WelcomeScreen({super.key, this.sharedJson});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.sharedJson != null) {
      // Tunggu 1 frame agar Navigator tidak error
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ImportScreen(sharedJson: widget.sharedJson!),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sharedJson != null) {
      // Hindari build UI ketika sedang push ke import
      return const Scaffold(
        backgroundColor: Color(0xFF1A1A2E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 👇 sisanya tetap sama
    return Scaffold(
      backgroundColor: const Color(0xFF2C233D),
      body: SafeArea(
        child: Column(
          children: [
            // Header login
            Container(
              color: Colors.grey[800],
              width: double.infinity,
              padding: const EdgeInsets.all(14),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Icon(Icons.reddit, size: 100, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              "Alien Quiz",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => NameInputScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shadowColor: Colors.black,
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
              ),
              child: const Text(
                "Let’s Starttt!!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const Spacer(),
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
