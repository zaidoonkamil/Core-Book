import 'package:core_book/features/user/view/how_as.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ProfileUse extends StatelessWidget {
  const ProfileUse({super.key, required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit(),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 24,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: (){
                                navigateBack(context);
                              },
                              child: Icon(Icons.arrow_back_ios_new)),
                          const Text(
                            textAlign: TextAlign.right,
                            'حسابي',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 34,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/Group 1171275632 (1).png'),
                              SizedBox(height: 8,),
                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4,),
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 6,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80,),
                          GestureDetector(
                            onTap: (){
                              navigateTo(context, HowAs());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.arrow_back_ios_new_rounded),
                                    Row(
                                      children: [
                                        Text(
                                          'من نحن',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4,),
                                        Image.asset('assets/images/info-circle.png'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6,),
                                Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                                SizedBox(height: 14,),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap:()async{
                              final url =
                                  'https://wa.me/+964$phoneWoner?text=';
                              await launch(
                                url,
                                enableJavaScript: true,
                              ).catchError((e) {
                                showToastError(
                                  text: e.toString(),
                                  context: context,
                                );
                              });
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        // Image.asset('assets/images/Group 1171275618.png'),
                                        // SizedBox(width: 4,),
                                        Image.asset('assets/images/Group 1171275617.png'),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'الاتصال المباشر بالدعم',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4,),
                                        Image.asset('assets/images/Vector (1).png'),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6,),
                                Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                                SizedBox(height: 14,),
                              ],
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Icon(Icons.arrow_back_ios_new_rounded),
                          //         Row(
                          //           children: [
                          //             Text(
                          //               'تقييم التطبيق',
                          //               style: TextStyle(
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.grey,
                          //               ),
                          //             ),
                          //             SizedBox(width: 4,),
                          //             Image.asset('assets/images/solar_star-line-duotone.png'),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //     SizedBox(height: 6,),
                          //     Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                          //     SizedBox(height: 14,),
                          //   ],
                          // ),
                          // Column(
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Icon(Icons.arrow_back_ios_new_rounded),
                          //         Row(
                          //           children: [
                          //             Text(
                          //               'مشاركة التطبيق',
                          //               style: TextStyle(
                          //                 fontSize: 15,
                          //                 fontWeight: FontWeight.bold,
                          //                 color: Colors.grey,
                          //               ),
                          //             ),
                          //             SizedBox(width: 4,),
                          //             Image.asset('assets/images/octicon_share-16.png'),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //     SizedBox(height: 6,),
                          //     Container(width: double.maxFinite,height: 2,color: Colors.black12,),
                          //     SizedBox(height: 14,),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 90,),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text("هل ترغب في تسجيل الخروج ؟",
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("إلغاء",style: TextStyle(color: primaryColor),),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          signOut(context);
                                        },
                                        child: Text("نعم",style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                          },
                          child: Container(
                            height: 41,
                            width: double.maxFinite,
                            color: primaryColor.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/Group 6892.png'),
                                Text(
                                  'تسجيل الخروج',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20,height: 10,),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text("هل ترغب في حذف الحساب ؟",
                                    style: TextStyle(fontSize: 18),
                                    textAlign: TextAlign.center,),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("إلغاء",style: TextStyle(color: primaryColor),),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          showToastInfo(
                                              text: 'تم ارسال طلبك وسوف يتم الرد عليك قريبا',
                                              context: context);
                                        },
                                        child: Text("نعم",style: TextStyle(color: Colors.white),),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );

                          },
                          child: Container(
                            height: 41,
                            width: double.maxFinite,
                            color: primaryColor.withOpacity(0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/images/hugeicons_delete-02.png'),
                                Text(
                                  'حذف الحساب',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(width: 20,height: 10,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
