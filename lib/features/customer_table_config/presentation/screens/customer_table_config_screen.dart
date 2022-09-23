import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../customers/presentation/cubit/customer_cubit.dart';

class CustomerTableConfigScreen extends StatelessWidget {
  final CustomerCubit customerCubit;

  const CustomerTableConfigScreen({Key? key, required this.customerCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("اعادات جدول العملاء"),
      ),
      body: BlocConsumer<CustomerCubit, CustomerState>(
        listener: (context, state) {
          if (state is CacheCustomerTableConfigError) {
            Constants.showToast(msg: "CacheCustomerTableConfigError: " + state.msg, context: context);
          }
        },
        builder: (context, state) {
          final cubit = CustomerCubit.get(context);
          return ListView(
            children: [

              SwitchListTile(
                  title: const Text("اسم العيمل"),
                  value: Constants.customerTableConfigModel.showName,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig(Constants.customerTableConfigModel.copyWith(
                        showName: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("رقم العيمل"),
                  value: Constants.customerTableConfigModel.showPhone,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showPhone: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              // SwitchListTile(
              //     title: const Text("معين الي"),
              //     value: Constants.customerTableConfigModel.showAssignedTo,
              //     onChanged: (val) {
              //
              //       cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
              //           showAssignedTo: Wrapped.value(val)
              //       ));
              //     }),
              //
              // const Divider(),

              SwitchListTile(
                  title: const Text("اخر حالة"),
                  value: Constants.customerTableConfigModel.showLastAction,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showLastAction: Wrapped.value(val)
                    ));
                  }),

              const Divider(),


              SwitchListTile(
                  title: const Text("المصادر"),
                  value: Constants.customerTableConfigModel.showSources,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showSources: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("الاهتمامات"),
                  value: Constants.customerTableConfigModel.showUnitTypes,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showUnitTypes: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("اخر تحديث للحالة"),
                  value: Constants.customerTableConfigModel.showLastActionTime,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showLastActionTime: Wrapped.value(val)
                    ));
                  }),

              const Divider(),


              SwitchListTile(
                  title: const Text("اخر تعليق"),
                  value: Constants.customerTableConfigModel.showLastComment,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showLastComment: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("تاريخ الادخال"),
                  value: Constants.customerTableConfigModel.showInsertDate,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showInsertDate: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("مدخل بواسطة"),
                  value: Constants.customerTableConfigModel.showCreateBy,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showCreateBy: Wrapped.value(val)
                    ));
                  }),

              const Divider(),

              SwitchListTile(
                  title: const Text("معين بواسطة"),
                  value: Constants.customerTableConfigModel.showAssignedBy,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showAssignedBy: Wrapped.value(val)
                    ));
                  }),

              const Divider(),


              SwitchListTile(
                  title: const Text("موعد التذكير"),
                  value: Constants.customerTableConfigModel.showReminderTime,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showReminderTime: Wrapped.value(val)
                    ));
                  }),

              const Divider(),


              SwitchListTile(
                  title: const Text("عدد التكرارات"),
                  value: Constants.customerTableConfigModel.showDuplicateNumber,
                  onChanged: (val) {

                    cubit.cacheCustomerTableConfig( Constants.customerTableConfigModel.copyWith(
                        showDuplicateNumber: Wrapped.value(val)
                    ));
                  }),



            ],
          );
        },
      ),
    );
  }
}
