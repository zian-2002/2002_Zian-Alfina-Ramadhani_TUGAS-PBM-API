import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../helper/storage_helper.dart';
import 'home_page.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nimController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    if (nimController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NIM dan Password tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final authService = AuthService();
    final token = await authService.login(
      nimController.text,
      passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (token != null) {
      await StorageHelper.saveToken(token);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal. Periksa NIM dan Password Anda.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.store_mall_directory_rounded,
                  size: 100,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to manage your products',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nimController,
                          labelText: 'Username (NIM)',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password (NIM)',
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          onPressed: login,
                          label: 'Login',
                          isLoading: isLoading,
                        ),
                      ],
                    ),
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
