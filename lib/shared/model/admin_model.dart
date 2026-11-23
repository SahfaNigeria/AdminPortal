enum AccountType {
  superAdmin,
  admin;

  String get displayName {
    switch (this) {
      case AccountType.superAdmin:
        return "Super Admin";
      case AccountType.admin:
        return "Admin";
    }
  }

  String toValue() {
    switch (this) {
      case AccountType.superAdmin:
        return "super_admin";
      case AccountType.admin:
        return "admin";
    }
  }

  static AccountType fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case "super_admin":
      case "superadmin":
        return AccountType.superAdmin;
      case "admin":
      default:
        return AccountType.admin;
    }
  }
}

enum AdminTab {
  analytics,
  users,
  hospital,
  approval;

  String get displayName {
    switch (this) {
      case AdminTab.analytics:
        return "Analytics";
      case AdminTab.users:
        return "Users";
      case AdminTab.hospital:
        return "Hospital";
      case AdminTab.approval:
        return "Approval";
    }
  }

  String toValue() {
    switch (this) {
      case AdminTab.analytics:
        return "analytics";
      case AdminTab.users:
        return "users";
      case AdminTab.hospital:
        return "hospital";
      case AdminTab.approval:
        return "approval";
    }
  }

  static AdminTab? fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case "analytics":
        return AdminTab.analytics;
      case "users":
        return AdminTab.users;
      case "hospital":
        return AdminTab.hospital;
      case "approval":
        return AdminTab.approval;
      default:
        return null;
    }
  }
}

class AdminModel {
  final String id;
  final String username;
  final String email;
  final String? displayPhoto;
  final AccountType accountType;
  final List<AdminTab> accessibleTabs;
  final String? approvedBySuperAdminId;
  final bool isApproved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AdminModel({
    required this.id,
    required this.username,
    required this.email,
    this.displayPhoto,
    this.accountType = AccountType.admin,
    this.accessibleTabs = const [],
    this.approvedBySuperAdminId = "",
    this.isApproved = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Returns true if this user is a Super Admin
  bool get isSuperAdmin => accountType == AccountType.superAdmin;

  /// Returns true if this user is a regular Admin
  bool get isAdmin => accountType == AccountType.admin;

  /// Returns true if the user has permission to access a specific tab.
  /// Super Admins automatically have full access to all tabs.
  bool hasTabAccess(AdminTab tab) {
    if (isSuperAdmin) return true;
    return isApproved && accessibleTabs.contains(tab);
  }

  AdminModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayPhoto,
    AccountType? accountType,
    List<AdminTab>? accessibleTabs,
    String? approvedBySuperAdminId,
    bool? isApproved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayPhoto: displayPhoto ?? this.displayPhoto,
      accountType: accountType ?? this.accountType,
      accessibleTabs: accessibleTabs ?? this.accessibleTabs,
      approvedBySuperAdminId:
          approvedBySuperAdminId ?? this.approvedBySuperAdminId,
      isApproved: isApproved ?? this.isApproved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayPhoto': displayPhoto,
      'accountType': accountType.toValue(),
      'accessibleTabs': accessibleTabs.map((tab) => tab.toValue()).toList(),
      'approvedBySuperAdminId': approvedBySuperAdminId,
      'isApproved': isApproved,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map, {
    String? id,
  }) {
    return AdminModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayPhoto: map['displayPhoto'],
      accountType: AccountType.fromValue(map['accountType']),
      accessibleTabs: (map['accessibleTabs'] as List<dynamic>?)
              ?.map((item) => AdminTab.fromValue(item.toString()))
              .whereType<AdminTab>()
              .toList() ??
          [],
      approvedBySuperAdminId: map['approvedBySuperAdminId']??"",
      isApproved: map['isApproved'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'].toString())
          : null,
    );
  }
}
