import 'package:equatable/equatable.dart';

class Sort extends Equatable {
  const Sort({
    required this.empty,
    required this.sorted,
    required this.unsorted,
  });

  final bool empty;
  final bool sorted;
  final bool unsorted;

  @override
  List<Object> get props => [empty, sorted, unsorted];
}
