import 'package:core_book/features/admin/cubit/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/local/cache_helper.dart';
import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/model/ActiveOrderSubscriptionsModel.dart';
import '../../user/model/ClassModel.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/GetChapter.dart';
import '../../user/model/GetLecture.dart';
import '../../user/model/GetTeachers.dart';
import '../../user/model/PendingOrderSubscriptionsModel.dart';
import '../../user/model/ProfileModel.dart';
import '../../user/model/SubjectModel.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);

  void slid(){
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

  void deleteAds({required String id,required BuildContext context}) {
    emit(DeleteAdsLoadingState());
    DioHelper.deleteData(
      url: '/ads/$id',
    ).then((value) {
      getAdsModel.removeWhere((getAdsModel) => getAdsModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteAdsErrorState());
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


  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImages = resultList;
      emit(SelectedImagesState());
    }
  }

  addAds({required String tittle, required String desc, required BuildContext context,})async{
    emit(AddAdsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddAdsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'name': tittle,
          'description': desc,
        },
        ListFormat.multiCompatible
    );

      for (var file in selectedImages) {
        formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              file.path, filename: file.name,
              contentType: MediaType('image', 'jpeg'),
            ),
          ),
        );
      }

    DioHelper.postData(
      url: '/ads',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddAdsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addNotification({required String tittle, required String desc, required BuildContext context,})async{
    emit(AddNotificationLoadingState());
    DioHelper.postData(
      url: '/send-notification-to-role',
      data: {
        'title': tittle,
        'message': desc,
        'role': 'user',
      },
    ).then((value) {
      emit(AddNotificationSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddNotificationErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  signUp({required String name, required String phone, required String password, required String location, required String role, required BuildContext context,}){
    emit(SignUpLoadingState());
    DioHelper.postData(
      url: '/users',
      data:
      {
        'name': name,
        'phone': phone,
        'role': role,
        'location': location,
        'password': password,
      },
    ).then((value) {
      emit(SignUpSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(SignUpErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<ClassModel> getClassModel = [];
  void getClass({required BuildContext context,}) {
    emit(GetClassLoadingState());
    DioHelper.getData(
      url: '/class',
    ).then((value) {
      getClassModel = (value.data as List)
          .map((item) => ClassModel.fromJson
        (item as Map<String, dynamic>)).toList();
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

  List<Subscription> subscriptions = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  ActiveOrderSubscriptionsModel? activeOrderSubscriptionsModel;
  void activeOrderSubscriptions({required String page,required BuildContext context,}) {
    emit(ActiveOrderSubscriptionsLoadingState());
    DioHelper.getData(
      url: '/subscriptions/active?$page',
    ).then((value) {
      activeOrderSubscriptionsModel = ActiveOrderSubscriptionsModel.fromJson(value.data);
      subscriptions.addAll(activeOrderSubscriptionsModel!.subscriptions);
      pagination = activeOrderSubscriptionsModel!.pagination;
      currentPage = pagination!.page;
      if (currentPage >= pagination!.totalPages) {
        isLastPage = true;
      }
      emit(ActiveOrderSubscriptionsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(ActiveOrderSubscriptionsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<PendingOrderSubscriptionsModel> pendingOrderSubscriptionsModel = [];
  void pendingOrderSubscriptions({required BuildContext context}) {
    emit(PendingOrderOrderSubscriptionsLoadingState());
    DioHelper.getData(
      url: '/subscriptions?status=pending',
    ).then((value) {
      pendingOrderSubscriptionsModel = (value.data as List)
          .map((item) => PendingOrderSubscriptionsModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(PendingOrderOrderSubscriptionsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(PendingOrderOrderSubscriptionsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  changeStatusOrder({required BuildContext context, required String status, required String idSubscriptions}){
    emit(ChangeStatusOrderLoadingState());
    DioHelper.patchData(
      url: '/subscription/$idSubscriptions',
      data: {
        'status':status,
      },
    ).then((value) {
      pendingOrderSubscriptionsModel.removeWhere((subscriptions) => subscriptions.id.toString() == idSubscriptions);
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      emit(ChangeStatusOrderSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(ChangeStatusOrderErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  deleteClass({required BuildContext context,required String idClass}){
    emit(DeleteClassLoadingState());
    DioHelper.deleteData(
      url: '/class/$idClass',
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      emit(DeleteClassSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeleteClassErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addClass({required BuildContext context,required String name}){
    emit(AddClassLoadingState());
    DioHelper.postData(
      url: '/class',
      data: {
        'name': name
      }
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      emit(AddClassSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(AddClassErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<SubjectModel> getSubjectModel = [];
  void getSubject({required BuildContext context,}) {
    emit(GetSubjectLoadingState());
    DioHelper.getData(
      url: '/class/$classId',
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

  deleteSubject({required BuildContext context,required String idSubject}){
    emit(DeleteSubjectLoadingState());
    DioHelper.deleteData(
      url: '/subject/$idSubject',
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getSubjectModel = [];
      getSubject(context: context);
      emit(DeleteSubjectSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeleteSubjectErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addSubject({ required BuildContext context, required String name, required String color}){
    emit(AddSubjectLoadingState());
    print(CacheHelper.getData(key: 'classId'));
    DioHelper.postData(
        url: '/subject',
        data: {
          'name': name,
          'classId': classId,
          'color': color,
        }
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getSubjectModel=[];
      getSubject(context: context);
      emit(AddSubjectSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddSubjectErrorState());
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

  List<XFile> selectedImagesTeacher = [];
  Future<void> pickImagesTeacher() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImagesTeacher = resultList;
      emit(SelectedImagesState());
    }
  }

  addTeacher({required String name,required String subjectId, required String price, required BuildContext context,})async{
    emit(AddTeachersLoadingState());
    if (selectedImagesTeacher.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddTeachersErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'name': name,
          'subjectId': subjectId,
          'price': price,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImagesTeacher) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/teacher',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      getTeachersModel=[];
      getTeachers(context: context, subjectId: subjectId);
      emit(AddTeachersSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddTeachersErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  deleteTeacher({required BuildContext context,required String idTeacher,required String subjectId}){
    emit(DeleteTeachersLoadingState());
    DioHelper.deleteData(
      url: '/teacher/$idTeacher',
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getTeachersModel = [];
      getTeachers(context: context, subjectId: subjectId);
      emit(DeleteTeachersSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeleteTeachersErrorState());
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

  deleteLecture({required BuildContext context,required String idLecture,required String teacherId}){
    emit(DeleteLectureLoadingState());
    print(idLecture);
    DioHelper.deleteData(
      url: '/lecture/$idLecture',
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getLectureOfTeacher(context: context, teacherId: teacherId);
      emit(DeleteLectureSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(DeleteLectureErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addLecture({required BuildContext context,required String name,required String teacherId}){
    emit(AddLectureLoadingState());
    DioHelper.postData(
        url: '/lecture',
        data: {
          'title': name ,
          'teacherId': teacherId
        }
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getLectureOfTeacher(context: context, teacherId: teacherId);
      emit(AddLectureSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(AddLectureErrorState());
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

  addChapter({
    required BuildContext context,
    required String videoUrl,
    required String attachment,
    required String summary,
    required String lectureId}){
    emit(AddChapterLoadingState());
    DioHelper.postData(
        url: '/chapter',
        data: {
          'videoUrl': videoUrl ,
          'attachment': attachment ,
          'summary': summary ,
          'lectureId': lectureId ,
        }
    ).then((value) {
      showToastSuccess(
        text:"تمت العملية بنجاح",
        context: context,
      );
      getChapterOfTeacher(context: context, lectureId: lectureId);
      emit(AddChapterSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(
          text:"حدث خطأ",
          context: context,
        );
        emit(AddChapterErrorState());
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

  
}