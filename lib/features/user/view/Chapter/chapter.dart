import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/user/view/Chapter/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ navigation/navigation.dart';
import '../../../../../core/styles/themes.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class Chapter extends StatelessWidget {
  const Chapter({super.key, required this.lectureId});

  final String lectureId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()
        ..getChapterOfTeacher(context: context, lectureId: lectureId),
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
                          'تفاصيل الفصل',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 26,),
                    ConditionalBuilder(
                        condition:cubit.getChapterModel.isNotEmpty,
                        builder: (c){
                          return Expanded(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Column(
                                children: [
                                  cubit.getChapterModel[0].videoUrl != ''? Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          navigateTo(context, VideoScreen(url: cubit.getChapterModel[0].videoUrl));
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 12),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Color(0xFFFFB260),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/octicon_video-24.png'),
                                              SizedBox(height: 6,),
                                              Text(
                                                'المحاضرة',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                    ],
                                  ):Container(),
                                  cubit.getChapterModel[0].attachment != ''? Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                         cubit.openAttachment(cubit.getChapterModel[0].attachment);
                                         },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 12),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Color(0xFFEF7069),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/Group ss(1).png'),
                                              SizedBox(height: 6,),
                                              Text(
                                                'الملازم',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                    ],
                                  ):Container(),
                                  cubit.getChapterModel[0].summary != ''? Column(
                                    children: [
                                      GestureDetector(
                                        onTap:(){
                                          cubit.openAttachment(cubit.getChapterModel[0].summary);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 12),
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Color(0xFF7725B2),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/basil_edit-outline.png'),
                                              SizedBox(height: 6,),
                                              Text(
                                                'حل الاسئلة',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12,),
                                    ],
                                  ):Container(),
                                ],
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
