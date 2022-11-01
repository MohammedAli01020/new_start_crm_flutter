import 'dart:math';

import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../data/models/employee_model.dart';
import '../widgets/employees_app_bar.dart';
import '../widgets/employees_data_table.dart';


class EmployeesScreen extends StatelessWidget {

  final _scrollController = ScrollController();


  EmployeesScreen({Key? key}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }


      });
    }
  }



  void exportToExcel() {

  }

  Future<void> _getPageEmployees ({bool refresh = false, required BuildContext context}) async {
    await BlocProvider.of<EmployeeCubit>(context).fetchEmployees(refresh: refresh);
  }

  final tableKey = GlobalKey<PaginatedDataTableState>();

  Widget _buildBodyTable(
      {required EmployeeCubit cubit,
      required EmployeeState state,
      required BuildContext context}) {

    // if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    if (state is RefreshEmployeesError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageEmployees(refresh: true, context: context);
        },
      );
    }

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          Visibility(
              visible: state is StartRefreshEmployees || state is StartLoadingEmployees,
              child: const LinearProgressIndicator()),
          SizedBox(
            width: context.width,
            child: PaginatedDataTable(
                columns: const [
                  DataColumn(label: Text('الصورة')),
                  DataColumn(label: Text('الاسم')),
                  DataColumn(label: Text('تاريخ التعين')),
                  DataColumn(label: Text('رقم التليفون')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('الايميل')),
                ],
                rowsPerPage: cubit.employeeFiltersModel.pageSize ~/ 2,
                showCheckboxColumn: false,
                onPageChanged: (pageIndex) async {

                  // if (state is StartRefreshEmployees || state is StartLoadingEmployees ) {
                  //   if (pageIndex > 0) {
                  //     tableKey.currentState?.pageTo(pageIndex - 1);
                  //   }
                  //   return;
                  // }

                  await _getPageEmployees(context: context);
                },
                source: EmployeesDataTable(
                    employeeCubit: cubit,
                    onSelect: (val, EmployeeModel currentEmployee) {

                      Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                      arguments: EmployeeDetailsArgs(
                          employeeId: currentEmployee.employeeId,
                          employeeCubit: cubit,
                          fromRoute: Routes.employeesRoute));

                    })),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        final employeeCubit = EmployeeCubit.get(context);

        return Scaffold(
          appBar: EmployeesAppBar(
            employeeCubit: employeeCubit,
            onSearchChangeCallback: (search) {
              employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                  .copyWith(fullNameOrPhoneNumber: Wrapped.value(search)));
              _getPageEmployees(refresh: true, context: context);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                    .copyWith(
                        fullNameOrPhoneNumber: const Wrapped.value(null)));

                _getPageEmployees(refresh: true, context: context);
              }
            }, onFilterCallback: () {
              tableKey.currentState?.pageTo(0);
          },
          ),
          body: _buildBodyTable(
              cubit: employeeCubit, state: state, context: context),
        );
      },
    );
  }
}








