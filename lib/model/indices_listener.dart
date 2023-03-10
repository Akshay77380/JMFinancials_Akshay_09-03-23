import '../model/scrip_info_model.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'indices_listener.g.dart';

class IndicesListener = _IndicesListener with _$IndicesListener;

abstract class _IndicesListener with Store {
  @observable
  ScripInfoModel indices1 = ScripInfoModel();
  @observable
  ScripInfoModel indices2 = ScripInfoModel();
  @observable
  ScripInfoModel indices3 = ScripInfoModel();
  @observable

  _IndicesListener() {
    getIndicesFromPref();
  }

  @action
  void setIndices(int indiceNum, ScripInfoModel model) {
    int exchPos = CommonFunction.getExchPosOnCode(model.exch, model.exchCode);
    int scripPos = Dataconstants.exchData[exchPos].scripPos(model.exchCode);
    if (scripPos < 0) {
      Dataconstants.exchData[exchPos].addModel(model);
      Dataconstants.iqsClient.sendLTPRequest(model, true);
      if (indiceNum == 0)
        indices1 = model;
      else if (indiceNum == 1)
        indices2 = model;
      else if (indiceNum == 2)
        indices3 = model;

    } else {
      Dataconstants.iqsClient.sendLTPRequest(model, true);
      if (indiceNum == 0)
        indices1 = Dataconstants.exchData[exchPos].getModel(scripPos);
      else if (indiceNum == 1)
        indices2 = Dataconstants.exchData[exchPos].getModel(scripPos);
      else if (indiceNum == 2)
        indices3 = Dataconstants.exchData[exchPos].getModel(scripPos);

    }
    _saveIndicesToPref(indiceNum);
  }

  void getIndicesFromPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String indices1Exch = pref.getString('indices1Exch');
    int indices1ExchCode = pref.getInt('indices1ExchCode');
    if (indices1Exch == null || indices1Exch.isEmpty) {
      indices1Exch = 'N';
      indices1ExchCode = 26000;
    }
    ScripInfoModel model = CommonFunction.getScripDataModel(
      exch: indices1Exch,
      exchCode: indices1ExchCode,
    );
    setIndices(0, model);

    String indices2Exch = pref.getString('indices2Exch');
    int indices2ExchCode = pref.getInt('indices2ExchCode');
    if (indices2Exch == null || indices2Exch.isEmpty) {
      indices2Exch = 'B';
      indices2ExchCode = 999901;
    }
    ScripInfoModel modelB = CommonFunction.getScripDataModel(
      exch: indices2Exch,
      exchCode: indices2ExchCode,
    );
    setIndices(1, modelB);

    String indices3Exch = pref.getString('indices3Exch');
    int indices3ExchCode = pref.getInt('indices3ExchCode');
    if (indices3Exch == null || indices3Exch.isEmpty) {
      indices3Exch = 'N';
      indices3ExchCode = 26009;
    }
    ScripInfoModel modelC = CommonFunction.getScripDataModel(
      exch: indices3Exch,
      exchCode: indices3ExchCode,
    );
    setIndices(2, modelC);

  }

  void _saveIndicesToPref(int indiceNum) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (indiceNum == 0) {
      pref.setString('indices1Exch', indices1.exch);
      pref.setInt('indices1ExchCode', indices1.exchCode);
    } else if (indiceNum == 1) {
      pref.setString('indices2Exch', indices2.exch);
      pref.setInt('indices2ExchCode', indices2.exchCode);
    } else if (indiceNum == 2) {
      pref.setString('indices3Exch', indices3.exch);
      pref.setInt('indices3ExchCode', indices3.exchCode);
    }
  }
}
