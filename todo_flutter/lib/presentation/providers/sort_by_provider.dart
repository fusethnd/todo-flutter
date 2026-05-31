import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/sorting_todo.dart';

class SortByNotifier extends Notifier<SortBy> {
  @override
  SortBy build() => SortBy.date;

  void updateSortBy(SortBy newSort) {
    state = newSort;
  }
}

final sortByProvider = NotifierProvider<SortByNotifier, SortBy>(SortByNotifier.new);