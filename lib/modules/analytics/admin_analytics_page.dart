import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import '../../core/theme/colors.dart';
import '../../shared/widgets/custom_pie_chart_widget.dart';
import '../../shared/widgets/dashboard_container_widget.dart';
import '../../shared/widgets/new_users_chart.dart';
import '../../shared/widgets/responsive_arrangement_widget.dart';
import '../../shared/widgets/section_title_widget.dart';
import '../../shared/widgets/statistics_card_widget.dart';

class AdminAnalyticsPage extends StatelessWidget {
  const AdminAnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          DashboardContainerWidget(
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
                  children: const [
                    StatisticsCardWidget(
                      title: "Total Mothers",
                      value: 2450,
                      subtitle: "Registered mothers",
                      icon: FontAwesomeIcons.personBreastfeeding,
                      accentColor: Color(0xFFEC4899),
                      trendPercentage: "+14%",
                    ),
                    StatisticsCardWidget(
                      title: "Total Professionals",
                      value: 380,
                      subtitle: "Health Professionals",
                      icon: FontAwesomeIcons.userNurse,
                      accentColor: Color(0xFF0EA5E9),
                      trendPercentage: "+8%",
                    ),
                    StatisticsCardWidget(
                      title: "Total Administrators",
                      value: 380,
                      subtitle: "Administrators",
                      icon: FontAwesomeIcons.userGroup,
                      accentColor: Color(0xFF10B981),
                      trendPercentage: "+8%",
                    ),
                    StatisticsCardWidget(
                      title: "Pending Approvals",
                      value: 18,
                      subtitle: "Awaiting review",
                      icon: FontAwesomeIcons.clipboardCheck,
                      accentColor: AppColors.primary,
                      trendPercentage: "-2%",
                      isTrendPositive: false,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          const NewUsersChart(
            title: "User Reach & Growth",

            subtitle: "Monthly & yearly tracking of new users reached",
          ),
          const SizedBox(height: 24),
          const CustomPieChartWidget(
            maleCount: 1250,
            femaleCount: 1580,
            title: "Gender Distribution",
            subtitle: "Percentage of men and women on the platform",
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
