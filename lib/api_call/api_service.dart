import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;

import '../common_widget/common_method.dart';
import '../utility/app_constant.dart';
import '../utility/colors.dart';
import 'api_config.dart';
import 'api_utility.dart';

Future<void> apiServiceCall({
  required Map<String, dynamic> params,
  required String serviceUrl,
  required Function success,
  required Function error,
  required get_x.RxBool isStopAction,
  required get_x.RxBool isLoading,
  required String methodType,
  bool isFromLogout = false,
  FormData? formValues,
}) async {
  Map<String, dynamic>? tempParams = params;
  String? tempServiceUrl = serviceUrl;
  Function? tempSuccess = success;
  String? tempMethodType = methodType;
  Function? tempError = error;
  bool? tempIsFromLogout = isFromLogout;
  FormData? tempFormData = formValues;
  StreamSubscription<List<ConnectivityResult>>? subscription;
  if (await checkInternet()) {
    isLoading.value = true;
    if (isStopAction.value == true) {
      showProgressLoader();
    }
    if (tempFormData != null) {
      Map<String, dynamic> tempMap = <String, dynamic>{};
      for (var element in tempFormData.fields) {
        tempMap[element.key] = element.value;
      }
      FormData reGenerateFormData = FormData.fromMap(tempMap);
      for (var element in tempFormData.files) {
        reGenerateFormData.files.add(MapEntry(element.key, element.value));
      }
      tempFormData = reGenerateFormData;
    }

    Map<String, String> headerParameters;
    headerParameters = {};
    headerParameters = {'Accept': 'application/json'};
    // if (getUserType() != "") {
    //   String credentials = "${getPreference.read("email")}:${getPreference.read("password")}";
    //   Codec<String, String> stringToBase64 = utf8.fuse(base64);
    //   String encoded = stringToBase64.encode(credentials);
    //   print("Authorization token $encoded");
    //   headerParameters = {'Content-Type': 'application/json','Accept': 'application/json', 'Authorization': 'Basic $encoded'};
    // } else {
    //
    // }

    // try {
    Response response;
    if (tempMethodType == ApiConfig.methodGET) {
      response = await APIProvider.getDio().get(
        tempServiceUrl,
        queryParameters: tempParams,
        options: Options(headers: headerParameters, responseType: ResponseType.plain),
      );
    } else if (tempMethodType == ApiConfig.methodPUT) {
      response = await APIProvider.getDio().put(
        tempServiceUrl,
        data: tempFormData ?? tempParams,
        options: Options(headers: headerParameters, responseType: ResponseType.plain),
      );
    } else if (tempMethodType == ApiConfig.methodDELETE) {
      response = await APIProvider.getDio().delete(
        tempServiceUrl,
        data: tempParams,
        options: Options(headers: headerParameters, responseType: ResponseType.plain),
      );
    } else {
      response = await APIProvider.getDio().post(
        tempServiceUrl,
        data: tempFormData ?? tempParams,
        options: Options(headers: {'Accept': 'application/json', 'Content-Type': 'multipart/form-data'}, responseType: ResponseType.plain),
      );
    }
    if (kDebugMode) {
      print("---------------------------------------------");
      print(headerParameters);
      print(tempServiceUrl);
      print(tempParams);
      print(response.data);
      print(response.statusCode);
      print("---------------------------------------------");
    }

    if (handleResponse(response)) {
      if (isStopAction.value == true) {
        Navigator.of(get_x.Get.overlayContext!).pop();
      }
      isLoading.value = false;

      if (response.statusCode == 200) {
        tempSuccess(response);
      } else if (response.statusCode == 201) {
        tempSuccess(response);
      } else if (response.statusCode == 302) {
        tempError(response);
      } else if (response.statusCode == 400) {
        tempError(response);
      } else if (response.statusCode == 503) {
        tempError(response);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // getPreference.erase();
        // getPreference.write("userType", "");
        //Get.offAll(() => const PhoneNumberScreen());
      } else {
        tempError(response);
      }
    } else {
      if (isStopAction.value == true) {
        Navigator.of(get_x.Get.overlayContext!).pop();
      }
      isLoading.value = false;
      get_x.Get.showSnackbar(
        const get_x.GetSnackBar(
          margin: EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: colorFFFFFF,
          message: 'Something went wrong',
          borderRadius: 4,
          icon: Icon(Icons.info_outline, color: colorFFFFFF),
          duration: Duration(seconds: 3),
        ),
      );
      tempError(response);
    }
  } else {
    isStopAction.value = false;
    isLoading.value = false;
    showSnackBar(title: ApiConfig.error, message: makeSureWifi);
  }
}

// void handleAuthentication(bool tempIsFromLogout) {
//   if (!tempIsFromLogout) {
//     apiAlertDialog(
//       buttonTitle: logInAgain,
//       message: authenticationMessage,
//       isShowGoBack: false,
//       buttonCallBack: () {
//         getPreference.erase();
//         getPreference.write("userType", "");
//         //get_x.Get.offAll(() => const OnboardingScreen(), transition: get_x.Transition.rightToLeftWithFade);
//       },
//     );
//   } else {
//     getPreference.erase();
//     getPreference.write("userType", "");
//     //get_x.Get.offAll(() => const OnboardingScreen(), transition: get_x.Transition.rightToLeftWithFade);
//   }
// }

//* Function for check Internet Connection.....
Future<bool> checkInternet() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

bool handleResponse(Response response) {
  try {
    if (isNotEmptyString(response.toString())) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

// apiAlertDialog({required String message, String? buttonTitle, Function? buttonCallBack, bool isShowGoBack = true}) {
//   if (!get_x.Get.isDialogOpen!) {
//     get_x.Get.dialog(
//       WillPopScope(
//         onWillPop: () {
//           return isShowGoBack ? Future.value(true) : Future.value(false);
//         },
//         child: CupertinoAlertDialog(
//           title: const Text(appName),
//           content: Text(message),
//           actions: isShowGoBack
//               ? [
//                   CupertinoDialogAction(
//                     isDefaultAction: true,
//                     child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : tryAgain),
//                     onPressed: () {
//                       if (buttonCallBack != null) {
//                         buttonCallBack();
//                       } else {
//                         get_x.Get.back();
//                       }
//                     },
//                   ),
//                   CupertinoDialogAction(
//                     isDefaultAction: true,
//                     child: const Text(goBack),
//                     onPressed: () {
//                       get_x.Get.back();
//                       get_x.Get.back();
//                     },
//                   ),
//                 ]
//               : [
//                   CupertinoDialogAction(
//                     isDefaultAction: true,
//                     child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : tryAgain),
//                     onPressed: () {
//                       if (buttonCallBack != null) {
//                         buttonCallBack();
//                       } else {
//                         get_x.Get.back();
//                       }
//                     },
//                   ),
//                 ],
//         ),
//       ),
//       barrierDismissible: false,
//       transitionCurve: Curves.easeInCubic,
//       transitionDuration: const Duration(milliseconds: 400),
//     );
//   }
// }

showProgressLoader() {
  get_x.Get.dialog(
    WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StatefulBuilder(
        builder: (context, setState) {
          return SizedBox(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
        },
      ),
    ),
    barrierDismissible: false,
    barrierColor: Colors.transparent,
  );
}
