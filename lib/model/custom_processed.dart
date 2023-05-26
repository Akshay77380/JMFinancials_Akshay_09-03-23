import 'package:flutter/material.dart';

class CustomProcessed{
  String status;
  DateTime date;
  String totalAmount;
  String bankName;
  int payOutId;

  CustomProcessed(this.status, this.date, this.totalAmount, this.bankName,this.payOutId);

  CustomProcessed.name(this.status, this.date, this.totalAmount, this.bankName,this.payOutId);

  @override
  String toString() {
    return 'CustomProcessed{status: $status, date: $date, totalAmount: $totalAmount, bankName: $bankName, payOutId: $payOutId}';
  }
}