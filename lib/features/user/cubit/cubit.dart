import 'package:core_book/features/user/cubit/states.dart';
import 'package:core_book/features/user/model/ClassModel.dart';
import 'package:core_book/features/user/view/lecture.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/network/local/cache_helper.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../model/AllNotificationModel.dart';
import '../model/GetAdsModel.dart';
import '../model/GetChapter.dart';
import '../model/GetLecture.dart';
import '../model/GetTeachers.dart';
import '../model/ProfileModel.dart';
import '../model/SubjectModel.dart';
import '../view/subscription.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }

  int tab=1;
  void onTabChanged({required int t}){
    tab=t;
    emit(ValidationState());
  }

  void verifyToken({required BuildContext context}) {
    if(token == ''){
      return emit(VerifyTokenErrorState());
    }
    emit(VerifyTokenLoadingState());
    DioHelper.getData(
        url: '/verify-token',
        token: token
    ).then((value) {
      bool isValid = value.data['valid'];
      if (isValid) {
        emit(VerifyTokenSuccessState());
      } else {
        signOut(context);
        showToastError(text: "توكن غير صالح", context: context);
        emit(VerifyTokenErrorState());
      }
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(VerifyTokenErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetAds> getAdsModel = [];
  void getAds({required BuildContext? context,}) {
    emit(GetAdsLoadingState());
    DioHelper.getData(
      url: '/ads',
    ).then((value) {
      getAdsModel = (value.data as List)
          .map((item) => GetAds.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  ProfileModel? profileModel;
  void getProfile({required BuildContext context,}) {
    emit(GetProfileLoadingState());
    DioHelper.getData(
        url: '/users/$id',
        token: token
    ).then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetProfileErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<ClassModel> getClassModel = [];
  List<ClassModel> getCourseModel = [];
  void getClass({required BuildContext context,}) {
    emit(GetClassLoadingState());
    DioHelper.getData(
      url: '/class',
    ).then((value) {
      getClassModel.clear();
      getCourseModel.clear();
      List<ClassModel> allClasses = (value.data as List)
          .map((item) => ClassModel.fromJson(item as Map<String, dynamic>))
          .toList();
      for (var classItem in allClasses) {
        if (classItem.name.startsWith("دورة")) {
          getCourseModel.add(classItem);
        } else {
          getClassModel.add(classItem);
        }
      }
      emit(GetClassSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(GetClassErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<SubjectModel> getSubjectModel = [];
  void getSubject({required BuildContext context,}) {
    emit(GetSubjectLoadingState());
    DioHelper.getData(
      url: '/class/${CacheHelper.getData(key: 'classId') ?? 1 }',
    ).then((value) {
      getSubjectModel = (value.data as List)
          .map((item) => SubjectModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetSubjectSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(GetSubjectErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetTeachers> getTeachersModel = [];
  void getTeachers({required BuildContext? context,required String subjectId}) {
    emit(GetTeachersLoadingState());
    DioHelper.getData(
      url: '/subject/$subjectId',
    ).then((value) {
      getTeachersModel = (value.data as List)
          .map((item) => GetTeachers.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetTeachersSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetTeachersErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  bool? subscribed;
  void checkSubscription({required BuildContext context,required String teacherId,required int index,}) {
    emit(CheckSubscriptionLoadingState());
    DioHelper.postData(
      url: '/check-subscription',
      data: {
        'studentId': id,
        'teacherId': teacherId,
      }
    ).then((value) {
      subscribed=value.data['subscribed'];
      if( subscribed == true){
           navigateTo(context, Lecture(teacherId: teacherId));
      }else {
        showToastInfo(text: 'رجائا قم بالاشتراك بالدورة اولا', context: context);
        navigateTo(context, SubscriptionUser(
          price: getTeachersModel[index].price.toString(),
          subject: getTeachersModel[index].subject.name.toString(),
          teacherId: teacherId,
        ));
      }
      emit(CheckSubscriptionSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(CheckSubscriptionErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void sendSubscription({required BuildContext context,required String teacherId,}) {
    emit(SendSubscriptionLoadingState());
    DioHelper.postData(
        url: '/subscription',
        data: {
          'studentId': id,
          'teacherId': teacherId,
        }
    ).then((value) {
      emit(SendSubscriptionSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(SendSubscriptionErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetLecture> getLectureModel = [];
  void getLectureOfTeacher({required BuildContext context,required String teacherId}) {
    emit(GetLectureLoadingState());
    DioHelper.getData(
      url: '/teacher/$teacherId',
    ).then((value) {
      getLectureModel = (value.data as List)
          .map((item) => GetLecture.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetLectureSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetLectureErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<GetChapter> getChapterModel = [];
  void getChapterOfTeacher({required BuildContext context,required String lectureId}) {
    emit(GetChapterLoadingState());
    DioHelper.getData(
      url: '/lecture/$lectureId',
    ).then((value) {
      getChapterModel = (value.data as List)
          .map((item) => GetChapter.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetChapterSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetChapterErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  Future<void> openAttachment(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    } else {
      throw 'لا يمكن فتح الرابط: $url';
    }
  }

  List<Log> allNotification = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  AllNotificationModel? notificationModel;
  void getNotification({required String page,required String role, BuildContext? context,}) {
    emit(GetAllNotificationLoadingState());
    DioHelper.getData(
      url: '/notifications-log?role=$role&page=$page',
    ).then((value) {
      notificationModel = AllNotificationModel.fromJson(value.data);
      allNotification.addAll(notificationModel!.logs);
      pagination = notificationModel!.pagination;
      currentPage = pagination!.page;
      if (currentPage >= pagination!.totalPages) {
        isLastPage = true;
      }
      emit(GetAllNotificationSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetAllNotificationErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }
  
}