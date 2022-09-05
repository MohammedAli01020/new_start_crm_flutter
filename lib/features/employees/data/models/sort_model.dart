import '../../domain/entities/sort.dart';

class SortModel extends Sort {
  const SortModel(
      {required bool empty, required bool sorted, required bool unsorted})
      : super(empty: empty, sorted: sorted, unsorted: unsorted);

  factory SortModel.fromJson(Map<String, dynamic> json) => SortModel(
        empty: json["empty"],
        sorted: json["sorted"],
        unsorted: json["unsorted"],
      );

  Map<String, dynamic> toJson() => {
        "empty": empty,
        "sorted": sorted,
        "unsorted": unsorted,
      };
}
