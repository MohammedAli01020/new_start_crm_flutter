import 'dart:math';

import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../developers_and_projects/presentation/cubit/developer/developer_cubit.dart';


class DevelopersPicker extends StatefulWidget {
  final List<String> selectedDevelopers;
  final Function onConfirmCallback;
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

   DevelopersPicker(
      {Key? key, required this.selectedDevelopers, required this.onConfirmCallback})
      : super(key: key) {
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

  @override
  State<DevelopersPicker> createState() => _DevelopersPickerState();
}

class _DevelopersPickerState extends State<DevelopersPicker> {


  final _developerNameSearch = TextEditingController();


  @override
  void initState() {
    super.initState();
    _developerNameSearch.addListener(() {

      setState(() {});
    });
  }


  @override
  void dispose() {
    _developerNameSearch.dispose();
    widget._scrollController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DeveloperCubit>()
        ..setSelectedDevelopers(widget.selectedDevelopers)
        ..getAllDevelopersByNameLike(),

      child: BlocBuilder<DeveloperCubit, DeveloperState>(
        builder: (context, state) {
          final developerCubit = DeveloperCubit.get(context);
          if (state is StartGetAllDevelopersByNameLike) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator()));
          }

          if (state is GetAllDevelopersByNameLikeError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  developerCubit.getAllDevelopersByNameLike();
                },
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomEditText(
                  onChangedCallback: (String val) {
                    developerCubit.filterDevelopers(val);
                  },
                  suffixIcon: _developerNameSearch.text.isEmpty
                      ? null
                      : IconButton(
                      onPressed: () {
                        developerCubit.resetFilters();
                        _developerNameSearch.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  controller: _developerNameSearch,
                  inputType: TextInputType.text,
                  hint: "اسم المطور",
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.onConfirmCallback(developerCubit.selectedDevelopersNames);
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
                        developerCubit.setSelectedDevelopers([]);
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('مسح الكل'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 500.0,
                  width: 500.0,
                  child: ListView.separated(
                    controller: widget._scrollController,
                    itemBuilder: (context, index) {
                      final currentDeveloper = developerCubit.developers[index];
                      return ListTile(
                        onTap: () {
                          developerCubit.updateSelectedDevelopers(currentDeveloper.name);
                        },
                        // selectedTileColor: Colors.blueGrey[100],
                        selected:
                            developerCubit.selectedDevelopersNames.contains(currentDeveloper.name),
                        title: Text(currentDeveloper.name),
                      );
                    },
                    itemCount: developerCubit.developers.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
