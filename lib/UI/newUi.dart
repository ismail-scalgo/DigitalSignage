import 'package:flutter/material.dart';

class NewUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              color: Colors.teal[300],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 60),
                    Image.network(
                      'https://your-logo-url.com', // Replace with your logo URL
                      height: 100,
                    ),
                    SizedBox(height: 60),
                    _buildTextField(Icons.person, 'Username'),
                    SizedBox(height: 20),
                    _buildTextField(Icons.lock, 'Password', isPassword: true),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Handle login
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 20),

                        // primary: Colors.teal,
                      ),
                      child: Text('Login'),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
