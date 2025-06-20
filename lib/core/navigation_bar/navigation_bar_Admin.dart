// import 'package:flutter/material.dart';
// import 'package:mr/features/admin/view/all_orders.dart';
// import 'package:mr/features/admin/view/home_admin.dart';
//
// import '../styles/themes.dart';
//
// class BottomNavBarAdmin extends StatefulWidget {
//   const BottomNavBarAdmin({super.key});
//
//   @override
//   State<BottomNavBarAdmin> createState() => _BottomNavBarAdminState();
// }
//
// class _BottomNavBarAdminState extends State<BottomNavBarAdmin> {
//   int currentIndex = 1;
//   List<Widget> screens = [
//     AllOrders(),
//     HomeAdmin(),
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
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 3,
//                 offset: Offset(0, -3)
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
//               label: "الطلبات",
//               icon: currentIndex==0?Icon(Icons.shopping_basket): Icon(Icons.shopping_basket_outlined),
//             ),
//             BottomNavigationBarItem(
//               label: "الرئيسية",
//               icon:  currentIndex==1?Icon(Icons.home): Icon(Icons.home_outlined),
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