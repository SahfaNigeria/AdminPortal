import 'dart:async';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/core/firebase/firebase_reference.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/hospital_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/mothers_model.dart';
import 'package:jambomama_nigeria_admin_portal/shared/utils/firebase_error.dart';

import '../../shared/model/health_professionals.dart';
import '../../shared/widgets/country_distribution_chart.dart';
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
  void onInit() {
    super.onInit();
    listenToMothers();
    listenToAdmins();
    listenToHealthProfessionals();
    listenToHospitals();
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

  // COUNTRY DISTRIBUTION DATA
  List<CountryDataPoint> get mothersCountryData =>
      calculateCountryDistribution(mothers.map((m) => m.countryValue).toList());

  List<CountryDataPoint> get healthProfessionalsCountryData =>
      calculateCountryDistribution(
          healthProfessionals.map((hp) => hp.countryValue).toList());

  List<CountryDataPoint> get adminsCountryData =>
      calculateCountryDistribution(
          admins.map((a) => a.country ?? '').toList());

  List<CountryDataPoint> calculateCountryDistribution(List<String> rawCountries) {
    if (rawCountries.isEmpty) return [];

    final Map<String, int> countMap = {};
    final Map<String, String> flagMap = {};
    final Map<String, String> displayNameMap = {};

    final RegExp flagRegExp = RegExp(r'(\uD83C[\uDDE6-\uDDFF]{2})');

    for (final raw in rawCountries) {
      String trimmed = raw.trim();
      if (trimmed.isEmpty) {
        trimmed = "Unspecified";
      }

      String flag = "";
      String name = trimmed;

      final match = flagRegExp.firstMatch(trimmed);
      if (match != null) {
        flag = match.group(0)!;
        name = trimmed.replaceAll(flagRegExp, '').trim();
        if (name.isEmpty) name = trimmed;
      }

      if (name.isEmpty) {
        name = "Unspecified";
      }

      final normalizedKey = name.toLowerCase();

      if (!flagMap.containsKey(normalizedKey)) {
        if (flag.isNotEmpty) {
          flagMap[normalizedKey] = flag;
        } else {
          flagMap[normalizedKey] = _resolveFlagForCountry(name);
        }
        displayNameMap[normalizedKey] = _formatCountryName(name);
      }

      countMap[normalizedKey] = (countMap[normalizedKey] ?? 0) + 1;
    }

    final total = rawCountries.length.toDouble();
    final sortedEntries = countMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      final key = entry.key;
      final count = entry.value;
      final pct = total > 0 ? (count / total) * 100 : 0.0;
      return CountryDataPoint(
        rawCountry: key,
        countryName: displayNameMap[key] ?? key,
        flagEmoji: flagMap[key] ?? "🌐",
        count: count,
        percentage: pct,
      );
    }).toList();
  }

  String _formatCountryName(String name) {
    if (name.toLowerCase() == "unspecified") return "Unspecified";
    return name.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _resolveFlagForCountry(String name) {
    final lower = name.toLowerCase().trim();
    if (lower.contains("nigeria")) return "🇳🇬";
    if (lower.contains("ghana")) return "🇬🇭";
    if (lower.contains("kenya")) return "🇰🇪";
    if (lower.contains("uganda")) return "🇺🇬";
    if (lower.contains("south africa")) return "🇿🇦";
    if (lower.contains("united states") || lower == "usa" || lower == "us") return "🇺🇸";
    if (lower.contains("united kingdom") || lower == "uk") return "🇬🇧";
    if (lower.contains("canada")) return "🇨🇦";
    if (lower.contains("cameroon")) return "🇨🇲";
    if (lower.contains("niger")) return "🇳🇪";
    if (lower.contains("benin")) return "🇧🇯";
    if (lower.contains("togo")) return "🇹🇬";
    if (lower.contains("senegal")) return "🇸🇳";
    if (lower.contains("rwanda")) return "🇷🇼";
    if (lower.contains("tanzania")) return "🇹🇿";
    if (lower.contains("ethiopia")) return "🇪🇹";
    if (lower == "unspecified") return "🌐";
    return "🌐";
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
  void onClose() {
    _mothersSubscription?.cancel();
    _adminsSubscription?.cancel();
    _healthProfessionalsSubscription?.cancel();
    _hospitalsSubscription?.cancel();
    super.onClose();
  }
}
