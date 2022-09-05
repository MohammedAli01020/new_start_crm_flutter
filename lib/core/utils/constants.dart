import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../features/login/domain/entities/current_employee.dart';
import '../error/failures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class Constants {
  static void showErrorDialog(
      {required BuildContext context, required String msg}) {
    showDialog(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(
              title: Text(
                msg,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('Ok'),
                )
              ],
            ));
  }


  static Future<bool> showConfirmDialog({required BuildContext context,
    required String msg}) async {
    return await showDialog(
        context: context,
        builder: (context) =>
            CupertinoAlertDialog(
              title: Text(
                msg,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('تأكيد'),
                ),

                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  child: const Text('إلغاء'),
                ),


              ],
            ));
  }

  static void showToast(
      {required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.cancel();

    Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: msg,
        backgroundColor: color ?? AppColors.primary,
        gravity: gravity ?? ToastGravity.BOTTOM);
  }




  static void launchCaller(String phoneNumber, String isoCode) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, isoCode);

    // final url = "tel:${number.phoneNumber}";
    // final url = Uri.parse("tel:${number.phoneNumber}");


    final url = Uri(scheme: "tel", path: number.phoneNumber);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchWhatsApp(String phoneNumber, String isoCode,
      String message) async {
    final url = await _getUrl(phoneNumber, isoCode, message);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  static Future<String> _getUrl(String phoneNumber, String isoCode,
      String message) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
        phoneNumber, isoCode);


    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$number/?text=$message"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$number=$message"; // new line
    }
  }

  static MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red,
        g = color.green,
        b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }


  static String mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure + " " + failure.msg.toString();

      case CacheFailure:
        return AppStrings.cacheFailure + " " + failure.msg.toString();

      default:
        return AppStrings.unexpectedError;
    }
  }


  static String? validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppStrings.required;
    }

    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'ادخل ايميل صالح';
    } else {
      return null;
    }
  }

  static String? validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  static String formatCurrency(int? amount) {
    if (amount == null) {
      return "اتصل لمعرفة السعر";
    }

    return NumberFormat.currency(locale: "en", decimalDigits: 0, symbol: "")
        .format(amount) +
        " جنية";
  }


  static String dateTimeFromMilliSeconds(int? dateMillis) {
    if (dateMillis == null) return "غير محدد التاريج";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateMillis);


    // kk:mm
    String formattedDate = DateFormat('yyyy-MM-dd – h:mma').format(dateTime);

    return formattedDate;
  }

  static String dateFromMilliSeconds(int? dateMillis) {
    if (dateMillis == null) return "غير محدد التاريج";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateMillis);

    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }


  static String timeAgoSinceDate(int? date, {bool numericDates = false}) {
    if (date == null) return "";
    DateTime realEstateDate = DateTime.fromMillisecondsSinceEpoch(date);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(realEstateDate);

    if (difference.inDays > 8) {
      return DateFormat.yMMMd('ar_SA').format(
          DateTime.fromMillisecondsSinceEpoch(date));
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? 'منذ 1 اسوبع' : 'منذ اسبوع';
    } else if (difference.inDays >= 2) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? 'منذ 1 يوم' : 'امس';
    } else if (difference.inHours >= 2) {
      return 'منذ ${difference.inHours} ساعات';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? 'منذ 1ساعة' : 'منذ ساعة';
    } else if (difference.inMinutes >= 2) {
      return 'منذ ${difference.inMinutes} دقائق';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? 'منذ 1دقية' : 'منذ دقيقة';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} منذ ثوان ';
    } else {
      return 'الآن';
    }
  }


  static CurrentEmployee? currentEmployee;

}

