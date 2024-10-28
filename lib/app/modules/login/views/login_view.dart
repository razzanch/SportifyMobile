import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add GetX for navigation
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

//new
/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}
*/

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of AuthController
    final AuthController authController = Get.put(AuthController());

    // TextEditingController for email and password
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon or Logo
                Image.asset(
                  'assets/logo app.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                // App Name
                const Text(
                  'SPORTIFY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // App Description
                const Text(
                  'Aplikasi latihan olahraga Anda',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                // Input Email
                TextField(
                  controller: emailController, // Set controller
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input Password
                TextField(
                  controller: passwordController, // Set controller
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Text "Don't have an account? Register" for navigation to Register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to the Register page
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Call login function from AuthController
                    authController.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
