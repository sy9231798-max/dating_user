import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> pushNavigation({Bindings? binding, required Widget widget}) async {
  Get.to(()=>widget, transition: Transition.rightToLeft, duration: Duration(milliseconds: 300), binding: binding);
  // await Navigator.of(context).push(
  //   PageRouteBuilder(
  //     pageBuilder: (_, __, ___) => widget,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       Define your custom transition here, e.g., a slide transition
  // var begin = Offset(1.0, 0.0); // Start from right
  // var end = Offset.zero; // End at center
  // var curve = Curves.easeOut;
  //
  // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  // return SlideTransition(position: animation.drive(tween), child: child);
  // },
  // transitionDuration: Duration(milliseconds: 300), // Set duration
  // ),
  // );
}

Future<void> replaceNavigation({Bindings? binding, required Widget widget}) async {
  Get.off(() => widget, transition: Transition.rightToLeft, duration: Duration(milliseconds: 300), binding: binding);

  // await Navigator.of(context).pushReplacement(
  //   PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => widget,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       // Define your custom transition here, e.g., a slide transition
  //       var begin = Offset(1.0, 0.0); // Start from right
  //       var end = Offset.zero; // End at center
  //       var curve = Curves.easeOut;
  //
  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //       return SlideTransition(position: animation.drive(tween), child: child);
  //     },
  //     transitionDuration: Duration(milliseconds: 300), // Set duration
  //   ),
  // );
}

PageRouteBuilder<dynamic> getNavigator(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define your custom transition here, e.g., a slide transition
      var begin = Offset(1.0, 0.0); // Start from right
      var end = Offset.zero; // End at center
      var curve = Curves.easeOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: Duration(milliseconds: 300), // Set duration
  );
}

// void playNavigation(BuildContext context, BlocProvider blocProvider) {
//   Navigator.push(
//     context,
//     PageRouteBuilder(
//       pageBuilder: (_, __, ___) {
//         return blocProvider;
//       },
//       transitionDuration: const Duration(milliseconds: 400),
//       transitionsBuilder: (_, animation, __, child) {
//         const begin = Offset(0.0, 1.0);
//         const end = Offset.zero;
//         const curve = Curves.ease;
//
//         final tween = Tween(
//           begin: begin,
//           end: end,
//         ).chain(CurveTween(curve: curve));
//         return SlideTransition(position: animation.drive(tween), child: child);
//       },
//     ),
//   );
// }
