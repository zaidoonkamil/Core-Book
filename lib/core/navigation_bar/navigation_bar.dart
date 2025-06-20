// import 'package:flutter/material.dart';
//
// import '../../features/user/view/subscription.dart';
// import '../styles/themes.dart';
//
// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});
//
//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }
//
// class _BottomNavBarState extends State<BottomNavBar> {
//   int currentIndex = 0;
//   List<Widget> screens =
//   [
//     Home(),
//     Home(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: screens[currentIndex],
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(70),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 10,
//               spreadRadius: 3,
//               offset: Offset(0, -3)
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           selectedItemColor: primaryColor,
//           backgroundColor: Colors.white,
//           showUnselectedLabels: true,
//           currentIndex: currentIndex,
//           items: [
//             BottomNavigationBarItem(
//                 label: "الرئيسية",
//               icon: currentIndex==1?Icon(Icons.home): Icon(Icons.home_outlined),
//             ),
//             BottomNavigationBarItem(
//                 label: "الرئيسية",
//               icon: currentIndex==0?Icon(Icons.home): Icon(Icons.home_outlined),
//             ),
//           ],
//           onTap: (val) {
//             setState(() {
//               currentIndex = val;
//             });
//           },
//         ),
//       )
//       ,
//     );
//   }
// }