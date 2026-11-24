import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/modules/profile/access/admin_access_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';

void main() {
  group('AdminAccessController destinations', () {
    test('approved admins without assigned tabs go to the no-access page', () {
      final controller = AdminAccessController();
      controller.admin.value = const AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        isApproved: true,
      );

      expect(controller.hasAnyTabAccess, isFalse);
      expect(controller.firstAccessibleLocation, '/admin/no-tabs-assigned');
    });

    test('contents access resolves to the contents route', () {
      final controller = AdminAccessController();
      controller.admin.value = const AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        accessibleTabs: [AdminTab.contents],
        isApproved: true,
      );

      expect(controller.tabForLocation('/admin/contents'), AdminTab.contents);
      expect(controller.hasAnyTabAccess, isTrue);
      expect(controller.firstAccessibleLocation, '/admin/contents');
    });
  });
}
