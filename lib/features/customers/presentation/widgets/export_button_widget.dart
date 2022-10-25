
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/customer_model.dart';

class ExportButtonWidget extends StatefulWidget {
  final List<CustomerModel> selectedCustomers;
  const ExportButtonWidget({Key? key, required this.selectedCustomers}) : super(key: key);

  @override
  State<ExportButtonWidget> createState() => _ExportButtonState();
}

class _ExportButtonState extends State<ExportButtonWidget> {

  bool isExporting = false;
  @override
  Widget build(BuildContext context) {


    if (isExporting) {
      return const Center(
          child: SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator()));
    } else {
      return IconButton(
          onPressed: () async {

            setState(() {
              isExporting = true;
            });
            await _generateExcelFile(widget.selectedCustomers);
            setState(() {
              isExporting = false;
            });
          },
          icon: const FaIcon(FontAwesomeIcons.fileExport, color: Colors.white));
    }

  }



  Future<void> _generateExcelFile(List<CustomerModel> customerData) async {
    final excel = Excel.createExcel();

    final sheet = excel[await excel.getDefaultSheet()];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
    "fullName";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
    "phoneNumbers";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
    "last event";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
    "sources";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
    "unit types";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
    "developers";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value =
    "projects";

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value =
    "last comment";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0)).value =
    "reminder time";
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0)).value =
    "duplicate no";

    for (int i = 0; i < customerData.length; i++) {
      int m = i + 1;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: m))
          .value = customerData[i].fullName;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: m))
          .value = customerData[i].phoneNumbers;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: m))
          .value = customerData[i].lastAction?.event?.name;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: m))
          .value = customerData[i].sources;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: m))
          .value = customerData[i].unitTypes;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: m))
          .value = customerData[i].developers;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: m))
          .value = customerData[i].projects;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: m))
          .value = customerData[i].lastAction?.actionDescription;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: m))
          .value = customerData[i].lastAction?.postponeDateTime;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: m))
          .value = customerData[i].duplicateNo;
    }

    await writeCounter(excel);
  }

  Future<String?> get _localPath async {
    if (Responsive.isWindows) {
      final directoryWindows = await getDownloadsDirectory();
      return directoryWindows?.path;
    }

    if (Responsive.isAndroid) {
      return "/storage/emulated/0/Download";
    }

    if (Responsive.isIOS) {
      final directoryIOS = await getApplicationDocumentsDirectory();
      return directoryIOS.path;
    }

    return null;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    String currentDate =
    Constants.dateFromMilliSeconds(DateTime.now().millisecondsSinceEpoch);
    return File('$path/customers-$currentDate.xlsx');
  }

  Future<File> writeCounter(Excel excel) async {
    final file = await _localFile;

    final val = await file.writeAsBytes(await excel.encode());

    Constants.showToast(msg: file.absolute.path, context: context);

    return val;
  }
}