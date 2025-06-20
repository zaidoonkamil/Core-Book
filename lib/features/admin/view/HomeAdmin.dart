import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/admin/view/add_ads.dart';
import 'package:core_book/features/admin/view/add_notification.dart';
import 'package:core_book/features/admin/view/add_person.dart';
import 'package:core_book/features/admin/view/pending_order.dart';
import 'package:core_book/features/user/view/ads.dart';
import 'package:core_book/features/user/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../user/view/change_class.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:intl/intl.dart';

import 'ChangeClassAdmin.dart';
import 'active_order.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static int currentIndex = 0;
  static List<String> adsImages = [
    'assets/images/Rectangle 29.png',
    'assets/images/Rectangle 29.png',
    'assets/images/Rectangle 29.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getAds(context: context)
        ..getProfile(context: context)
        //..getSubject(context: context)
        ..verifyToken(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: ConditionalBuilder(
                  condition: cubit.profileModel != null,
                  builder: (c){
                    return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 24,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      navigateTo(context, ProfileUse(
                                        name: cubit.profileModel!.name,
                                        phone: cubit.profileModel!.phone,
                                      ),);
                                    },
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              '! مرحباا مجددا',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              cubit.profileModel!.name.toString(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 8,),
                                        Image.asset('assets/images/profilehome.png'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 26,),
                            Column(
                              children: [
                                ConditionalBuilder(
                                  condition:cubit.getAdsModel.isNotEmpty,
                                  builder:(c){
                                    return Column(
                                      children: [
                                        CarouselSlider(
                                          items: cubit.getAdsModel.expand((entry) => entry.images.map((imageUrl) => Builder(
                                            builder: (BuildContext context) {
                                              DateTime dateTime = DateTime.parse(entry.createdAt.toString());
                                              String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                              return GestureDetector(
                                                onTap: (){
                                                  navigateTo(context, AdsUser(
                                                    tittle: entry.title,
                                                    desc: entry.description,
                                                    image: imageUrl,
                                                    time: formattedDate,
                                                  ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                    child: Image.network(
                                                      "$url/uploads/$imageUrl",
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context, error, stackTrace) =>
                                                          Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ))).toList(),
                                          options: CarouselOptions(
                                            height: 140,
                                            viewportFraction: 0.85,
                                            enlargeCenterPage: true,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            reverse: true,
                                            autoPlay: true,
                                            autoPlayInterval: const Duration(seconds: 6),
                                            autoPlayAnimationDuration:
                                            const Duration(seconds: 1),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            scrollDirection: Axis.horizontal,
                                            onPageChanged: (index, reason) {
                                              currentIndex=index;
                                              cubit.slid();
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: List.generate(cubit.getAdsModel.length, (index) {
                                            return Container(
                                              width: currentIndex == index ? 30 : 8,
                                              height: 7.0,
                                              margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: currentIndex == index
                                                    ? primaryColor
                                                    : const Color(0XFFC1D1F9),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    );
                                  },
                                  fallback: (c)=> Container(),
                                ),
                                SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        cubit.deleteAds(
                                            id: cubit.getAdsModel[currentIndex].id.toString(),
                                            context: context);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.red
                                          ),
                                          child: Icon(Icons.delete,color: Colors.white,)),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        navigateTo(context, AddAds());
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.blue
                                          ),
                                          child: Icon(Icons.add,color: Colors.white,)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 26,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        navigateTo(context, AddPerson());
                                      },
                                      child: Container(
                                        height: 54,
                                        decoration: BoxDecoration(
                                            borderRadius:  BorderRadius.circular(12),
                                            color: primaryColor
                                        ),
                                        child: Center(
                                          child: Text('اضافة مستخدم',
                                            style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6,),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                        navigateTo(context, AddNotification());
                                      },
                                      child: Container(
                                        height: 54,
                                        decoration: BoxDecoration(

                                            borderRadius:  BorderRadius.circular(12),
                                            color: primaryColor
                                        ),
                                        child: Center(
                                          child: Text('ارسال اشعار',
                                            style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6,),
                            GestureDetector(
                              onTap: (){
                               navigateTo(context, PendingOrder());
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                width: double.maxFinite,
                                height: 54,
                                decoration: BoxDecoration(

                                    borderRadius:  BorderRadius.circular(12),
                                    color: primaryColor
                                ),
                                child: Center(
                                  child: Text('رؤية طلب الاشتراكات',
                                    style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                ),
                              ),
                            ),
                            SizedBox(height: 6,),
                            GestureDetector(
                              onTap: (){
                                navigateTo(context, ActiveOrder());
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                width: double.maxFinite,
                                height: 54,
                                decoration: BoxDecoration(

                                    borderRadius:  BorderRadius.circular(12),
                                    color: primaryColor
                                ),
                                child: Center(
                                  child: Text('رؤية الطلبة المشتركين',
                                    style: TextStyle(color: Colors.white,fontSize: 14 ),),
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            GestureDetector(
                              onTap: (){
                                navigateTo(context, ChangeClassAdmin());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                margin: const EdgeInsets.symmetric(horizontal: 22.0),
                                height: 40,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset('assets/images/cuida_edit-outline.png'),
                                    Text(
                                      CacheHelper.getData(key: 'class') ?? 'السادس العلمي',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      ': الصف',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 26,),
                          ],
                        )
                    );
                  },
                  fallback: (c)=>Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator(color: primaryColor,)),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
