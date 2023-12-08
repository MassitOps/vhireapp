import 'package:flutter/material.dart';
import 'package:vhireapp/screens/authentication/signup_page.dart';
import 'package:vhireapp/services/authentication.dart';
import 'package:vhireapp/shared/loading.dart';
import 'pwd_forget.dart';

import '../wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  bool loading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                Icon(Icons.car_repair,
                  size: 100,),
                SizedBox(height: 75,),
                //Welcome section
                Text("Bienvenue !",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
                SizedBox(height:10,),
                Text('Connectez vous',
                  style: TextStyle(
                      fontSize: 18),
                ),

                // Email text field
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),

                // Password text field
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mot de passe',
                        ),
                      ),
                    ),
                  ),
                ),

                // Login Button
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () async {
                      setState(() => loading = true );
                      dynamic result = await _auth.signIn(_emailController.text, _passwordController.text);
                      if(result!=null) {
                        debugPrint(result.id);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const Wrapper()));
                      } else {
                        setState(() => loading = false );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration( color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordForgetPage()),
                    );
                  },
                  child: Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                //Registration page link here
                SizedBox(height: 25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Vous n'avez pas de compte?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUpPage()));
                      } ,
                      child: Text("Inscrivez vous!",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

              ],),
          ),
        ),
      ),
    );
  }
}
