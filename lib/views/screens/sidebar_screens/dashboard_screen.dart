import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '\DashboardScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jambo Mama Admin Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Summary Section
            _buildOverviewSection(),
            Divider(),
            // Quick Actions Section
            _buildQuickActionsSection(context),
            Divider(),
            // Real-Time Notifications Section
            _buildNotificationsSection(),
            Divider(),
            // Reports and Insights Section
            _buildReportsSection(),
            Divider(),
            // User Management Section
            _buildUserManagementSection(),
          ],
        ),
      ),
    );
  }

  // Overview Section with dummy data
  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOverviewTile("Total Users", "1500"),
              _buildOverviewTile("New Feedback", "5"),
              _buildOverviewTile("Open Tickets", "3"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOverviewTile("Daily Active Users", "120"),
              _buildOverviewTile("Health Facilities", "45"),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for overview tiles
  Widget _buildOverviewTile(String title, String data) {
    return Column(
      children: [
        Text(data, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Quick Actions Section with dummy buttons
  Widget _buildQuickActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildActionButton(context, "Add Health Facility"),
              _buildActionButton(context, "View All Feedback"),
              _buildActionButton(context, "Ticketing System"),
              _buildActionButton(context, "Manage Connections"),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for action buttons
  Widget _buildActionButton(BuildContext context, String title) {
    return ElevatedButton(
      onPressed: () {
        // Implement action
      },
      child: Text(title),
    );
  }

  // Notifications Section with dummy alerts
  Widget _buildNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Real-Time Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("New connection request from user ID: 12345"),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("5 new feedback messages"),
              ),
              ListTile(
                leading: Icon(Icons.support_agent),
                title: Text("3 open tickets need resolution"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Reports Section with dummy charts (placeholders)
  Widget _buildReportsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Reports & Insights",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildReportPlaceholder("User Demographics"),
          _buildReportPlaceholder("Health Facility Usage"),
          _buildReportPlaceholder("Feedback Analysis"),
        ],
      ),
    );
  }

  // Helper method for report placeholders
  Widget _buildReportPlaceholder(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 100,
        color: Colors.grey[300],
        child: Center(
            child: Text(title, style: TextStyle(color: Colors.grey[700]))),
      ),
    );
  }

  // User Management Section
  Widget _buildUserManagementSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("User Management",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Total Patients: 1200"),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Total Health Providers: 300"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
