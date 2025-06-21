import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/admin/view/lecture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class TeacherAdmin extends StatelessWidget {
  const TeacherAdmin({super.key, required this.subjectId});

  final String subjectId;
  static ScrollController? scrollController;
  static TextEditingController nameController = TextEditingController();
  static TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getTeachers(context: context, subjectId: subjectId),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is AddTeachersSuccessState){
            nameController.text='';
            priceController.text='';
            AdminCubit.get(context).selectedImagesTeacher=[];
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
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
                            'الاساتذة',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 26,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
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
                            SizedBox(height: 12,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  textAlign: TextAlign.right,
                                  'اضافة استاذ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                            GestureDetector(
                                onTap:(){
                                  cubit.pickImagesTeacher();
                                },
                                child:
                                cubit.selectedImagesTeacher.isEmpty?
                                Image.asset('assets/images/Group 1171275632 (1).png'):Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipOval(
                                    child: Image.file(
                                      File(cubit.selectedImagesTeacher[0].path),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: nameController,
                              hintText: 'الاسم',
                              prefixIcon: Icons.title,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل العنوان';
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: priceController,
                              hintText: 'سعر الدورة',
                              prefixIcon: Icons.price_change_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 20),
                            ConditionalBuilder(
                              condition: state is !AddTeachersLoadingState,
                              builder: (context){
                                return GestureDetector(
                                  onTap: (){
                                    if(nameController.text != '' && priceController.text != ''){
                                      cubit.addTeacher(
                                        name: nameController.text.trim(),
                                        price: priceController.text.trim(),
                                        subjectId: subjectId,
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
                                    height: 48,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                        borderRadius:  BorderRadius.circular(12),
                                        color: primaryColor
                                    ),
                                    child: Center(
                                      child: Text('انشاء الاعلان',
                                        style: TextStyle(color: Colors.white,fontSize: 18 ),),
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
                      SizedBox(height: 40,),
                      ConditionalBuilder(
                          condition:cubit.getTeachersModel.isNotEmpty,
                          builder: (c){
                            return Directionality(
                              textDirection: TextDirection.rtl,
                              child: GridView.custom(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                controller: scrollController,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 1,
                                  childAspectRatio: 0.9,
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                  childCount: cubit.getTeachersModel.length,
                                      (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        navigateTo(context, LectureAdmin(teacherId: cubit.getTeachersModel[index].id.toString()));
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            margin: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  spreadRadius: 2,
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Image.network(
                                                "$url/uploads/${cubit.getTeachersModel[index].images[0]}",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap:(){
                                                  cubit.deleteTeacher(context: context,idTeacher: cubit.getTeachersModel[index].id.toString(), subjectId: subjectId);
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
                                              Container(
                                                margin: const EdgeInsets.all(4),
                                                padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 6),
                                                width: double.maxFinite,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Text(cubit.getTeachersModel[index].name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(color: Colors.white,fontSize: 14),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
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
            ),
          );
        },
      ),
    );
  }
}
