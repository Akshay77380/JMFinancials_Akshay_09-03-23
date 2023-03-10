// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketwatch_listener.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MarketwatchListener on _MarketwatchListener, Store {
   final _$watchListAtom =
      Atom(name: '_MarketwatchListener.watchList', );

  @override
  ObservableList<ScripInfoModel> get watchList {
    _$watchListAtom.reportRead();
    return super.watchList;
  }

  @override
  set watchList(ObservableList<ScripInfoModel> value) {
    _$watchListAtom.reportWrite(value, super.watchList, () {
      super.watchList = value;
    });
  }

   final _$watchListNameAtom =
      Atom(name: '_MarketwatchListener.watchListName', );

  @override
  String get watchListName {
    _$watchListNameAtom.reportRead();
    return super.watchListName;
  }

  @override
  set watchListName(String value) {
    _$watchListNameAtom.reportWrite(value, super.watchListName, () {
      super.watchListName = value;
    });
  }

   final _$addToPredefinedWatchListBulkAsyncAction = AsyncAction(
      '_MarketwatchListener.addToPredefinedWatchListBulk',
      );

  @override
  Future<void> addToPredefinedWatchListBulk(
      {List<MemberData> values,
      String grType,
      String grCode,
      String grName,
      bool sendRequest = true}) {
    return _$addToPredefinedWatchListBulkAsyncAction.run(() => super
        .addToPredefinedWatchListBulk(
            values: values,
            grType: grType,
            grCode: grCode,
            grName: grName,
            sendRequest: sendRequest));
  }

   final _$addToIndicesWatchListBulkAsyncAction = AsyncAction(
      '_MarketwatchListener.addToIndicesWatchListBulk',
      );

  @override
  Future<void> addToIndicesWatchListBulk(
      List<ScripInfoModel> value, String name) {
    return _$addToIndicesWatchListBulkAsyncAction
        .run(() => super.addToIndicesWatchListBulk(value, name));
  }

   final _$_MarketwatchListenerActionController =
      ActionController(name: '_MarketwatchListener', );

  @override
  void addToWatchList(ScripInfoModel model) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.addToWatchList');
    try {
      return super.addToWatchList(model);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToWatchListSearch(ScripStaticModel model) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.addToWatchListSearch');
    try {
      return super.addToWatchListSearch(model);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWatchListName(String newName) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.setWatchListName');
    try {
      return super.setWatchListName(newName);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSummaryWatchList(int filter) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.setSummaryWatchList');
    try {
      return super.setSummaryWatchList(filter);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToWatchListBulk(List<ScripInfoModel> values, [bool sendReq = true]) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.addToWatchListBulk');
    try {
      return super.addToWatchListBulk(values, sendReq);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateWatchList(List<ScripInfoModel> values) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.updateWatchList');
    try {
      return super.updateWatchList(values);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortListbyName(bool isDescending) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.sortListbyName');
    try {
      return super.sortListbyName(isDescending);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortListbyPrice(bool isDescending) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.sortListbyPrice');
    try {
      return super.sortListbyPrice(isDescending);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortListbyPercent(bool isDescending) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.sortListbyPercent');
    try {
      return super.sortListbyPercent(isDescending);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromWatchList(ScripInfoModel value) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.removeFromWatchList');
    try {
      return super.removeFromWatchList(value);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeBulkFromWatchList() {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.removeBulkFromWatchList');
    try {
      return super.removeBulkFromWatchList();
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBulkFromPredefinedWatchList() {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.removeBulkFromPredefinedWatchList');
    try {
      return super.removeBulkFromPredefinedWatchList();
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromWatchListIndex(int index) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.removeFromWatchListIndex');
    try {
      return super.removeFromWatchListIndex(index);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSummaryWatchlist(int reportType) {
    final _$actionInfo = _$_MarketwatchListenerActionController.startAction(
        name: '_MarketwatchListener.updateSummaryWatchlist');
    try {
      return super.updateSummaryWatchlist(reportType);
    } finally {
      _$_MarketwatchListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
watchList: ${watchList},
watchListName: ${watchListName}
    ''';
  }
}
