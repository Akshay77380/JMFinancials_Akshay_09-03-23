// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../model/news_record_model.dart';
import 'package:mobx/mobx.dart';

part 'news_listener.g.dart';

class NewsListener = _NewsListener with _$NewsListener;

abstract class _NewsListener with Store {
  List<NewsRecordModel> todayNewsList = [];
  @observable
  ObservableList<NewsRecordModel> filteredNews =
      ObservableList<NewsRecordModel>();

  @action
  void addToNewsList(List<NewsRecordModel> models) {
    try {
      for (var model in models) {
        if (!todayNewsList.contains(model)) todayNewsList.insert(0, model);
      }
      filterNews();
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void addToNewsListBulk(List<NewsRecordModel> model) {
    try {
      todayNewsList.clear();
      todayNewsList.addAll(model);
      todayNewsList.sort((b, a) => a.date.compareTo(b.date));

      filterNews();
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  @action
  void clearNews() {
    todayNewsList.clear();
    filteredNews.clear();
  }

  @observable
  ObservableMap<String, bool> filters = ObservableMap.of({
    'Stocks': false,
    'Commentary': false,
    'Global': false,
    'Block Details': false,
    'Result': false,
    'Commodities': false,
    'Fixed income': false,
    'Default': false,
    'Special Coverage': false,
  });

  @computed
  List<String> get currentFilters =>
      filters.keys.where((element) => filters[element] == true).toList();

  Map<String, bool> getFilterMap() {
    Map<String, bool> _appliedFilters = {
      'Stocks': todayNewsList.any((element) => element.category == 'Stocks'),
      'Commentary':
          todayNewsList.any((element) => element.category == 'Commentary'),
      'Global': todayNewsList.any((element) => element.category == 'Global'),
      'Block Details':
          todayNewsList.any((element) => element.category == 'Block Details'),
      'Result': todayNewsList.any((element) => element.category == 'Result'),
      'Commodities':
          todayNewsList.any((element) => element.category == 'Commodities'),
      'Fixed income':
          todayNewsList.any((element) => element.category == 'Fixed income'),
      'Default': todayNewsList.any((element) => element.category == 'Default'),
      'Special Coverage': todayNewsList
          .any((element) => element.category == 'Special Coverage'),
    };
    _appliedFilters.removeWhere((key, value) => value == false);
    return _appliedFilters;
  }

  @action
  void clearAllfilters() {
    filters.forEach((key, value) => filters[key] = false);
    filterNews();
  }

  @action
  void updateFilter(String key) {
    if (filters.keys.contains(key)) {
      filters[key] = !filters[key];
      filterNews();
    }
  }

  @action
  void filterNews() {
    if (currentFilters.isEmpty)
      filteredNews = ObservableList.of(todayNewsList);
    else
      filteredNews = ObservableList.of(
          todayNewsList.where((element) => filters[element.category] == true));
  }
}
