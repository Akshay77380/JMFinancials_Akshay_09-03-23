// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_listener.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsListener on _NewsListener, Store {
  Computed<List<String>>_$currentFiltersComputed;

  @override
  List<String> get currentFilters => (_$currentFiltersComputed ??=
          Computed<List<String>>(() => super.currentFilters,
              name: '_NewsListener.currentFilters'))
      .value;

  final _$filteredNewsAtom =
      Atom(name: '_NewsListener.filteredNews',);

  @override
  ObservableList<NewsRecordModel> get filteredNews {
    _$filteredNewsAtom.reportRead();
    return super.filteredNews;
  }

  @override
  set filteredNews(ObservableList<NewsRecordModel> value) {
    _$filteredNewsAtom.reportWrite(value, super.filteredNews, () {
      super.filteredNews = value;
    });
  }

   final _$filtersAtom =
      Atom(name: '_NewsListener.filters', );

  @override
  ObservableMap<String, bool> get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(ObservableMap<String, bool> value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

   final _$_NewsListenerActionController =
      ActionController(name: '_NewsListener', );

  @override
  void addToNewsList(List<NewsRecordModel> models) {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.addToNewsList');
    try {
      return super.addToNewsList(models);
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToNewsListBulk(List<NewsRecordModel> model) {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.addToNewsListBulk');
    try {
      return super.addToNewsListBulk(model);
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearNews() {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.clearNews');
    try {
      return super.clearNews();
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAllfilters() {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.clearAllfilters');
    try {
      return super.clearAllfilters();
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateFilter(String key) {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.updateFilter');
    try {
      return super.updateFilter(key);
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void filterNews() {
    final _$actionInfo = _$_NewsListenerActionController.startAction(
        name: '_NewsListener.filterNews');
    try {
      return super.filterNews();
    } finally {
      _$_NewsListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
filteredNews: ${filteredNews},
filters: ${filters},
currentFilters: ${currentFilters}
    ''';
  }
}
