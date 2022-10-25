
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/core/widgets/error_item_widget.dart';
import 'package:crm_flutter_project/core/widgets/waiting_item_widget.dart';
import 'package:crm_flutter_project/features/own_reports/presentation/cubit/own_reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';

class OwnReportsScreen extends StatelessWidget {
  const OwnReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnReportsCubit, OwnReportsState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final ownReportsCubit = OwnReportsCubit.get(context);

        if (state is StartFetchEmployeeReports) {
          return const WaitingItemWidget();
        }


        if (state is FetchEmployeeReportsError) {
          return ErrorItemWidget(
            msg: state.msg,
            onPress: () {
              ownReportsCubit.fetchEmployeeReports();
            },
          );
        }

        if (state is EndFetchEmployeeReports) {
          final customerTypesCount = state.employeeStatisticsResult
              .employeeCustomerTypesCount;
          final eventsTypes = state.employeeStatisticsResult
              .employeeLastEventsReportList;

          return Scaffold(
            appBar: AppBar(
              title: const Text("نظره عامة"),
              actions: [
                IconButton(onPressed: () {
                  ownReportsCubit.fetchEmployeeReports();
                }, icon: const Icon(Icons.refresh))
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [


                  SliverToBoxAdapter(
                    child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.customersRoute);
                        },
                        leading: const Icon(Icons.people),
                        trailing: const Icon(Icons.arrow_forward),
                        title: const Text("الي صفحة العملاء"),
                      ),
                    ),
                    const DefaultHeightSizedBox(),
                    const Divider(),
                    const DefaultHeightSizedBox(),
                ],
              )


                  ),

                  SliverToBoxAdapter(
                    child: Wrap(
                      runSpacing: 20.0,
                      spacing: 20.0,
                      direction: Axis.horizontal,
                      children: [

                        CustomElement(
                          title: "كل المعين لي",
                          value: customerTypesCount.all.toString(),
                        ),

                        CustomElement(
                          title: "بدون اي اكشن",
                          value: customerTypesCount.noEvent.toString(),
                        ),

                        CustomElement(
                          title: "حان الاتصال اليوم",
                          value: customerTypesCount.now.toString(),
                        ),


                        CustomElement(
                          title: "مؤجل",
                          value: customerTypesCount.delayed.toString(),
                        ),


                        CustomElement(
                          title: "فات موعد الاتصال",
                          value: customerTypesCount.skip.toString(),
                        ),

                      ],

                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: Divider(),
                  ),

                  const SliverToBoxAdapter(
                    child: Text("علي حسب نوع الايفينت"),
                  ),
                  SliverList(delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final currentItem = eventsTypes[index];

                      return ListTile(
                        title: Text(currentItem.eventName),
                        subtitle: Text(currentItem.count.toString()),
                      );
                    },
                    childCount: eventsTypes.length
                  )),

                ],
              ),
            ),
          );
        }

        return const WaitingItemWidget();
      },
    );
  }
}


class CustomElement extends StatelessWidget {
  final String title;
  final String value;
  const CustomElement({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),

        gradient: const LinearGradient(
          colors: [
            Colors.blueGrey,
            Colors.grey
          ]
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white),),
            const Divider(),
            Text(value, style: const TextStyle(fontSize: 30.0, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
