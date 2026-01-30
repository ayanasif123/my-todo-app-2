import 'package:flutter/material.dart';
import 'package:grid/log.dart';

class Reg extends StatefulWidget {
  const Reg({super.key});

  @override
  State<Reg> createState() => _RegState();
}

class _RegState extends State<Reg> with SingleTickerProviderStateMixin {
  bool showSplash = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(                                   
        title: const Text(
          "Register Form",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Username field
            Center(
              child: SizedBox(
                height: 50,
                width: 400,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(Icons.person, color: Colors.deepPurpleAccent),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Password field with eye + animation
            Center(
              child: SizedBox(
                height: 50,
                width: 400,
                child: TextField(
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock, color: Colors.deepPurpleAccent),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return RotationTransition(
                            turns: Tween(begin: 0.5, end: 1.0).animate(animation),
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                        child: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          key: ValueKey<bool>(_obscurePassword),
                          color: _obscurePassword ? Colors.grey : Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 150),

            // Register button
            Center(
              child: SizedBox(
                height: 50,
                width: 400,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
