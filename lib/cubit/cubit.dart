import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_all/cubit/cubit_status.dart';
import 'package:test_all/modal.dart';

class AlarmCubit extends Cubit<AlarmStatus> {
  AlarmCubit() : super(AlarmInitStatus());

  static AlarmCubit get(context) => BlocProvider.of(context);

  int count = 0;

  late List<SchoolTable> dailyTable;
  String currentDay = DateFormat('EEEE').format(DateTime.now());
  void increaseCount() {
    count = count + 1;
    emit(IncreaseCountStatus());
  }

  getDailyTable() {
    emit(GetDailyTableLoadingStates());
    FirebaseFirestore.instance
        .collection('school')
        .doc('9046')
        .collection('depart')
        .doc('90461000')
        .collection(currentDay)
        .snapshots()
        .forEach((element) {
          dailyTable = [];
          for (var value in element.docs) {
            dailyTable.add(SchoolTable.fromJson(value.data()));
          }
        })
        .then((value) => emit(GetDailyTableSuccessStates()))
        .catchError((onError) => emit(GetDailyTableErrorStates()));
  }

  getAlertTable() {
    emit(GetAlertLoadingStates());
    FirebaseFirestore.instance
        .collection('school')
        .doc('9046')
        .collection('depart')
        .doc('90461000')
        .collection('alert')
        .snapshots()
        .forEach((element) {
      alertData = [];
      for (var value in element.docs) {
        if (value.data()['read'] != true) {
          alertData.add(SchoolAlert.formJson(value.data()));
        }
      }
    }).then((value) => emit(GetAlertSuccessStates())).catchError((error)=>emit(GetAlertErrorStates()));
  }
}
