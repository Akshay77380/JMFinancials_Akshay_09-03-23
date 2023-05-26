// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predefined_watch_listener.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$predefined_watch_listener on _predefined_watch_listener, Store {
   final _$watchListAtom =
      Atom(name: '_predefined_watch_listener.watchList', );

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
      Atom(name: '_predefined_watch_listener.watchListName', );

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
      '_predefined_watch_listener.addToPredefinedWatchListBulk',
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

   final _$_predefined_watch_listenerActionController =
      ActionController(name: '_predefined_watch_listener', );

  @override
  void sortListbyName(bool isDescending) {
    final _$actionInfo = _$_predefined_watch_listenerActionController
        .startAction(name: '_predefined_watch_listener.sortListbyName');
    try {
      return super.sortListbyName(isDescending);
    } finally {
      _$_predefined_watch_listenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortListbyPrice(bool isDescending) {
    final _$actionInfo = _$_predefined_watch_listenerActionController
        .startAction(name: '_predefined_watch_listener.sortListbyPrice');
    try {
      return super.sortListbyPrice(isDescending);
    } finally {
      _$_predefined_watch_listenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sortListbyPercent(bool isDescending) {
    final _$actionInfo = _$_predefined_watch_listenerActionController
        .startAction(name: '_predefined_watch_listener.sortListbyPercent');
    try {
      return super.sortListbyPercent(isDescending);
    } finally {
      _$_predefined_watch_listenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeBulkFromPredefinedWatchList() {
    final _$actionInfo =
        _$_predefined_watch_listenerActionController.startAction(
            name:
                '_predefined_watch_listener.removeBulkFromPredefinedWatchList');
    try {
      return super.removeBulkFromPredefinedWatchList();
    } finally {
      _$_predefined_watch_listenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWatchListName(String newName) {
    final _$actionInfo = _$_predefined_watch_listenerActionController
        .startAction(name: '_predefined_watch_listener.setWatchListName');
    try {
      return super.setWatchListName(newName);
    } finally {
      _$_predefined_watch_listenerActionController.endAction(_$actionInfo);
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
