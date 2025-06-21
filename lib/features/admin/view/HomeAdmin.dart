import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/admin/view/add_ads.dart';
import 'package:core_book/features/admin/view/add_notification.dart';
import 'package:core_book/features/admin/view/add_person.dart';
import 'package:core_book/features/admin/view/pending_order.dart';
import 'package:core_book/features/admin/view/teacher_admin.dart';
import 'package:core_book/features/admin/view/teacher_admin.dart';
import 'package:core_book/features/user/view/ads.dart';
import 'package:core_book/features/user/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'package:intl/intl.dart';

import 'ChangeClassAdmin.dart';
import 'active_order.dart';
import 'dart:ui' as ui;

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  static int currentIndex = 0;
  static TextEditingController tittleController = TextEditingController();
  static TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getAds(context: context)
        ..getProfile(context: context)
        ..getSubject(context: context)
        ..verifyToken(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddSubjectSuccessState) {
            tittleController.text='';
            colorController.text='';
            }
        },
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    ': مواد هذا الصف',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 18,),
                            ConditionalBuilder(
                                condition: cubit.getSubjectModel.isNotEmpty,
                                builder: (c){
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: (cubit.getSubjectModel.length / 2).ceil(),
                                    itemBuilder: (context, index) {
                                      int firstItemIndex = index * 2;
                                      int secondItemIndex = firstItemIndex + 1;
                                      return Directionality(
                                        textDirection: ui.TextDirection.rtl,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap:(){
                                                   navigateTo(context, TeacherAdmin(subjectId: cubit.getSubjectModel[firstItemIndex].id.toString(),));
                                                  },
                                                  child: Container(
                                                    height: 144,
                                                    decoration: BoxDecoration(
                                                      color: Color(int.parse("0xFF${cubit.getSubjectModel[firstItemIndex].color}")),
                                                      borderRadius: BorderRadius.circular(16),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.08),
                                                          blurRadius: 5,
                                                          spreadRadius: 1,
                                                          offset: Offset(0, 3),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          cubit.getSubjectModel[firstItemIndex].name,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap:(){
                                                             cubit.deleteSubject(context: context, idSubject: cubit.getSubjectModel[index].id.toString());
                                                          },
                                                          child: Container(
                                                            width: 50,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Icon(Icons.delete,color: Colors.white,size: 18,),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              if (secondItemIndex < cubit.getSubjectModel.length)
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap:(){
                                                     navigateTo(context, TeacherAdmin(subjectId: cubit.getSubjectModel[secondItemIndex].id.toString(),));
                                                    },
                                                    child: Container(
                                                      height: 144,
                                                      decoration: BoxDecoration(
                                                        color: Color(int.parse("0xFF${cubit.getSubjectModel[secondItemIndex].color}")),
                                                        borderRadius: BorderRadius.circular(16),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.08),
                                                            blurRadius: 5,
                                                            spreadRadius: 1,
                                                            offset: Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Text(
                                                            cubit.getSubjectModel[secondItemIndex].name,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 16,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap:(){
                                                              cubit.deleteSubject(context: context, idSubject: cubit.getSubjectModel[index].id.toString());
                                                            },
                                                            child: Container(
                                                              width: 50,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(8),
                                                              ),
                                                              child: Icon(Icons.delete,color: Colors.white,size: 18,),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              else
                                                Expanded(child: Container()),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                fallback: (c)=>Container()
                            ),
                            SizedBox(height: 26,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                                color: const Color(0xFFF5F5F8),

                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 26,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        textAlign: TextAlign.right,
                                        'اضافة صف جديد',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  CustomTextField(
                                    controller: tittleController,
                                    hintText: 'اسم الصف',
                                    prefixIcon: Icons.title,
                                  ),
                                  SizedBox(height: 12,),
                                  CustomTextField(
                                    controller: colorController,
                                    hintText: 'رمز اللون',
                                    prefixIcon: Icons.color_lens_outlined,
                                  ),
                                  SizedBox(height: 12,),
                                  ConditionalBuilder(
                                    condition: state is !AddSubjectLoadingState,
                                    builder: (c){
                                      return GestureDetector(
                                        onTap: (){
                                          if(tittleController.text != '' && colorController.text != ''){
                                            cubit.addSubject(
                                              name: tittleController.text.trim(),
                                              color: colorController.text.trim(),
                                              context: context,
                                            );
                                          }else{
                                            showToastError(
                                              text: "رجائا املأ الحقول",
                                              context: context,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                  offset: const Offset(5, 5),
                                                ),
                                              ],
                                              borderRadius:  BorderRadius.circular(30),
                                              color: primaryColor
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(width: 50,),
                                              Text('حفظ',
                                                style: TextStyle(color: Colors.white,fontSize: 18 ),),
                                              Container(
                                                margin: EdgeInsets.all(6),
                                                height: double.maxFinite,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    borderRadius:  BorderRadius.circular(30),
                                                    color: Colors.white
                                                ),
                                                child: Icon(Icons.arrow_forward_ios_outlined,size: 22,color: primaryColor,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    fallback: (c)=> CircularProgressIndicator(color: primaryColor,),
                                  ),
                                  SizedBox(height: 26,),

                                ],
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
                  ),
              ),
            ),
          );
        },
      ),
    );
  }
}
