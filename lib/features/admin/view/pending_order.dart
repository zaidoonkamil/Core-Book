import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/styles/themes.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class PendingOrder extends StatelessWidget {
  const PendingOrder({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()
        ..pendingOrderSubscriptions(context: context,),
      child: BlocConsumer<AdminCubit,AdminStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 16),
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
                          'الطلبات المقيدة',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ConditionalBuilder(
                      condition: cubit.pendingOrderSubscriptionsModel.isNotEmpty,
                      builder: (c){
                        return ConditionalBuilder(
                            condition: cubit.pendingOrderSubscriptionsModel.isNotEmpty,
                            builder: (c){
                              return Expanded(
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: cubit.pendingOrderSubscriptionsModel.length,
                                    itemBuilder: (context,index){
                                      DateTime dateTime = DateTime.parse(cubit.pendingOrderSubscriptionsModel[index].createdAt.toString());
                                      String formattedDate = DateFormat('yyyy/M/d').format(dateTime);
                                      return  Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54.withOpacity(0.2),
                                              blurRadius: 4,
                                              spreadRadius: 1,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    formattedDate,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color:primaryColor
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${cubit.pendingOrderSubscriptionsModel[index].id}",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        " طلب #",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                width: double.maxFinite,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color:cubit.pendingOrderSubscriptionsModel[index].status == 'pending'?
                                                  Colors.orange.withOpacity(0.1):cubit.pendingOrderSubscriptionsModel[index].status == 'active'?
                                                  Colors.blue.withOpacity(0.1):Colors.red.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  cubit.pendingOrderSubscriptionsModel[index].status,
                                                  style: TextStyle(
                                                    color: cubit.pendingOrderSubscriptionsModel[index].status == 'pending'?
                                                    Colors.orange:cubit.pendingOrderSubscriptionsModel[index].status == 'active'?
                                                    Colors.blue:Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'الاستاذ',
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text( cubit.pendingOrderSubscriptionsModel[index].teacher.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                                      Text( cubit.pendingOrderSubscriptionsModel[index].teacher.subject.subjectClass.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                                                      Text( cubit.pendingOrderSubscriptionsModel[index].teacher.subject.name,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text('\$ ',style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),),
                                                          Text( cubit.pendingOrderSubscriptionsModel[index].teacher.price.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 6,),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: Image.network(
                                                      '$url/uploads/${cubit.pendingOrderSubscriptionsModel[index].teacher.images[0]}',
                                                      width: 80,
                                                      height: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'الطالب',
                                                    style: TextStyle(
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Container(width: double.maxFinite,height: 1,color: Colors.grey,),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text( cubit.pendingOrderSubscriptionsModel[index].student.name,style: TextStyle(fontWeight: FontWeight.bold),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.person, color: Colors.grey,size: 16,),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text( cubit.pendingOrderSubscriptionsModel[index].student.phone,style: TextStyle(fontWeight: FontWeight.bold),),
                                                      const SizedBox(width: 6),
                                                      const Icon(Icons.phone, color: Colors.grey,size: 16,),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              );
                            },
                            fallback: (c)=>Expanded(child: Center(child: Text('لا يوجد بيانات ليتم عرضها',style: TextStyle(fontSize: 16),))));
                      },
                      fallback: (c)=>Expanded(child: Center(child: CircularProgressIndicator(color: primaryColor,))),
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
