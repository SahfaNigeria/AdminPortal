import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jambomama_nigeria_admin_portal/modules/analytics/admin_analytics_controller.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/custom_pie_chart_widget.dart';
import '../../shared/widgets/dashboard_container_widget.dart';
import '../../shared/widgets/new_users_chart.dart';
import '../../shared/widgets/responsive_arrangement_widget.dart';
import '../../shared/widgets/section_title_widget.dart';
import '../../shared/widgets/statistics_card_widget.dart';

class AdminAnalyticsPage extends GetView<AdminAnalyticsController> {
  const AdminAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Obx(() {
          return DashboardContainerWidget(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SectionTitleWidget(
                  title: "Analytics Overview",
                  subtitle: "Overview of platform statistics",
                  icon: FontAwesomeIcons.chartPie,
                ),
                ResponsiveArrangementWidget(
                  spacing: 16,
                  children: [
                    StatisticsCardWidget(
                      title: "Total Mothers",
                      subtitle: "Registered mothers",
                      icon: FontAwesomeIcons.personBreastfeeding,
                      accentColor: Color(0xFFEC4899),

                      value: controller.mothers.length,
                      trendPercentage: "N/A",
                      isTrendPositive: true,
                    ),
                    StatisticsCardWidget(
                      title: "Total Professionals",

                      subtitle: "Health Professionals",
                      icon: FontAwesomeIcons.userNurse,
                      accentColor: Color(0xFF0EA5E9),

                      value: controller.healthProfessionals.length,
                      trendPercentage: controller.healthProfessionalsTrend,
                      isTrendPositive: controller.currentHealthProfessionals >=
                          controller.previousHealthProfessionals,
                    ),
                    StatisticsCardWidget(
                      title: "Total Administrators",
                      subtitle: "Administrators",
                      icon: FontAwesomeIcons.userGroup,
                      accentColor: Color(0xFF10B981),

                      value: controller.admins.length,
                      trendPercentage: controller.adminsTrend,
                      isTrendPositive: controller.currentAdmins >=
                          controller.previousAdmins,
                    ),
                    StatisticsCardWidget(
                      title: "Total Hospitals",

                      subtitle: "Hospitals",
                      icon: FontAwesomeIcons.hospitalUser,
                      accentColor: AppColors.primary,
                      value: controller.hospitals.length,
                      trendPercentage: controller.hospitalsTrend,
                      isTrendPositive: controller.currentHospitals >=
                          controller.previousHealthProfessionals,
                    ),
                  ],
                )
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
        Obx(() {
          return NewUsersChart(
            title: "User Reach & Growth",
            monthlyData: controller.monthlyChartData,

            yearlyData: controller.yearlyChartData,

            subtitle: "Monthly & yearly tracking of new users reached",
          );
        }),
        const SizedBox(height: 24),
        Obx(() {
          return CustomPieChartWidget(
            mothersCount: controller.mothers.length.toDouble(),
            healthcareCount: controller.healthProfessionals.length.toDouble(),
            adminCount: controller.admins.length.toDouble(),
            hospitalsColor: AppColors.primary,
            hospitalsCount: controller.hospitals.length.toDouble(),
            title: "User Role Distribution",
            subtitle: "Percentage of mothers, healthcare professionals, and admins on the platform",
          );
        }),
        const SizedBox(height: 30),
      ],
    );
  }
}
