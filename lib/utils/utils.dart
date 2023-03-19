import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String kFormatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String kFormatDateFromTimeStamp(Timestamp? timestamp) {
  return DateFormat.yMMMd().add_EEEE().format(timestamp!.toDate());
}

String kFormatDateFromTimeStampHour(Timestamp? timestamp) {
  return DateFormat.jm().format(timestamp!.toDate());
}

var kDisabledColor = Colors.grey[300];
var kElevatedButtonColor = Colors.deepOrange[200];
var kSemiLightDeepOrange = Colors.deepOrange[300];
var kFillingColor = Colors.deepOrange[100];
