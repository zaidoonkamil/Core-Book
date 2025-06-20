import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/core/widgets/show_toast.dart';
import 'package:core_book/features/user/view/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ navigation/navigation.dart';
import '../../../../core/styles/themes.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Teacher extends StatelessWidget {
  const Teacher({super.key, required this.subjectId});

  final String subjectId;
  static ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getTeachers(context: context, subjectId: subjectId),
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
                          'اختر الاستاذ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26,),
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
                                      cubit.checkSubscription(
                                          context: context,
                                          teacherId: cubit.getTeachersModel[index].id.toString(),
                                          index: index,
                                      );
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
