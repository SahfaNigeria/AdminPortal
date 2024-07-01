import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/approval_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/com_health_workers_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/dashboard_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/hospital_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/medical_practitioner_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/mothers_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/transport_screen.dart';
import 'package:jambomama_nigeria_admin_portal/views/screens/sidebar_screens/upload_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedItem = DashboardScreen();

  screenSelector(item) {
    switch (item.route) {
      case DashboardScreen.routeName:
        setState(() {
          _selectedItem = DashboardScreen();
        });
        break;
      case MotherScreen.routeName:
        setState(() {
          _selectedItem = MotherScreen();
        });
        break;
      case ApprovalScreen.routeName:
        setState(() {
          _selectedItem = ApprovalScreen();
        });
        break;
      case MedicalScreen.routeName:
        setState(() {
          _selectedItem = MedicalScreen();
        });

      case CWHScreen.routeName:
        setState(() {
          _selectedItem = CWHScreen();
        });
        break;

      case UploadScreen.routeName:
        setState(() {
          _selectedItem = UploadScreen();
        });
      case TransportScreen.routeName:
        setState(() {
          _selectedItem = TransportScreen();
        });
        break;
      case HospitalScreen.routeName:
        setState(() {
          _selectedItem = HospitalScreen();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Jambo Mama Nigeria Management Portal',
          style: TextStyle(fontSize: 18),
        ),
      ),
      sideBar: SideBar(
        items: [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashboardScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Mothers',
            route: MotherScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Mid Wives',
            route: MedicalScreen.routeName,
            icon: CupertinoIcons.heart,
          ),
          AdminMenuItem(
            title: 'CHW',
            route: CWHScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Hospital',
            route: HospitalScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Approval',
            route: ApprovalScreen.routeName,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            route: UploadScreen.routeName,
            icon: CupertinoIcons.add,
          ),
          AdminMenuItem(
            title: 'Transportation',
            route: TransportScreen.routeName,
            icon: Icons.dashboard,
          ),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Admin',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'c. 2024',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: _selectedItem,
    );
  }
}
