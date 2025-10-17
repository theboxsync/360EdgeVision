import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_call/api_config.dart';
import '../utility/colors.dart';
import '../utility/text_style.dart';

isNotEmptyString(String? string) {
  return string != null && string.isNotEmpty;
}

// String getUserType() {
//   return getPreference.read("userType") ?? "";
// }

// getObject(String key) {
//   return getPreference.read(key) != null ? json.decode(getPreference.read(key)) : null;
// }
//
// setObject(String key, value) {
//   getPreference.write(key, json.encode(value));
// }
//
// AuthDataModel? getUserData() {
//   if (getObject("authUserData") != null) {
//     AuthDataModel profileData = AuthDataModel.fromJson(getObject("authUserData"));
//     return profileData;
//   } else {
//     return AuthDataModel();
//   }
// }

showSnackBar({required String title, required String message}) {
  return Get.snackbar(
    title,
    message,
    backgroundColor: Colors.transparent,
    onTap: (_) {},
    shouldIconPulse: true,
    barBlur: 0,
    isDismissible: true,
    userInputForm: Form(
      child: Wrap(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: title == ApiConfig.success ? color808080 : color808080,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12.withOpacity(0.15), blurRadius: 20)],
            ),
            child: Wrap(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  width: double.infinity,
                  decoration: BoxDecoration(color: color000000, borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [Text(title, style: colorFFFFFFw60025)],
                      ),
                      const SizedBox(height: 15),
                      Text(message, style: colorFFFFFFw60025, overflow: TextOverflow.visible),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    borderRadius: 0,
    padding: EdgeInsets.zero,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    //boxShadows: <BoxShadow>[BoxShadow(color: Colors.black12.withOpacity(0.15), blurRadius: 16)],
    duration: const Duration(seconds: 4),
  );
}

Future<void> openSocialLinkIn(String url) async {
  final Uri uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
