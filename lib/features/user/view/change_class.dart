import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/core/styles/themes.dart';
import 'package:core_book/core/widgets/constant.dart';
import 'package:core_book/features/user/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fw_tab_bar/fw_tab_bar.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/local/cache_helper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChangeClass extends StatelessWidget {
  const ChangeClass({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
      ..getClass(context: context),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 14,),
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
                          'تغييرر المحتوى',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14,),
                    Center(
                      child: TabBarWidget(
                        firstTab: 'الصفوف',
                        secondTab: 'الدورات',
                        onTabChanged: (int index) {
                          cubit.onTabChanged(t: index);
                        },
                      ),
                    ),
                    SizedBox(height: 16,),
                   cubit.tab==1?
                   ConditionalBuilder(
                        condition:cubit.getClassModel.isNotEmpty,
                        builder: (c){
                          return  Expanded(
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: cubit.getClassModel.length,
                                itemBuilder:(context,index){
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          CacheHelper.saveData(
                                            key: 'class',
                                            value: cubit.getClassModel[index].name,
                                          ).then((value) {
                                            CacheHelper.saveData(
                                              key: 'classId',
                                              value: cubit.getClassModel[index].id,
                                            ).then((value) {
                                              className=cubit.getClassModel[index].name;
                                              classId= cubit.getClassModel[index].id;
                                              navigateAndFinish(context, HomeUser());
                                            });
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                          height: 45,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset('assets/images/fluent_edit-20-regular (1).png'),
                                              Text(
                                                cubit.getClassModel[index].name,
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
                                      SizedBox(height: 12,),
                                    ],
                                  );
                                }),
                          );
                        },
                        fallback: (c)=>Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: primaryColor,)
                            ],
                          ),
                        )
                    ):
                   ConditionalBuilder(
                       condition:cubit.getCourseModel.isNotEmpty,
                       builder: (c){
                         return  Expanded(
                           child: ListView.builder(
                               physics: AlwaysScrollableScrollPhysics(),
                               itemCount: cubit.getCourseModel.length,
                               itemBuilder:(context,index){
                                 return Column(
                                   children: [
                                     GestureDetector(
                                       onTap:(){
                                         CacheHelper.saveData(
                                           key: 'class',
                                           value: cubit.getCourseModel[index].name,
                                         ).then((value) {
                                           CacheHelper.saveData(
                                             key: 'classId',
                                             value: cubit.getCourseModel[index].id,
                                           ).then((value) {
                                             className=cubit.getCourseModel[index].name;
                                             classId= cubit.getCourseModel[index].id;
                                             navigateAndFinish(context, HomeUser());
                                           });
                                         });
                                       },
                                       child: Container(
                                         padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                         height: 45,
                                         width: double.maxFinite,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(6),
                                           color: Colors.white,
                                           boxShadow: [
                                             BoxShadow(
                                               color: Colors.black.withOpacity(0.3),
                                               blurRadius: 4,
                                               spreadRadius: 1,
                                               offset: const Offset(0, 2),
                                             ),
                                           ],
                                         ),
                                         child: Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Image.asset('assets/images/fluent_edit-20-regular (1).png'),
                                             Text(
                                               cubit.getCourseModel[index].name,
                                               style: TextStyle(
                                                 fontSize: 16,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black87,
                                               ),
                                             ),
                                             Text(
                                               ': العنوان',
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
                                     SizedBox(height: 12,),
                                   ],
                                 );
                               }),
                         );
                       },
                       fallback: (c)=>Expanded(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             CircularProgressIndicator(color: primaryColor,)
                           ],
                         ),
                       )
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
