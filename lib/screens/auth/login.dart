import 'package:flutter/material.dart';
import 'package:fuelmetrics/screens/dashboard/home_screen.dart';
import 'package:fuelmetrics/widgets/login_field.dart';
import 'package:fuelmetrics/widgets/social_button.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
 State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _purple = Color(0xFF8B63ED);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _pressed= false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


 void _login(){
    if (!_formKey.currentState!.validate()) return;

     Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 48, 28, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              icon: const Icon(Icons.chevron_left_rounded),
                              iconSize: 38,
                              color: _purple,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            Transform.translate(
                              offset: const Offset(28, -36),
                              child: const Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: _purple,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(30, -32),
                              child: const Text(
                                'Login to Continue.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(62, 44, 62, 56),
                        decoration: const BoxDecoration(
                          color: _purple,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(98),
                            topRight: Radius.circular(98),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              LoginField(
                                controller: _emailController,
                                hintText: 'Enter Your Email',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.mail_outline_rounded,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email is required';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              LoginField(
                                controller: _passwordController,
                                hintText: 'Enter Your Password',
                                obscureText: _obscurePassword,
                                prefixIcon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 6) {
                                    return 'At least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _login,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.only(top: 14),
                                  ),
                                  child: const Text(
                                    'Forgot Password',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    _pressed=true;
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: _purple,
                                    elevation: 3,
                                    shape: const StadiumBorder(),
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  child: _pressed
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: _purple,
                                          ),
                                        )
                                      : const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 22),
                              const Text(
                                'or continue with',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SocialButton(
                                    label: 'G',
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF4285F4),
                                  ),
                                  const SizedBox(width: 24),
                                  SocialButton(
                                    label: 'f',
                                    backgroundColor: const Color(0xFF1877F2),
                                    foregroundColor: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 26),
                             
                            
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




