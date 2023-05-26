// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'indices_listener.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IndicesListener on _IndicesListener, Store {
   final _$indices1Atom =
      Atom(name: '_IndicesListener.indices1', );

  @override
  ScripInfoModel get indices1 {
    _$indices1Atom.reportRead();
    return super.indices1;
  }

  @override
  set indices1(ScripInfoModel value) {
    _$indices1Atom.reportWrite(value, super.indices1, () {
      super.indices1 = value;
    });
  }

   final _$indices2Atom =
      Atom(name: '_IndicesListener.indices2', );

  @override
  ScripInfoModel get indices2 {
    _$indices2Atom.reportRead();
    return super.indices2;
  }

  @override
  set indices2(ScripInfoModel value) {
    _$indices2Atom.reportWrite(value, super.indices2, () {
      super.indices2 = value;
    });
  }

   final _$indices3Atom =
      Atom(name: '_IndicesListener.indices3', );

  @override
  ScripInfoModel get indices3 {
    _$indices3Atom.reportRead();
    return super.indices3;
  }

  @override
  set indices3(ScripInfoModel value) {
    _$indices3Atom.reportWrite(value, super.indices3, () {
      super.indices3 = value;
    });
  }

   final _$_IndicesListenerActionController =
      ActionController(name: '_IndicesListener', );

  @override
  void setIndices(int indiceNum, ScripInfoModel model) {
    final _$actionInfo = _$_IndicesListenerActionController.startAction(
        name: '_IndicesListener.setIndices');
    try {
      return super.setIndices(indiceNum, model);
    } finally {
      _$_IndicesListenerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
indices1: ${indices1},
indices2: ${indices2},
indices3: ${indices3}
    ''';
  }
}
