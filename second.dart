import 'package:flutter/material.dart';
import 'package:grid/auth%20helper.dart';

// In-memory notes
List<Map<String, String>> notes = [];

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = true;
  bool loggedIn = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  /// ---------------- AUTH ----------------
  void submitAuth() {
    if (emailController.text.isEmpty || passController.text.isEmpty) return;

    if (isLogin) {
      bool ok = AuthHelper.login(
        emailController.text,
        passController.text,
      );

      if (ok) {
        setState(() => loggedIn = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Login")),
        );
      }
    } else {
      AuthHelper.register(
        emailController.text,
        passController.text,
      );

      setState(() => loggedIn = true);
    }
  }

  /// ---------------- SAVE NOTE ----------------
  void _saveNote() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) return;

    setState(() {
      notes.add({
        'title': _titleController.text,
        'note': _noteController.text,
      });
    });

    _titleController.clear();
    _noteController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notes App'),
          actions: loggedIn
              ? [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      setState(() {
                        loggedIn = false;
                      });
                    },
                  )
                ]
              : null,
        ),

        body: loggedIn
            /// ================= NOTES UI =================
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: "Note"),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _saveNote,
                      child: const Text("Save Note"),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(notes[index]['title']!),
                              subtitle: Text(notes[index]['note']!),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )

            /// ================= LOGIN / REGISTER UI =================
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        isLogin ? "LOGIN" : "REGISTER",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email"),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: passController,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: "Password"),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: submitAuth,
                        child: Text(isLogin ? "Login" : "Register"),
                      ),

                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Create account"
                              : "Already have account? Login",
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