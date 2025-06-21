import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/user/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class SubscriptionUser extends StatelessWidget {
  const SubscriptionUser({super.key, required this.price, required this.subject, required this.teacherId});

  final String price;
  final String subject;
  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getProfile(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){
          if(state is SendSubscriptionSuccessState){
            showToastSuccess(text: 'تم ارسال طلبك بنجاح وسوف يتم الرد عليك قريبا', context: context);
            navigateAndFinish(context, HomeUser());
          }
        },
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: (){
                              navigateBack(context);
                            },
                            child: Icon(Icons.arrow_back_ios_new)),
                        const Text(
                          textAlign: TextAlign.right,
                          'الاشتراك',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26,),
                    ConditionalBuilder(
                        condition: cubit.profileModel != null,
                        builder: (c){
                          return Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/fluent_edit-20-regular (1).png'),
                                        Text(
                                          subject,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          ': المادة',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/carbon_currency.png'),
                                        Row(
                                          children: [
                                            Text(
                                              'د.ع',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                            SizedBox(width: 2,),
                                            Text(
                                              price,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          ': السعر',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/iconamoon_profile.png'),
                                        Text(
                                          cubit.profileModel!.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          ': الاسم',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/ph_phone-light.png'),
                                        Text(
                                          cubit.profileModel!.phone,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          ': رقم الهاتف',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset('assets/images/fluent_edit-20-regular (1).png'),
                                        Text(
                                          className,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          ': الصف',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    Container(
                                      width: double.maxFinite,
                                      height: 1,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(height: 12,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'قم بأرسال الحوالة الى الباركود المرفق ثم قم بالتأكيد لاخبار المسئول بأشتراكك لتفعيله',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/images/photo_2025-01-16_20-32-25 1.png'),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    ConditionalBuilder(
                                        condition: state is !SendSubscriptionLoadingState,
                                        builder: (c){
                                      return GestureDetector(
                                        onTap: (){
                                          cubit.sendSubscription(context: context, teacherId: teacherId);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                              borderRadius:  BorderRadius.circular(30),
                                              color: primaryColor
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(width: 50,),
                                              Text('تأكيد',
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
                                        fallback: (c)=>CircularProgressIndicator(color: primaryColor,)),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        fallback: (c)=>Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: primaryColor,),
                            ],
                          ),
                        )),
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
