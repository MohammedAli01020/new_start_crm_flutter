import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/features/sources/presentation/cubit/source_cubit.dart';
import 'package:crm_flutter_project/features/sources/presentation/widgets/source_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../widgets/modify_source_widget.dart';

class SourcesScreen extends StatelessWidget {
  final SourcesArgs sourcesArgs;
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  SourcesScreen({Key? key, required this.sourcesArgs}) : super(key: key) {
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

  Widget _buildBody(SourceCubit sourceCubit, SourceState state) {

    if (state is StartGetAllSourcesByNameLike) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllSourcesByNameLikeError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          sourceCubit.getAllSourcesByNameLike();
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentSource = sourceCubit.sources[index];
          return ListTile(
            onTap: () {

              if (sourcesArgs.sourceType == SourceType.SELECT_SOURCES.name) {
                sourceCubit.updateSelectedSources(currentSource.name);
              } else if (sourcesArgs.sourceType == SourceType.VIEW_SOURCES.name) {

                if (Constants.currentEmployee!.permissions.contains(AppStrings.editSources)) {
                  Constants.showDialogBox(context: context,
                      title: "عدل الحدث",
                      content: ModifySourceWidget(
                        sourceModel: currentSource,
                        sourceCubit: sourceCubit,
                        state: state,
                      ));
                }

              }
            },
            selectedTileColor: Colors.blueGrey[100],
            selected: sourceCubit.selectedSources.contains(currentSource.name),
            title: Text(currentSource.name),
          );
        },
        itemCount: sourceCubit.sources.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SourceCubit, SourceState>(
      listener: (context, state) {
        if (state is ModifySourceError) {
          Constants.showToast(msg: "ModifySourceError: " + state.msg, context: context);
        }

        if (state is EndModifySource) {
          Constants.showToast(msg: "تم بنجاح", color: Colors.green ,context: context);
        }
      },
      builder: (context, state) {
        final sourceCubit = SourceCubit.get(context);

        return Scaffold(
          appBar: SourcesAppBar(sourceType: sourcesArgs.sourceType,
            onSearchChangeCallback: (search) {
              sourceCubit.getAllSourcesByNameLike(name: search);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                sourceCubit.getAllSourcesByNameLike();
              }
            },
            onDoneTapCallback: () {
              Navigator.pop(context, sourceCubit.selectedSources);
            }, onNewTapCallback: () {

            if (Constants.currentEmployee!.permissions.contains(AppStrings.createSources)) {
              Constants.showDialogBox(context: context,
                  title: "أضف مصدر جديد",
                  content: ModifySourceWidget(
                    sourceCubit: sourceCubit,
                    state: state,
                  ));
            }


            },),

          body: _buildBody(sourceCubit, state),

        );
      },
    );
  }
}


class SourcesArgs {
  final String sourceType;
  final List<String>? selectedSourcesNames;

  SourcesArgs({required this.sourceType, this.selectedSourcesNames});

}

