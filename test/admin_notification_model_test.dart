import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jambomama_nigeria_admin_portal/shared/model/admin_notification_model.dart';

void main() {
  group('AdminNotificationModel', () {
    test('creates model with defaults', () {
      const model = AdminNotificationModel(fid: 'token_123');

      expect(model.fid, 'token_123');
      expect(model.platform, 'web');
      expect(model.notificationsEnabled, isTrue);
      expect(model.lastUpdated, isNull);
    });

    test('serializes toMap correctly with Timestamp', () {
      final now = DateTime.now();
      final model = AdminNotificationModel(
        fid: 'token_123',
        platform: 'web',
        notificationsEnabled: true,
        lastUpdated: now,
      );

      final map = model.toMap();
      expect(map['fid'], 'token_123');
      expect(map['platform'], 'web');
      expect(map['notificationsEnabled'], true);
      expect(map['lastUpdated'], isA<Timestamp>());
      expect((map['lastUpdated'] as Timestamp).toDate().millisecondsSinceEpoch,
          now.millisecondsSinceEpoch);
    });

    test('deserializes fromMap with Timestamp correctly', () {
      final now = DateTime.now();
      final map = {
        'fid': 'token_456',
        'platform': 'android',
        'notificationsEnabled': false,
        'lastUpdated': Timestamp.fromDate(now),
      };

      final model = AdminNotificationModel.fromMap(map);
      expect(model.fid, 'token_456');
      expect(model.platform, 'android');
      expect(model.notificationsEnabled, false);
      expect(model.lastUpdated?.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch);
    });

    test('deserializes fromMap with nullable/missing lastUpdated', () {
      final map = {
        'fid': 'token_789',
      };

      final model = AdminNotificationModel.fromMap(map);
      expect(model.fid, 'token_789');
      expect(model.platform, 'web');
      expect(model.notificationsEnabled, true);
      expect(model.lastUpdated, isNull);
    });

    test('copyWith works properly', () {
      const model = AdminNotificationModel(fid: 'token_123');
      final updated = model.copyWith(notificationsEnabled: false);

      expect(updated.fid, 'token_123');
      expect(updated.notificationsEnabled, false);
    });
  });
}
