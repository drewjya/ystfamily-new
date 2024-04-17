// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/features/history/provider/history_provider.dart';

class FilterValue {
  final int limit;
  final int offset;
  final FilterHistory filter;
  const FilterValue({
    required this.limit,
    required this.offset,
    required this.filter,
  });

  FilterValue copyWith({
    int? limit,
    int? offset,
    FilterHistory? filter,
  }) {
    return FilterValue(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      filter: filter ?? this.filter,
    );
  }

  @override
  String toString() => 'FilterValue(limit: $limit, offset: $offset, filter: $filter)';

  @override
  bool operator ==(covariant FilterValue other) {
    if (identical(this, other)) return true;

    return other.limit == limit && other.offset == offset && other.filter == filter;
  }

  @override
  int get hashCode => limit.hashCode ^ offset.hashCode ^ filter.hashCode;
}
