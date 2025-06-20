import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HowAs extends StatelessWidget {
  const HowAs({super.key});

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
                child: Padding(
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
                            'من نحن',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 26,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 22),
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
                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'مرحبًا بكم في كور بوك، منصتكم التعليمية الذكية\nنحن في كور بوك نسعى إلى تقديم تجربة تعليمية متكاملة ومميزة من خلال توفير مجموعة متنوعة من الدورات المدفوعة التي تغطي مختلف المراحل الدراسية، بدءًا من المرحلة الابتدائية وحتى الثانوية وما بعدها \nهدفنا هو مساعدة الطلاب على تطوير مهاراتهم الأكاديمية وتحقيق أعلى النتائج من خلال محتوى تعليمي احترافي، مقدم من نخبة من المعلمين والمختصين في شتى المجالات الدراسية. في كور بوك، نؤمن أن التعلم يجب أن يكون بسيطًا، سهل الوصول، ومتاحًا للجميع في أي وقت ومن أي مكان. لهذا، نوفر واجهة استخدام سهلة، محتوى متجدد باستمرار، وأسعار تنافسية تناسب جميع الفئات \nانضم إلى آلاف الطلاب وابدأ رحلتك التعليمية معنا اليوم!',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12,),
                          ],
                        ),
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
