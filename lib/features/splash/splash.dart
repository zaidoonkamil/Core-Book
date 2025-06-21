import 'package:core_book/features/admin/view/HomeAdmin.dart';
import 'package:flutter/material.dart';

import '../../core/ navigation/navigation.dart';
import '../../core/network/local/cache_helper.dart';
import '../../core/widgets/constant.dart';
import '../auth/view/login.dart';
import '../onboarding/onboarding.dart';
import '../user/view/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      Widget? widget;
      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      classId = CacheHelper.getData(key: 'classId') ?? 1;
      className = CacheHelper.getData(key: 'class') ?? 'السادس العلمي';
      if(CacheHelper.getData(key: 'token') == null){
        token='';
        if (onBoarding == true) {
          widget = const Login();
        } else {
          widget = OnboardingScreen();
        }
      }else{
        if(CacheHelper.getData(key: 'role') == null){
          widget = const Login();
          adminOrUser='user';
        }else{
          adminOrUser = CacheHelper.getData(key: 'role');
          if (adminOrUser == 'admin') {
           widget = HomeAdmin();
          }else{
            widget = HomeUser();
          }
        }
        token = CacheHelper.getData(key: 'token') ;
        id = CacheHelper.getData(key: 'id') ??'' ;
      }

      navigateAndFinish(context, widget);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Center(child:
                Image.asset('assets/images/$logo',width: 150,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}