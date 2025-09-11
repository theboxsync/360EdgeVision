import 'package:flutter/foundation.dart';

bool isProduction = false;

class ApiConfig {
  static const String stagingHostname = "360edgevision.digitaltripolystudio.com";
  static const String productionHostname = "360edgevision.digitaltripolystudio.com";
  static const String hostname = kDebugMode ? stagingHostname : productionHostname;

  static const String baseUrl = "https://$hostname/";

  static const String methodPOST = "post";
  static const String methodGET = "get";
  static const String methodPUT = "put";
  static const String methodDELETE = "delete";

  static const String error = "Alert!";
  static const String success = "Success";
  static const String warning = "Warning";

  static String getProjects = "${baseUrl}fetch-projects.php";
}

const String administratorOwner = "Administrator Owner";
const String administrator = "Administrator";
const String user = "User";
const String reader = "Reader";
