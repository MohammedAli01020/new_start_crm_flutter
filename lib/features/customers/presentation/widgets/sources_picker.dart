import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_item_widget.dart';
import '../../../sources/presentation/cubit/source_cubit.dart';

class SourcesPicker extends StatelessWidget {
  final List<String> selectedSources;
  final Function onConfirmCallback;

  const SourcesPicker(
      {Key? key, required this.selectedSources, required this.onConfirmCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SourceCubit>()
        ..setSelectedSources(selectedSources)
        ..getAllSourcesByNameLike(),

      child: BlocBuilder<SourceCubit, SourceState>(
        builder: (context, state) {
          final sourceCubit = SourceCubit.get(context);
          if (state is StartGetAllSourcesByNameLike) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator()));
          }

          if (state is GetAllSourcesByNameLikeError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  sourceCubit.getAllSourcesByNameLike();
                },
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final currentSource = sourceCubit.sources[index];
                    return ListTile(
                      onTap: () {
                        sourceCubit.updateSelectedSources(currentSource.name);
                      },
                      // selectedTileColor: Colors.blueGrey[100],
                      selected:
                          sourceCubit.selectedSources.contains(currentSource.name),
                      title: Text(currentSource.name),
                    );
                  },
                  itemCount: sourceCubit.sources.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      onConfirmCallback(sourceCubit.selectedSources);
                    },
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
                  TextButton(
                    onPressed: () {
                      sourceCubit.resetSelectedSources();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.red,
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: const Text('مسح الكل'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
