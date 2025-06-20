import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/user/view/Chapter/chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Lecture extends StatelessWidget {
  const Lecture({super.key, required this.teacherId});

  final String teacherId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getLectureOfTeacher(context: context, teacherId: teacherId),
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
                          'الفصول الدراسية',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26,),
                    ConditionalBuilder(
                        condition:cubit.getLectureModel.isNotEmpty,
                        builder: (c){
                          return  Expanded(
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: cubit.getLectureModel.length,
                                itemBuilder:(context,index){
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          navigateTo(context, Chapter(lectureId: cubit.getLectureModel[index].id.toString()));
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
                                                cubit.getLectureModel[index].title,
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
