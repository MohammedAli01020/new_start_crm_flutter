import 'dart:io';

import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/core/utils/responsive.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/employees/data/models/permission_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/phoneNumber_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/customers/presentation/cubit/customer_cubit.dart';
import '../../features/login/domain/entities/current_employee.dart';
import '../error/failures.dart';
import 'app_colors.dart';
import 'app_strings.dart';
import 'enums.dart';

class Constants {
  static void showErrorDialog(
      {required BuildContext context, required String msg}) {
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
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

  static Future<bool> showConfirmDialog(
      {required BuildContext context, required String msg}) async {
    return await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
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

  static void showDialogBox(
      {required BuildContext context,
      required String title,
      Widget? content}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                content: content,
              );
            },
          );
        });
  }

  static void showToast(
      {required String msg,
      Color? color,
      ToastGravity? gravity,
      required BuildContext context}) {
    if (Responsive.isAndroid || Responsive.isIOS || kIsWeb) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: msg,
          backgroundColor: color ?? AppColors.primary,
          gravity: gravity ?? ToastGravity.BOTTOM);
    } else {
      final snackBar = SnackBar(
        content: Text(msg),
        backgroundColor: color,
      );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static void launchCaller(PhoneNumberModel phoneNumberModel) async {
    final url = Uri(
        scheme: "tel",
        path:
            "${phoneNumberModel.countryCode}${phoneNumberModel.phone.substring(1)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void launchWhatsApp(
      PhoneNumberModel phoneNumberModel, String message) async {
    // final url = "https://wa.me/${number.phoneNumber}?text=$message";
    final url = _getUrl(
        "${phoneNumberModel.countryCode}${phoneNumberModel.phone.substring(1)}",
        message);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String _getUrl(String completePhone, String message) {
    if (Platform.isAndroid || Platform.isWindows) {
      // add the [https]
      return "https://wa.me/$completePhone/?text=$message"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$completePhone=${Uri.parse(message)}"; // new line
    }
  }

  static MaterialColor buildMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

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


  static Future<void> copyText(String text) async {
    await Clipboard.setData(
        ClipboardData(
            text: text
        )
    );
  }

  static String getDateType(int? startDateTime, int? endDateTime) {
    if (startDateTime == null && endDateTime == null) {
      return "كل الاوقات";
    } else if (startDateTime == DateTime.now().firstTimOfCurrentDayMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentDayMillis) {
      return "هذا اليوم";
    } else if (startDateTime == DateTime.now().firstTimeOfCurrentMonthMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentMonthMillis) {
      return "هذا الشهر";
    } else if (startDateTime == DateTime.now().firstTimePreviousMonthMillis &&
        endDateTime == DateTime.now().lastTimOfPreviousMonthMillis) {
      return "الشهر السابق";
    } else {
      String from = startDateTime != null
          ? (" من " + Constants.dateFromMilliSeconds(startDateTime))
          : "";
      String to = endDateTime != null
          ? (" ألي " + Constants.dateFromMilliSeconds(endDateTime))
          : "";

      return from + to;
    }
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
    if (date == null) return "لا يوجد";
    DateTime realEstateDate = DateTime.fromMillisecondsSinceEpoch(date);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(realEstateDate);

    if (difference.inDays > 8) {
      return DateFormat.yMMMd('ar_SA')
          .format(DateTime.fromMillisecondsSinceEpoch(date));
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



  static void refreshCustomers(CustomerCubit cubit) {

    if (Constants.currentEmployee!.permissions.contains(AppStrings.viewAllLeads)) {

      cubit.updateFilter( cubit.customerFiltersModel.copyWith(
          customerTypes: Wrapped.value(CustomerTypes.ALL.name)));

      cubit.fetchCustomers(refresh: true);
    }
    else if (Constants.currentEmployee!.permissions.contains(AppStrings.viewTeamLeads) && Constants.currentEmployee!.teamId != null) {

      cubit.updateFilter(cubit.customerFiltersModel.copyWith(
          teamId: Wrapped.value(Constants.currentEmployee?.teamId),
          employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
          customerTypes: Wrapped.value(CustomerTypes.ME_AND_TEAM.name)));

      cubit.fetchCustomers(refresh: true);

    } else if (Constants.currentEmployee!.permissions.contains(AppStrings.viewMyAssignedLeads)) {
      cubit.updateFilter(cubit.customerFiltersModel.copyWith(
          teamId: const Wrapped.value(null),
          employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
          customerTypes: Wrapped.value(CustomerTypes.ME.name)));
      cubit.fetchCustomers(refresh: true);

    }
    else if (Constants.currentEmployee!.permissions.contains(AppStrings.viewNotAssignedLeads)) {
      cubit.updateFilter(cubit.customerFiltersModel.copyWith(
          teamId: const Wrapped.value(null),
          employeeId: const Wrapped.value(null),
          customerTypes: Wrapped.value(CustomerTypes.NOT_ASSIGNED.name)));

      cubit.fetchCustomers(refresh: true);
    } else {
      cubit.updateCustomers([]);
    }
  }

  static CurrentEmployee? currentEmployee;

  // (25, 'إضافة الموظفين'),
  // (26, 'تعديل الموظفين'),
  // (27, 'حذف الموظفين'),
  // (28, 'مشاهدة الموظفين'),
  // (29, 'تعيين الموظفين'),
  // (34, 'متاح للتعيين'),
  // (63, 'مشاهدة موظفين اضفتهم'),
  static List<PermissionModel> employeesPermissions = [
    const PermissionModel(permissionId: 25, name: AppStrings.createEmployees),
    const PermissionModel(permissionId: 26, name: AppStrings.editEmployees),
    const PermissionModel(permissionId: 27, name: AppStrings.deleteEmployees),
    const PermissionModel(permissionId: 28, name: AppStrings.viewEmployees),
    const PermissionModel(permissionId: 29, name: AppStrings.assignEmployees),
    const PermissionModel(permissionId: 34, name: AppStrings.availableToAssign),

    const PermissionModel(permissionId: 63, name: AppStrings.viewCreatedEmployees),

  ];


  // (1, 'مشاهده كل العملاء'),
  // (2, 'مشاهدة العملاء المعينة لي'),
  // (3, 'مشاهدة عملائي'),
  // (4, 'مشاهدة عملاء فريقي'),
  // (5, 'مشاهدة العملاء الغير معينين'),

  // 1- view
  static List<PermissionModel> leadsViewPermissions = [
  const PermissionModel(permissionId: 1, name: AppStrings.viewAllLeads),
  const PermissionModel(permissionId: 2, name: AppStrings.viewMyAssignedLeads),
  const PermissionModel(permissionId: 3, name: AppStrings.viewOwnLeads),
  const PermissionModel(permissionId: 4, name: AppStrings.viewTeamLeads),
  const PermissionModel(permissionId: 5, name: AppStrings.viewNotAssignedLeads),
  const PermissionModel(permissionId: 62, name: AppStrings.viewDuplicatesLeads),

  ];


  //2- edit
  // (6, 'تعديل كل العملاء'),
  // (7, 'تعديل العملاء المعينة لي'),
  // (8, 'تعديل عملائي'),
  // (9, 'تعديل عملاء فريقي'),
  // (10, 'تعديل العملاء الغير معينين'),
  // (47, 'إضافة العملاء'),
  static List<PermissionModel> leadsEditPermissions  = [
    const PermissionModel(permissionId: 6, name: AppStrings.editAllLeads),
    const PermissionModel(permissionId: 7, name: AppStrings.editMyAssignedLeads),
    const PermissionModel(permissionId: 8, name: AppStrings.editOwnLeads),
    const PermissionModel(permissionId: 9, name: AppStrings.editTeamLeads),
    const PermissionModel(permissionId: 10, name: AppStrings.editNotAssignedLeads),
    const PermissionModel(permissionId: 47, name: AppStrings.creatLead),
  ];

  // 3- delete
  // (11, 'حذف كل العملاء'),
  // (12, 'حذف العملاء المعينة لي'),
  // (13, 'حذف عملائي'),
  // (14, 'حذف عملاء فريقي'),
  // (15, 'حذف العملاء الغير معينين'),
  static List<PermissionModel> leadsDeletePermissions = [
    const PermissionModel(permissionId: 11, name: AppStrings.deleteAllLeads),
    const PermissionModel(permissionId: 12, name: AppStrings.deleteMyAssignedLeads),
    const PermissionModel(permissionId: 13, name: AppStrings.deleteOwnLeads),
    const PermissionModel(permissionId: 14, name: AppStrings.deleteTeamLeads),
    const PermissionModel(permissionId: 15, name: AppStrings.deleteNotAssignedLeads),
  ];


  // 4- inside customers
  // view
  // (16, 'مشاهدة اسم العميل'),
  // (17, 'مشاهدة مدخل العميل'),
  // (18, 'مشاهدة رقم العميل'),
  // (19, 'مشاهدة ملاحظات عن العميل'),
  static List<PermissionModel> leadsInsidePermissions  = [
    const PermissionModel(permissionId: 16, name: AppStrings.viewLeadName),
    const PermissionModel(permissionId: 17, name: AppStrings.viewLeadCreator),
    const PermissionModel(permissionId: 18, name: AppStrings.viewLeadPhone),
    const PermissionModel(permissionId: 19, name: AppStrings.viewLeadDescription),

    const PermissionModel(permissionId: 67, name: AppStrings.viewLeadLog),

    // edit
    // (20, 'تعديل اسم العميل'),
    // (21, 'تعديل مدخل العميل'),
    // (22, 'تعديل رقم العميل'),
    // (23, 'تعديل ملاحظات عن العميل'),
    // (64, 'تعديل مصادر العميل'),
    // (65, 'تعديل مشاريع العميل'),
    // (66, 'تعديل اهتمامات العميل')
    const PermissionModel(permissionId: 20, name: AppStrings.editLeadName),
    const PermissionModel(permissionId: 21, name: AppStrings.editLeadCreator),
    const PermissionModel(permissionId: 22, name: AppStrings.editLeadPhone),
    const PermissionModel(permissionId: 23, name: AppStrings.editLeadDescription),

    const PermissionModel(permissionId: 64, name: AppStrings.editLeadSources),
    const PermissionModel(permissionId: 65, name: AppStrings.editLeadProjects),
    const PermissionModel(permissionId: 66, name: AppStrings.editLeadUnitTyps),


  ];



  // actions
  // (30, 'أضافة فعل'),
  // (31, 'العمليات المجمعه'),
  // (32, 'استيرات العملاء'),
  // (33, 'تصدير العملاء'),
  static List<PermissionModel> actionsAndBulkActionsPermissions = [
    const PermissionModel(permissionId: 30, name: AppStrings.createActions),
    const PermissionModel(permissionId: 31, name: AppStrings.bulkActions),
    const PermissionModel(permissionId: 32, name: AppStrings.importLeads),
    const PermissionModel(permissionId: 33, name: AppStrings.exportLeads),
  ];


  // events
  // (35, 'مشاهدة الاحداث'),
  // (36, 'تعديل الاحداث'),
  // (37, 'إضافة الاحداث'),
  // (38, 'حذف الاحداث'),
  static List<PermissionModel> eventsPermissions = [
    const PermissionModel(permissionId: 35, name: AppStrings.viewEvents),
    const PermissionModel(permissionId: 36, name: AppStrings.editEvents),
    const PermissionModel(permissionId: 37, name: AppStrings.createEvents),
    const PermissionModel(permissionId: 38, name: AppStrings.deleteEvents),
  ];

  // projects
  // (39, 'مشاهدة المشاريع'),
  // (40, 'تعديل المشاريع'),
  // (41, 'إضافة المشاريع'),
  // (42, 'حذف المشاريع'),
  static List<PermissionModel> projectsPermissions = [
    const PermissionModel(permissionId: 39, name: AppStrings.viewProjects),
    const PermissionModel(permissionId: 40, name: AppStrings.editProjects),
    const PermissionModel(permissionId: 41, name: AppStrings.createProjects),
    const PermissionModel(permissionId: 42, name: AppStrings.deleteProjects),
  ];


  // unit types
  // (43, 'مشاهدة انواع الوحدات'),
  // (44, 'تعديل انواع الوحدات'),
  // (45, 'إضافة انواع الوحدات'),
  // (46, 'حذف انواع الوحدات'),
  static List<PermissionModel> unitTypesPermissions = [
    const PermissionModel(permissionId: 43, name: AppStrings.viewUnitTypes),
    const PermissionModel(permissionId: 44, name: AppStrings.editUnitTypes),
    const PermissionModel(permissionId: 45, name: AppStrings.createUnitTypes),
    const PermissionModel(permissionId: 46, name: AppStrings.deleteUnitTypes),
  ];



  // sources
  // (48, 'مشاهدة المصادر'),
  // (49, 'تعديل المصادر'),
  // (50, 'إضافة المصادر'),
  // (51, 'حذف المصادر'),

  static List<PermissionModel> sourcesPermissions = [
    const PermissionModel(permissionId: 48, name: AppStrings.viewSources),
    const PermissionModel(permissionId: 49, name: AppStrings.editSources),
    const PermissionModel(permissionId: 50, name: AppStrings.createSources),
    const PermissionModel(permissionId: 51, name: AppStrings.deleteSources),
  ];

  // groups
  // (52, 'مشاهدة كل المجموعات'),
  // (53, 'مشاهدة المجموعات التابعه له'),
  // (56, 'انشاء مجموعة'),
  // (57, 'حذف مجموعة'),
  // (58, 'تعديل مجموعة'),
  // (59, 'اضافة اعضاء لمجموعة'),
  // (60, 'حذف اعضاء لمجموعة'),
  static List<PermissionModel> groupsPermissions = [
    const PermissionModel(permissionId: 52, name: AppStrings.viewAllGroups),
    const PermissionModel(permissionId: 53, name: AppStrings.viewOwnGroups),
    const PermissionModel(permissionId: 56, name: AppStrings.createGroups),
    const PermissionModel(permissionId: 57, name: AppStrings.deleteGroups),
    const PermissionModel(permissionId: 58, name: AppStrings.editGroups),
    const PermissionModel(permissionId: 59, name: AppStrings.addGroupMembers),
    const PermissionModel(permissionId: 60, name: AppStrings.deleteGroupMembers),
  ];


  // reports
  // (54, 'مشاهدة كل الاحصائيات'),
  // (55, 'مشاهدة الاحصائيات التابعه له'),

  static List<PermissionModel> reportsPermissions = [
    const PermissionModel(permissionId: 54, name: AppStrings.viewAllStatistics),
    const PermissionModel(permissionId: 55, name: AppStrings.viewOwnStatistics),

  ];


  // logs
  // (61, 'مشاهدة كل سجلات العملاء')
  static List<PermissionModel> logsPermissions = [
    const PermissionModel(permissionId: 61, name: AppStrings.viewAllCustomerLogs),

  ];

}
