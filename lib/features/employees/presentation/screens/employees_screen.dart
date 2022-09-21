import 'dart:math';

import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/custom_drawer.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../widgets/employees_app_bar.dart';
import '../widgets/employees_data_table.dart';

class EmployeesScreen extends StatelessWidget {

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  EmployeesScreen({Key? key}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? _extraScrollSpeed
                  : -_extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  void _getPageEmployees(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<EmployeeCubit>(context).fetchEmployees(refresh: refresh);
  }

  Widget _buildBodyTable(
      {required EmployeeCubit cubit,
      required EmployeeState state,
      required BuildContext context}) {


    if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
      return const Center(child: CircularProgressIndicator());
    }

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
      child: SizedBox(
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
            rowsPerPage: 10,
            showCheckboxColumn: false,
            onPageChanged: (pageIndex) {
              cubit.updateFilter(cubit.employeeFiltersModel
                  .copyWith(pageNumber: Wrapped.value(pageIndex)));

              _getPageEmployees(context: context);
            },
            source: EmployeesDataTable(
                employeeCubit: cubit,
                onSelect: (val, currentEmployee) {

                  Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                  arguments: EmployeeDetailsArgs(
                      employeeModel: currentEmployee,
                      employeeCubit: cubit,
                      fromRoute: Routes.employeesRoute));

                })),
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
            },
          ),
          body: _buildBodyTable(
              cubit: employeeCubit, state: state, context: context),
        );
      },
    );
  }
}








