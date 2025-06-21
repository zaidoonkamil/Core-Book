import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/user/view/Chapter/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/ navigation/navigation.dart';
import '../../../../../core/styles/themes.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/show_toast.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class ChapterAdmin extends StatelessWidget {
  const ChapterAdmin({super.key, required this.lectureId});

  final String lectureId;
  static TextEditingController videoUrlController = TextEditingController();
  static TextEditingController attachmentController = TextEditingController();
  static TextEditingController summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..getChapterOfTeacher(context: context, lectureId: lectureId),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
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
                      condition: state is! GetChapterLoadingState,
                      builder: (context) {
                        return ConditionalBuilder(
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child:Container(
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
                                            SizedBox(height: 12,),
                                            CustomTextField(
                                              controller: videoUrlController,
                                              hintText: 'رابط الفيديو',
                                              prefixIcon: Icons.video_camera_back_outlined,
                                            ),
                                            SizedBox(height: 12,),
                                            CustomTextField(
                                              controller: attachmentController,
                                              hintText: 'رابط الملزمة',
                                              prefixIcon: Icons.attachment,
                                            ),
                                            SizedBox(height: 12,),
                                            CustomTextField(
                                              controller: summaryController,
                                              hintText: 'ملحقات مثل حلول اسئلة',
                                              prefixIcon: Icons.attach_file,
                                            ),
                                            SizedBox(height: 12,),
                                            ConditionalBuilder(
                                              condition: state is !AddChapterLoadingState,
                                              builder: (c){
                                                return GestureDetector(
                                                  onTap: (){
                                                    if(videoUrlController.text != '' && attachmentController.text != '' && summaryController.text != '' ){
                                                      cubit.addChapter(
                                                        context: context,
                                                        videoUrl: videoUrlController.text.trim(),
                                                        attachment: attachmentController.text.trim(),
                                                        summary: summaryController.text.trim(),
                                                        lectureId: lectureId,
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        );
                      },
                      fallback: (context) => Expanded(
                        child: Center(child: CircularProgressIndicator(color: primaryColor,))
                      ),
                    )

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
