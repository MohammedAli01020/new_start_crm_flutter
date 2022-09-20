import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../sources/presentation/screens/sources_screen.dart';

class PickSources extends StatefulWidget {
  final List<String> sources;
  final Function onPickedSourcesCallback;
  const PickSources({Key? key, required this.sources,
    required this.onPickedSourcesCallback}) : super(key: key);

  @override
  State<PickSources> createState() => _PickSourcesState();
}

class _PickSourcesState extends State<PickSources> {

  List<String> selectedSources = [];

  @override
  void initState() {
    super.initState();
    selectedSources = widget.sources;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () async {


          final pickedSources = await Navigator.pushNamed(context, Routes.sourcesRoute,
              arguments: SourcesArgs(sourceType: SourceType.SELECT_SOURCES.name,
                  selectedSourcesNames: selectedSources));

          if (pickedSources != null && pickedSources is List<String>) {

            selectedSources = pickedSources;

            setState(() {
            });

            widget.onPickedSourcesCallback(pickedSources);
          }
        },
        title: Text(selectedSources.isNotEmpty ? "عدل المصادر" : "احتر المصادر"),
        subtitle: Text(selectedSources.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}