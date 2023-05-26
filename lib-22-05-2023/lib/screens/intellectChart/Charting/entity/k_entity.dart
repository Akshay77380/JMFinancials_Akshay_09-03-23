import 'candle_entity.dart';
import 'kdj_entity.dart';
import 'macd_entity.dart';
import 'rsi_entity.dart';
import 'rw_entity.dart';
import 'volume_entity.dart';
import 'cci_entity.dart';
import 'atr_entity.dart';
import 'adx_entity.dart';

class KEntity
    with
        CandleEntity,
        VolumeEntity,
        KDJEntity,
        RSIEntity,
        WREntity,
        CCIEntity,
        ATREntity,
        ADXEntity,
        MACDEntity {}
