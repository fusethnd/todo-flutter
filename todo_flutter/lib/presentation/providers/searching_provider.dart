import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchingNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateSearchQuery(String newQuery) {
    state = newQuery;
  }
}

final searchingProvider = NotifierProvider<SearchingNotifier, String>(SearchingNotifier.new);