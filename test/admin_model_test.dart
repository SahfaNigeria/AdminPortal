import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';

void main() {
  group('AdminModel tab access', () {
    test('unapproved accounts have no tab access', () {
      const admin = AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        accountType: AccountType.superAdmin,
      );

      expect(admin.hasTabAccess(AdminTab.analytics), isFalse);
    });

    test('approved admins only have their assigned tabs', () {
      const admin = AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        accessibleTabs: [AdminTab.users],
        isApproved: true,
      );

      expect(admin.hasTabAccess(AdminTab.users), isTrue);
      expect(admin.hasTabAccess(AdminTab.analytics), isFalse);
    });

    test('approved super admins have access to every tab', () {
      const admin = AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        accountType: AccountType.superAdmin,
        isApproved: true,
      );

      for (final tab in AdminTab.values) {
        expect(admin.hasTabAccess(tab), isTrue);
      }
    });
  });

  test('fromMap uses Firestore document ID when map ID is absent', () {
    final admin = AdminModel.fromMap(
      {'username': 'Admin', 'email': 'admin@example.com'},
      id: 'firestore-document-id',
    );

    expect(admin.id, 'firestore-document-id');
  });
}
