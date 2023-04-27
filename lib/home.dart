import 'dart:convert';

import 'package:contact_lists/configs.dart';
import 'package:contact_lists/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  final token;
  const home({super.key,
   required this.token
   });

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

 
   TextEditingController _name = TextEditingController();
    TextEditingController _contact = TextEditingController();
    
     List? items;

  late String userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String,dynamic> jwtDecodedtoken = JwtDecoder.decode(widget.token);
  
  userId = jwtDecodedtoken['_id'];
  print(userId);
  getContacts(userId);
  }

   bool _isNotValidate = false;

  void AddContact() async {
    if (_name.text.isNotEmpty && _contact.text.isNotEmpty) {
      var regdata = {
        "userId":userId,
        "name": _name.text,
        "contact": _contact.text,
      };

      var response = await http.post(Uri.parse(addcontact),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regdata));
          // print(response.body);
      var jsonResponse =  jsonDecode(response.body);
      //print(jsonResponse['status']);

      if (jsonResponse['status']) {
        _contact.clear();
        _name.clear();
       Navigator.pop(context);
       getContacts(userId);
      } else {
        print("Something Went Wrong");
      }
    }else{
      setState(() {
        _isNotValidate = true;
      });
    }
  }
 
 void getContacts(userId) async{
var registereddata = {
        "userId" :userId,
       
      };

      var response = await http.get(Uri.parse(getcontactlist),
          headers: {"Content-Type": "application/json"});
       //   body:
          // jsonEncode(registereddata));
          print(response.statusCode);
           // print(response.body);
            
      var jsonResponse = jsonDecode(response.body);
      
    
      items = jsonResponse['success'];
 //print(jsonResponse['success']);
            

      setState(() {
        
      });
 }

void delete(id) async{
  var regdata = {
        "id" :id,
       
      };
       var response = await http.post(Uri.parse(deleted),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regdata));
         
      var jsonResponse =  jsonDecode(response.body);
      if(jsonResponse['status']){
            getContacts(userId);
      }
      
     

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Contacts',style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 56, 56, 56),
      ),
      backgroundColor: Color.fromARGB(255, 37, 37, 37),
      body: Column( crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             padding: EdgeInsets.only(top: 0.0,left: 30.0,right: 30.0,bottom: 30.0),
            
           ),
      Expanded(child: Container(
        decoration: BoxDecoration(
                   color: Color.fromARGB(255, 56, 56, 56),
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
               ),
               child: Padding(padding: const EdgeInsets.all(8.0),
                child: items == null ? null : ListView.builder(
                  itemCount: items!.length,
                  itemBuilder: 
                (context, int index) {
                 return Slidable(
                   key: const ValueKey(0),
                         endActionPane: ActionPane(
                           motion: const ScrollMotion(),
                           dismissible: DismissiblePane(onDismissed: () {}),
                           children: [
                             SlidableAction(
                               backgroundColor: Color(0xFFFE4A49),
                               foregroundColor: Colors.white,
                               icon: Icons.delete,
                               label: 'Delete',
                               onPressed: (BuildContext context) {
                                // print('${items![index]['_id']}');
                                 delete('${items![index]['_id']}');
                               },
                             ),
                           ],
                         ),
                  child: Card(
                    
                   borderOnForeground: false,
                           child: ListTile(
                            tileColor: Color.fromARGB(255, 56, 56, 56),
                             leading: Icon(Icons.phone, color: Colors.white,),
                             title: Text('${items![index]['name']}', style: TextStyle(color: Colors.white),),
                             subtitle: Text('${items![index]['contact']}',style: TextStyle(color: Colors.white)),
                             trailing: Icon(Icons.arrow_back, color: Colors.grey,),
                  ),
                         ),
                       );
                     }
                 ),
               ),
             ),
           )
         ],
       ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
         child: Icon(Icons.add, color: Colors.black,),
        onPressed: ()=> displayDialog(context)),
    );
  }


  Future<void> displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Contact'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                     prefixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Name",
                    //  border: OutlineInputBorder(
                        //  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  )  ),
                SizedBox(height: 10,),
                TextField(
                  controller: _contact,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                     prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Contact Number",
                     // border: OutlineInputBorder(
                         // borderRadius: BorderRadius.all(Radius.circular(10.0)))
                          ),
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black
                  ),
                  onPressed: (){
                  AddContact();
                 // addTodo();
                
                  }, child: Text("Add"))
              ],
            )
          );
        });
  }
}