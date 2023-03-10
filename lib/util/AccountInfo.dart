class AccountInfo {
  String matchAccount = '',
      dpId = '',
      dpClientId = '',
      dpBankName = '',
      nsePipeId = '',
      fnoPipeId = '',
      bsePipeId = '',
      currPipeId = '',
      currBsePipeId = '',
      custBankAccount = '',
      uccClientStaus = '',
      custAlais = '',
      poaSmsFlag = '',
      damTransaction,
      blockDepositFlag = '',
      UccRejectionRemarks = '',
      commodityPipeId = '';
  bool allowNseCash = false,
      allowTrading = false,
      allowNseDeriv = false,
      allowNseCurr = false,
      allowBseCash = false,
      allowMcx = false,
      allowBseCurr = false,
      popUpFlag = false,
      isSpan = false,
      allowCommodity = false,
      custD2UFlag = false,
      commodityMandateAccept;

  AccountInfo(Map<String, dynamic> success) {
    allowTrading = success['TradingAllowedFlag'] == 'Y' ? true : false;
    allowNseCash =
        allowBseCash = success['EquityEnableFlag'] == 'Y' ? true : true;
    allowNseDeriv = success['FNOEnableFlag'] == 'Y' ? true : true;
    allowNseCurr =
        allowBseCurr = success['CurrencyEnableFlag'] == 'Y' ? true : false;
    allowCommodity = success['CommodityEnableFlag'] == 'Y' ? true : false;
    matchAccount = success['MatchAccount'];
    dpId = success['DPId'];
    dpClientId = success['DPClientId'];
    nsePipeId = success['NSEPipeId'];
    bsePipeId = success['BSEPipeId'];
    fnoPipeId = success['FNOPipeId'];
    currPipeId = success['CurrencyPipeId'];
    currBsePipeId = success['CurrencyBSEPipeId'];
    commodityPipeId = success['CommodityPipeId'];
    isSpan = success['NSESpanFlag'] == 'Y' ? true : false;
    poaSmsFlag = success['POASMSflg'];
    blockDepositFlag = success['BlockDepositflg'];
    custD2UFlag = success['CustomerD2UFlag'] == 'Y' ? true : false;
    uccClientStaus = success['UCCclientstatus'];
    custBankAccount = success['Customerbankaccount'];
    custAlais = success['customeralias'];
    dpBankName = success['DPBankName'];
    commodityMandateAccept =
        success['CommodityMandateAcceptFlag'] == 'Y' ? true : false;
    damTransaction = success['Output_DAM_TRNSCTN'];
    UccRejectionRemarks = success['UccRejectionRemarks']??'';
  }
}
