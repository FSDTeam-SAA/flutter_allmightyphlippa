// import 'package:flutter/material.dart';
// import 'package:flutter_almightyflippa/features/auth/presentation/screens/home_screen.dart';
// import '../../../../core/common/widgets/app_scaffold.dart';
// import '../../../../core/constants/app_colors.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;

//   static const List<Widget> _pages = <Widget>[
//     HomeScreen(),
//     Center(child: Text('Live TV', style: TextStyle(color: AppColors.white, fontSize: 20))),
//     Center(child: Text('Movies', style: TextStyle(color: AppColors.white, fontSize: 20))),
//     Center(child: Text('Series', style: TextStyle(color: AppColors.white, fontSize: 20))),
//     Center(child: Text('My Profile', style: TextStyle(color: AppColors.white, fontSize: 20))),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppScaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: AppColors.scaffoldBackground,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppColors.white,
//         unselectedItemColor: AppColors.secondaryText,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.live_tv_outlined), label: 'Live TV'),
//           BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), label: 'Movies'),
//           BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
//           BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'My Profile'),
//         ],
//       ),
//     );
//   }
// }
