import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/core/styles/themes.dart';
import 'package:core_book/core/widgets/constant.dart';
import 'package:core_book/features/admin/view/HomeAdmin.dart';
import 'package:core_book/features/user/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChangeClassAdmin extends StatelessWidget {
  const ChangeClassAdmin({super.key});

  static TextEditingController tittleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getClass(context: context),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){
          if(state is DeleteClassSuccessState){
            navigateAndFinish(context, HomeAdmin());
          }
          if(state is AddClassSuccessState){
            tittleController.text='';
            navigateAndFinish(context, HomeAdmin());
          }
        },
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F8),
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
                          'تغييرر الصف',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
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
                            ConditionalBuilder(
                              condition: state is !AddClassLoadingState,
                              builder: (c){
                                return GestureDetector(
                                  onTap: (){
                                      if(tittleController.text != ''){
                                        cubit.addClass(
                                          name: tittleController.text.trim(),
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
                            ConditionalBuilder(
                                condition:cubit.getClassModel.isNotEmpty,
                                builder: (c){
                                  return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
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
                                                    classId=cubit.getClassModel[index].id;
                                                    navigateAndFinish(context, HomeAdmin());
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
                                                    GestureDetector(
                                                      onTap:(){
                                                        cubit.deleteClass(context: context, idClass: cubit.getClassModel[index].id.toString());
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
                                      });
                                },
                                fallback: (c)=>CircularProgressIndicator(color: primaryColor,)
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
