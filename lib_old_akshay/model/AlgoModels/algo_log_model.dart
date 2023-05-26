//
// import 'package:markets/model/AlgoModels/aloLog_Model.dart';
// import 'package:mobx/mobx.dart';
//
//
//
// class AlgoLogModel = _AlgoLogModelBase with _$AlgoLogModel;
//
// abstract class _AlgoLogModelBase with Store {
//   @observable
//   AlgoLog algoLog=AlgoLog();
//   bool getAlgoLogOrders = false;
//   @action
//   void updateGetAlgoLogOrders(bool value) {
//     getAlgoLogOrders = value;
//   }
//   @observable
//   ObservableList<AlgoLog> algoLogLists = ObservableList<AlgoLog>();
//   void getEquityModel(Map<String, dynamic> algo) {
//
//     // algoLogLists.clear();
//     algoLog = AlgoLog.fromJson(algo);
//     algoLogLists.add(algoLog);
//     //  Dataconstants.algoLogListsNew.algoLogLists.add(fetchAlgo);
//   }
//
//
// }
