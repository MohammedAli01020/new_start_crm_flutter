import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/error_item_widget.dart';

import '../../data/models/report_model.dart';
import '../cubit/report_cubit.dart';
import '../widget/report_app_bar.dart';
class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);


  Widget _buildBody(ReportCubit cubit, ReportState state, BuildContext context) {

    if (state is StartFetchEmployeeCustomerReports) {
      return const Center(child: CircularProgressIndicator(),);
    }

    if (state is FetchEmployeeCustomerReportsError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          cubit.fetchEmployeeCustomerReports();
        },
      );
    }

    if (state is EndFetchEmployeeCustomerReports) {

      final reportData = state.reportDataModel;

      final lastEvent =  reportData.lastEventReport;
      final unitTypes =  reportData.unitTypesReport;
      final sources =  reportData.sourcesReport;
      final projects =  reportData.projectsReport;

      return CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Container(
                width: context.width,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blueGrey[100],
                child: const Text("تقارير اخر حدث")),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {


                final currentKey = lastEvent.keys.toList();

                final List<ReportModel>? currentItem = lastEvent[currentKey[index]];
                int sum = 0;
                if (currentItem != null) {
                  for (var element in currentItem) {
                    sum = sum + element.count;
                  }
                }

                return Column(
                  children: [
                    ListTile(
                      title: Text(currentKey[index].toString()),

                      subtitle: currentItem != null ?

                          Wrap(

                            children: currentItem.map((e) => Container(

                              child: Column(
                                children: [
                                  Text(e.type),
                                  Text(e.count.toString())
                                ],
                                mainAxisSize: MainAxisSize.min,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.blueGrey[100]
                              ),
                              padding: const EdgeInsets.all(5.0),
                              margin:  const EdgeInsets.all(5.0),
                            )).toList() ,
                          )

                       : null ,

                      leading: CircleAvatar(
                        child: Text(sum.toString()),

                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }, childCount: lastEvent.keys.length)),


          SliverToBoxAdapter(
            child: Container(
                width: context.width,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blueGrey[100],
                child: const Text("تقارير انواع الوحدات")),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {


                final currentKey = unitTypes.keys.toList();

                final List<ReportModel>? currentItem = unitTypes[currentKey[index]];
                int sum = 0;
                if (currentItem != null) {
                  for (var element in currentItem) {
                    sum = sum + element.count;
                  }
                }

                return Column(
                  children: [
                    ListTile(
                      title: Text(currentKey[index].toString()),

                      subtitle: currentItem != null ?

                      Wrap(

                        children: currentItem.map((e) => Container(

                          child: Column(
                            children: [
                              Text(e.type),
                              Text(e.count.toString())
                            ],
                            mainAxisSize: MainAxisSize.min,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blueGrey[100]
                          ),
                          padding: const EdgeInsets.all(5.0),
                          margin:  const EdgeInsets.all(5.0),
                        )).toList() ,
                      )

                          : null ,

                      leading: CircleAvatar(
                        child: Text(sum.toString()),

                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }, childCount: unitTypes.keys.length)),


          SliverToBoxAdapter(
            child: Container(
                width: context.width,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blueGrey[100],
                child: const Text("تقارير مصدر العميل")),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {


                final currentKey = sources.keys.toList();

                final List<ReportModel>? currentItem = sources[currentKey[index]];
                int sum = 0;
                if (currentItem != null) {
                  for (var element in currentItem) {
                    sum = sum + element.count;
                  }
                }

                return Column(
                  children: [
                    ListTile(
                      title: Text(currentKey[index].toString()),

                      subtitle: currentItem != null ?

                      Wrap(

                        children: currentItem.map((e) => Container(

                          child: Column(
                            children: [
                              Text(e.type),
                              Text(e.count.toString())
                            ],
                            mainAxisSize: MainAxisSize.min,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blueGrey[100]
                          ),
                          padding: const EdgeInsets.all(5.0),
                          margin:  const EdgeInsets.all(5.0),
                        )).toList() ,
                      )

                          : null ,

                      leading: CircleAvatar(
                        child: Text(sum.toString()),

                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }, childCount: sources.keys.length)),


          SliverToBoxAdapter(
            child: Container(
                width: context.width,
                padding: const EdgeInsets.all(16.0),
                color: Colors.blueGrey[100],
                child: const Text("تقارير المشاريع")),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {


                final currentKey = projects.keys.toList();

                final List<ReportModel>? currentItem = projects[currentKey[index]];
                int sum = 0;
                if (currentItem != null) {
                  for (var element in currentItem) {
                    sum = sum + element.count;
                  }
                }

                return Column(
                  children: [
                    ListTile(
                      title: Text(currentKey[index].toString()),

                      subtitle: currentItem != null ?

                      Wrap(

                        children: currentItem.map((e) => Container(

                          child: Column(
                            children: [
                              Text(e.type),
                              Text(e.count.toString())
                            ],
                            mainAxisSize: MainAxisSize.min,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.blueGrey[100]
                          ),
                          padding: const EdgeInsets.all(5.0),
                          margin:  const EdgeInsets.all(5.0),
                        )).toList() ,
                      )

                          : null ,

                      leading: CircleAvatar(
                        child: Text(sum.toString()),

                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Divider(),
                  ],
                );
              }, childCount: projects.keys.length)),
        ],
      );

    }
    return const Center(child: CircularProgressIndicator(),);

  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final cubit = ReportCubit.get(context);
        return Scaffold(
          appBar: ReportAppBar(
            reportCubit: cubit,
          ),

          body: _buildBody(cubit, state, context),

        );
      },
    );
  }
}
