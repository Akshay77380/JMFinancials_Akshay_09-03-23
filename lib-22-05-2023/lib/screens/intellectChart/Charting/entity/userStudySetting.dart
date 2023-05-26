class UserStudySetting {
  int study_index;
  int tstudy_type;
  int Subgraph;
  String parameters;
  String colors;
  String drawStyle;

  UserStudySetting(this.study_index, this.tstudy_type, this.Subgraph,
      this.parameters, this.colors, this.drawStyle);

  Map toJson() {
    return {
      'study_index': study_index,
      'tstudy_type': tstudy_type,
      'Subgraph': Subgraph,
      'parameters': parameters,
      'colors': colors,
      'drawStyle': drawStyle
    };
  }
}
