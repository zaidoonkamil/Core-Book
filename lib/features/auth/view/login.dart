import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:core_book/features/auth/cubit/cubit.dart';
import 'package:core_book/features/auth/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/styles/themes.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../admin/view/HomeAdmin.dart';
import '../../user/view/home.dart';
import '../cubit/states.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginStates>(
        listener: (context,state){
          if(state is LoginSuccessState){
            CacheHelper.saveData(
              key: 'token',
              value: LoginCubit.get(context).token,
            ).then((value) {
              CacheHelper.saveData(
                key: 'id',
                value: LoginCubit.get(context).id,
              ).then((value) {
                CacheHelper.saveData(
                  key: 'role',
                  value: LoginCubit.get(context).role,
                ).then((value) {
                  token = LoginCubit.get(context).token.toString();
                  id = LoginCubit.get(context).id.toString();
                  adminOrUser = LoginCubit.get(context).role.toString();
                  if (adminOrUser == 'admin') {
                   navigateAndFinish(context, HomeAdmin());
                  } else {
                    navigateAndFinish(context, HomeUser());
                  }
                });
              });
            });
          }
        },
          builder: (context,state){
          var cubit=LoginCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 140,),
                        Image.asset(
                          'assets/images/Logo.png',
                          height: 100,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'CORE BOOK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 70),
                        Stack(
                          children: [
                            CustomTextField(
                              hintText: 'رقم الهاتف',
                              controller: userNameController,
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'رجائا اخل رقم الهاتف';
                                }
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              height: 48,
                              width: 80,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '+964',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: 'كلمة السر',
                          prefixIcon: Icons.lock,
                          controller: passwordController,
                          obscureText: true,
                          suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'رجائا اخل الرمز السري';
                            }
                          },
                        ),
                        // const SizedBox(height: 20),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   child: Align(
                        //     alignment: Alignment.centerRight,
                        //     child: GestureDetector(
                        //       onTap: () {},
                        //       child: const Text(
                        //         'نسيت كلمة المرور ؟',
                        //         style: TextStyle(color: primaryColor),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 60),
                        ConditionalBuilder(
                          condition: state is !LoginLoadingState,
                            builder: (c){
                              return GestureDetector(
                                onTap: (){
                                  if (formKey.currentState!.validate()) {
                                    cubit.signIn(
                                        phone: userNameController.text.trim(),
                                        password: passwordController.text.trim(),
                                        context: context
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
                                      Text('تسجيل الدخول',
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
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateTo(context, Register());
                              },
                              child: const Text(
                                'انشاء حساب ',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text("لا تمتلك حساب ؟ "),
                          ],
                        )
                      ],
                    ),
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
