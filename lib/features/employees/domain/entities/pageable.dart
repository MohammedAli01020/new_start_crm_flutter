import 'package:equatable/equatable.dart';

import '../../data/models/sort_model.dart';

class Pageable extends Equatable {
  const Pageable({
    required this.sort,
    required this.offset,
    required this.pageNumber,
    required this.pageSize,
    required this.paged,
    required this.unpaged,
  });

  final SortModel sort;
  final int offset;
  final int pageNumber;
  final int pageSize;
  final bool paged;
  final bool unpaged;

  @override
  List<Object> get props => [];
}
