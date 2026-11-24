import 'dart:async';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/hospital_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/mothers_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';

import '../../shared/model/health_professionals.dart';
import '../../shared/widgets/new_users_chart.dart';

class AdminAnalyticsController extends GetxController {
  final admins = <AdminModel>[].obs;

  final healthProfessionals = <HealthProfessionalsModel>[].obs;

  final mothers = <MothersModel>[].obs;

  final hospitals = <HospitalModel>[].obs;


  // HOSPITALS
  int get currentHospitals => getCurrentMonthCount(hospitals);

  int get previousHospitals => getPreviousMonthCount(hospitals);


// ADMINS
  int get currentAdmins => getCurrentMonthCount(admins);

  int get previousAdmins => getPreviousMonthCount(admins);


// HEALTH PROFESSIONALS
  int get currentHealthProfessionals =>
      getCurrentMonthCount(healthProfessionals);

  int get previousHealthProfessionals =>
      getPreviousMonthCount(healthProfessionals);
  String calculateTrend({
    required int current,
    required int previous,
  }) {
    if (previous == 0) {
      return current > 0 ? '+100%' : '0%';
    }

    final percentage = ((current - previous) / previous) * 100;

    return '${percentage >= 0 ? '+' : ''}${percentage.toStringAsFixed(1)}%';
  }

  int getCurrentMonthCount(List<dynamic> records) {
    final now = DateTime.now();

    return records.where((record) {
      final date = record.createdAt;

      return date != null &&
          date.year == now.year &&
          date.month == now.month;
    }).length;
  }

  int getPreviousMonthCount(List<dynamic> records) {
    final now = DateTime.now();

    final previousMonth = DateTime(now.year, now.month - 1, 1);

    return records.where((record) {
      final date = record.createdAt;

      return date != null &&
          date.year == previousMonth.year &&
          date.month == previousMonth.month;
    }).length;
  }

  String get hospitalsTrend => calculateTrend(
    current: currentHospitals,
    previous: previousHospitals,
  );

  String get adminsTrend => calculateTrend(
    current: currentAdmins,
    previous: previousAdmins,
  );

  String get healthProfessionalsTrend => calculateTrend(
    current: currentHealthProfessionals,
    previous: previousHealthProfessionals,
  );

  late StreamSubscription? _mothersSubscription,
      _adminsSubscription,
      _healthProfessionalsSubscription,
      _hospitalsSubscription;

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    listenToMothers();
    listenToAdmins();
    listenToHealthProfessionals();
    listenToHospitals();
  }

  @override
  void onInit() {
    super.onInit();
  }

  void listenToMothers() {
    _mothersSubscription =
        FirebaseReference.mothers.snapshots().listen((snapshot) {
      mothers.value = snapshot.docs.map((doc) {
        return MothersModel.fromJson(doc.data(), id: doc.id);
      }).toList();
    }, onError: (error) {
      FirebaseError.handle(error);
    });
  }

  void listenToAdmins() {
    _adminsSubscription =
        FirebaseReference.admins.snapshots().listen((snapshot) {
      admins.value = snapshot.docs.map((doc) {
        return AdminModel.fromMap(doc.data(), id: doc.id);
      }).toList();
    }, onError: (error) {
      FirebaseError.handle(error);
    });
  }

  void listenToHealthProfessionals() {
    _healthProfessionalsSubscription =
        FirebaseReference.healthProfessionals.snapshots().listen((snapshot) {
      healthProfessionals.value = snapshot.docs.map((doc) {
        return HealthProfessionalsModel.fromJson(doc.data(), id: doc.id);
      }).toList();
    }, onError: (error) {
      FirebaseError.handle(error);
    });
  }

  List<NewUserDataPoint> get monthlyChartData {
    final now = DateTime.now();

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr',
      'May', 'Jun', 'Jul', 'Aug',
      'Sep', 'Oct', 'Nov', 'Dec',
    ];

    // Collect registration dates from collections
    final dates = <DateTime>[];

    dates.addAll(
      hospitals.map((e) => e.createdAt).whereType<DateTime>(),
    );

    dates.addAll(
      admins.map((e) => e.createdAt).whereType<DateTime>(),
    );

    dates.addAll(
      healthProfessionals.map((e) => e.createdAt).whereType<DateTime>(),
    );

    return List.generate(12, (index) {
      final month = index + 1;

      final count = dates.where((date) {
        return date.year == now.year && date.month == month;
      }).length;

      return NewUserDataPoint(
        label: months[index],
        value: count.toDouble(),
        month: month,
        year: now.year,
      );
    });
  }

  List<NewUserDataPoint> get yearlyChartData {
    final now = DateTime.now();

    final dates = <DateTime>[];

    dates.addAll(
      hospitals.map((e) => e.createdAt).whereType<DateTime>(),
    );

    dates.addAll(
      admins.map((e) => e.createdAt).whereType<DateTime>(),
    );

    dates.addAll(
      healthProfessionals.map((e) => e.createdAt).whereType<DateTime>(),
    );

    return List.generate(5, (index) {
      final year = now.year - 4 + index;

      final count = dates.where((date) {
        return date.year == year;
      }).length;

      return NewUserDataPoint(
        label: year.toString(),
        value: count.toDouble(),
        year: year,
      );
    });
  }

  void listenToHospitals() {
    _hospitalsSubscription =
        FirebaseReference.hospitals.snapshots().listen((snapshot) {
      hospitals.value = snapshot.docs.map((doc) {
        return HospitalModel.fromJson(doc.data(), doc.id);
      }).toList();
    }, onError: (error) {
      FirebaseError.handle(error);
    });
  }

  @override
  void dispose() {
    _mothersSubscription?.cancel();
    _adminsSubscription?.cancel();
    _healthProfessionalsSubscription?.cancel();
    _hospitalsSubscription?.cancel();
    super.dispose();
  }


}
