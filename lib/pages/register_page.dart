// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_9/auth/constans.dart';
// import 'package:flutter_application_9/auth/helpers.dart';
// import 'package:http/http.dart';
// import 'package:http/http.dart' as http;

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   FocusNode femail = FocusNode();
//   FocusNode fpass = FocusNode();
//   FocusNode fcpass = FocusNode();
//   String? token;

//   bool isLoading = false;

//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // email Fucsed
//     femail.addListener(() {
//       setState(() {});
//     });
//     // password Foucsed
//     super.initState();
//     fpass.addListener(() {
//       setState(() {});
//     });
//     // confirm password Foucsed
//     super.initState();
//     fcpass.addListener(() {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFF5F5f3),
//         title: Text('Sign Up Screen'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               my_image(),
//               SizedBox(height: 50),
//               textfielf_email(nameController, femail, 'Name', Icons.person),
//               SizedBox(height: 10),
//               textfielf_email(emailController, femail, 'Email', Icons.email),
//               SizedBox(height: 10),
//               textfielf_email(
//                   passwordController, fpass, 'Password', Icons.lock),
//               SizedBox(height: 30),
//               Login_buttun(),
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   GestureDetector click_for_rigster() {
//     return GestureDetector(
//       onTap: () {
//         print('object');
//       },
//       child: Container(
//         child: RichText(
//           text: TextSpan(
//             text: "Don't have account ? ",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16),
//             children: <TextSpan>[
//               TextSpan(
//                 text: 'Rigster.',
//                 style:
//                     TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget Login_buttun() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: MaterialButton(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         minWidth: double.infinity,
//         color: Colors.red,
//         onPressed: () async {
//           print("object");
//           setState(() {
//             isLoading = true;
//           });

//           // التحقق من صحة الحقول
//           if (formKey.currentState != null &&
//               formKey.currentState!.validate()) {
//             try {
//               print("ss");
//               final response = await registerUser(
//                 nameController.text,
//                 emailController.text,
//                 passwordController.text,
//               );

//               final jsonResponse = jsonDecode(response.body);

//               if (response.statusCode == 200) {
//                 // عرض رسالة نجاح التسجيل ومسح البيانات المدخلة
//                 print('User Registered successfully');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(jsonResponse['message']),
//                   ),
//                 );
//                 nameController.clear();
//                 emailController.clear();
//                 passwordController.clear();
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(transformErrors(
//                       jsonResponse['errors'],
//                     )),
//                   ),
//                 );
//               }
//             } catch (error) {
//               // التعامل مع الأخطاء الغير متوقعة
//               print('Error: $error');
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('An error occurred. Please try again later.'),
//                 ),
//               );
//             } finally {
//               setState(() {
//                 isLoading = false;
//               });
//             }
//           } else {
//             setState(() {
//               isLoading = false;
//             });
//           }
//         },
//         child: Text(
//           'Sign Ups',
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//     );
//   }

//   Widget textfielf_email(TextEditingController _controller,
//       FocusNode _yourFocus, String inputName, IconData youIcon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: TextFormField(
//           validator: (value) {
//             if (value!.isEmpty) {
//               return ' Name is required';
//             }
//             return null;
//           },
//           focusNode: _yourFocus,
//           controller: _controller,
//           style: TextStyle(color: Colors.black, fontSize: 18),
          // decoration: InputDecoration(
          //   prefixIcon: Icon(
          //     youIcon,
          //     color: _yourFocus.hasFocus ? Colors.red : Colors.grey,
          //   ),
          //   contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          //   hintText: inputName,
          //   enabledBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10),
          //     borderSide: BorderSide(color: Color(0xffc5c5c5), width: 2.0),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(10),
          //     borderSide: BorderSide(
          //       color: Colors.red,
          //       width: 2.0,
          //     ),
          //   ),
          // ),
      //   ),
      // ),
//     );
//   }

//   //
//   Padding my_image() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
//       child: Container(
//         width: double.infinity,
//         height: 180,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('lib/images/pen.png'),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }

//   // register user function
//   Future<Response> registerUser(
//     String name,
//     String email,
//     String password,
//   ) async {
//     // this Route
//     String url = API_URL + 'register';

//     var resposne = await http.post(Uri.parse(url),
//         body: jsonEncode({
//           'name': name,
//           'email': email,
//           'password': password,
//         }),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json'
//         });
//     return resposne;
//   }
// }
