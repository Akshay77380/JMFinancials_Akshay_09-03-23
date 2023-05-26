
import 'package:mobx/mobx.dart';

import 'algoCreate_model2.dart';
part 'algo_create_model.g.dart';

class AlgoCreateModel = _AlgoCreateModelBase with _$AlgoCreateModel;

abstract class _AlgoCreateModelBase with Store {
  @observable
  CreateAlgoModel createAlgo= CreateAlgoModel();
  @observable
  ObservableList<CreateAlgoModel> createAlgoLists = ObservableList<CreateAlgoModel>();
  void getEquityModel(Map<String, dynamic> algo) {

    // algoLogLists.clear();
    createAlgo = CreateAlgoModel.fromJson(algo);
    createAlgoLists.add(createAlgo);
    //  Dataconstants.algoLogListsNew.algoLogLists.add(fetchAlgo);
  }


}