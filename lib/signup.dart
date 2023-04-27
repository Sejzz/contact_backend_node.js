import 'dart:convert';

import 'package:contact_lists/home.dart';
import 'package:contact_lists/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'configs.dart';

class signin extends StatefulWidget {
  String email;
  String password;
  signin({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool _isNotValidate = false;

  registerUser() async {
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      var registereddata = {
        "email": _email.text,
        "password": _password.text,
      };

      var response = await http.post(Uri.parse(registration),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(registereddata));
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => log(
                     
                    )));
      } else {
        print("Something Went Wrong");
      }
    }else{
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 47, 34, 68),
              Color.fromARGB(255, 65, 54, 85)
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(top: 100),
                child: Column(children: [
                  Image.asset(
                    "assets/images/con-.png",
                    height: 200,
                    width: 220,
                  ),
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _email,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        errorText: _isNotValidate ? "Enter Proper details" : null,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Colors.white)),
                          labelText: 'Enter Email',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email can't be empty";
                        }
    
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: _password,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                         errorText: _isNotValidate ? "Enter Proper details" : null,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28.0),
                            borderSide: BorderSide(width: 1, color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28.0),
                              borderSide: const BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                  color: Colors.white)),
                          labelText: 'Enter Password',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password can't be empty";
                        }
    
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 200,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton(
                      onPressed: () async {
                        registerUser();
    
                        
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color.fromARGB(255, 47, 34, 68),
                          fontSize: 20,
                          // fontWeight: FontWeight.normal
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey;
                          }
                          return Colors.white;
                        }),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
