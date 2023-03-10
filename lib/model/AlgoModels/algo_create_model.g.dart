// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'algo_create_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AlgoCreateModel on _AlgoCreateModelBase, Store {
  final _$createAlgoAtom =
  Atom(name: '_AlgoCreateModelBase.createAlgo', );

  @override
  CreateAlgoModel get createAlgo {
    _$createAlgoAtom.reportRead();
    return super.createAlgo;
  }

  @override
  set createAlgo(CreateAlgoModel value) {
    _$createAlgoAtom.reportWrite(value, super.createAlgo, () {
      super.createAlgo = value;
    });
  }

  final _$createAlgoListsAtom =
  Atom(name: '_AlgoCreateModelBase.createAlgoLists', );

  @override
  ObservableList<CreateAlgoModel> get createAlgoLists {
    _$createAlgoListsAtom.reportRead();
    return super.createAlgoLists;
  }

  @override
  set createAlgoLists(ObservableList<CreateAlgoModel> value) {
    _$createAlgoListsAtom.reportWrite(value, super.createAlgoLists, () {
      super.createAlgoLists = value;
    });
  }

  @override
  String toString() {
    return '''
createAlgo: ${createAlgo},
createAlgoLists: ${createAlgoLists}
    ''';
  }
}
