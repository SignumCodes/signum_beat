// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../providers/auth/auth_provider.dart';
//
// class SignUp extends StatelessWidget {
//   const SignUp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthenticationProvider>(context);
//     return  Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment:MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//                 onPressed: (){
//                   authProvider.signInWithGoogle();
//                 },
//                 icon: Icon(Icons.check),
//                 label:Text('Login')
//             ),
//             ElevatedButton.icon(
//                 onPressed: (){
//                   authProvider.signOut();
//                 },
//                 icon: Icon(Icons.check),
//                 label:Text('Logout')
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
