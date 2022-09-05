import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';

import '../../domain/entities/pageable.dart';

class PageableModel extends Pageable {
  const PageableModel(
      {required SortModel sort,
      required int offset,
      required int pageNumber,
      required int pageSize,
      required bool paged,
      required bool unpaged})
      : super(
            sort: sort,
            offset: offset,
            pageNumber: pageNumber,
            pageSize: pageSize,
            paged: paged,
            unpaged: unpaged);

  factory PageableModel.fromJson(Map<String, dynamic> json) => PageableModel(
        sort: SortModel.fromJson(json["sort"]),
        offset: json["offset"],
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        paged: json["paged"],
        unpaged: json["unpaged"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort.toJson(),
        "offset": offset,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "paged": paged,
        "unpaged": unpaged,
      };
}
