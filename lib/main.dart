import 'package:contact_lists/home.dart';
import 'package:contact_lists/login.dart';
import 'package:contact_lists/signup.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences.setMockInitialValues({});
  SharedPreferences preferences = await SharedPreferences.getInstance();
var myToken = preferences.getString('token');
print(myToken);
  runApp( MyApp(token: myToken,));
  
}

class MyApp extends StatefulWidget {
  final token;

  const MyApp({
    @required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
      ),
      
       home: (widget.token != null && JwtDecoder.isExpired(widget.token) == false )
       ?home(token: widget.token):log()
    );
  }
}
    
    
  


