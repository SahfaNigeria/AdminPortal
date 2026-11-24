import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/modules/users/tabs/admins/admins_controller.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_model.dart';

void main() {
  group('AdminsController access review', () {
    test('pending admins require an explicit approval decision', () {
      final controller = AdminsController();
      const admin = AdminModel(
        id: 'admin-id',
        username: 'Admin',
        email: 'admin@example.com',
        accessibleTabs: [AdminTab.users],
      );

      controller.prepareAccessReview(admin);

      expect(controller.draftIsApproved.value, isFalse);
      expect(controller.selectedTabs, [AdminTab.users]);

      controller.setDraftApproval(true);

      expect(controller.draftIsApproved.value, isTrue);
      expect(controller.selectedTabs, [AdminTab.users]);
    });
  });

  test('admin search activates for a query and resets for an empty query', () {
    final controller = AdminsController();
    controller.admins.addAll(
      const [
        AdminModel(
          id: 'one',
          username: 'Admin One',
          email: 'one@example.com',
        ),
        AdminModel(
          id: 'two',
          username: 'Admin Two',
          email: 'two@example.com',
        ),
      ],
    );

    controller.searchAdmins('two');

    expect(controller.isSearchActive.value, isTrue);
    expect(controller.filteredAdmins.map((admin) => admin.id), ['two']);

    controller.searchAdmins('');

    expect(controller.isSearchActive.value, isFalse);
    expect(controller.filteredAdmins, hasLength(2));
  });
}
