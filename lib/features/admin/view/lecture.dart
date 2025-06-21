import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/admin/view/chapter.dart';
import 'package:core_book/features/user/view/Chapter/chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class LectureAdmin extends StatelessWidget {
  const LectureAdmin({super.key, required this.teacherId});

  final String teacherId;
  static TextEditingController tittleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getLectureOfTeacher(context: context, teacherId: teacherId),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddLectureSuccessState){
            tittleController.text='';
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: const Color(0xFFF5F5F8),
                                boxShadow: [

                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
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
                                  ConditionalBuilder(
                                    condition: state is !AddLectureLoadingState,
                                    builder: (c){
                                      return GestureDetector(
                                        onTap: (){
                                          if(tittleController.text != ''){
                                            cubit.addLecture(
                                              name: tittleController.text.trim(),
                                              context: context,
                                              teacherId: teacherId,
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
                                  SizedBox(height: 12,),
                                ],
                              ),
                            ),
                            SizedBox(height: 26,),
                            ConditionalBuilder(
                                condition: cubit.getLectureModel.isNotEmpty,
                                builder: (c){
                                  return  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: cubit.getLectureModel.length,
                                      itemBuilder:(context,index){
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap:(){
                                               navigateTo(context, ChapterAdmin(lectureId: cubit.getLectureModel[index].id.toString()));
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
                                                    GestureDetector(
                                                      onTap:(){
                                                        cubit.deleteLecture(context: context,
                                                            idLecture: cubit.getLectureModel[index].id.toString(),
                                                            teacherId: teacherId);
                                                      },
                                                      child: Container(
                                                        width: 40,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Icon(Icons.delete,color: Colors.white,size: 18,),
                                                      ),
                                                    ),
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
                                      });
                                },
                                fallback: (c)=>Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: primaryColor,)
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
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
