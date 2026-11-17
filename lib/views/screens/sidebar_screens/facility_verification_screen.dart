import 'package:flutter/material.dart'
    show
        AppBar,
        BorderRadius,
        BorderSide,
        BoxDecoration,
        BuildContext,
        Card,
        Center,
        CircularProgressIndicator,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        DraggableScrollableSheet,
        DropdownButtonFormField,
        DropdownMenuItem,
        EdgeInsets,
        ElevatedButton,
        Expanded,
        FloatingActionButton,
        FontWeight,
        Form,
        FormState,
        GlobalKey,
        Icon,
        IconButton,
        IconData,
        Icons,
        InputDecoration,
        Key,
        ListView,
        MainAxisAlignment,
        MediaQuery,
        Navigator,
        OutlineInputBorder,
        OutlinedButton,
        Padding,
        Radius,
        RefreshIndicator,
        RoundedRectangleBorder,
        Row,
        Scaffold,
        ScaffoldMessenger,
        SizedBox,
        SnackBar,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextEditingController,
        TextFormField,
        TextInputType,
        TextStyle,
        VoidCallback,
        Widget,
        showModalBottomSheet,
        TextAlign,
        Border,
        showDialog,
        AlertDialog,
        TextButton,
        MainAxisSize,
        Dialog,
        Chip,
        Divider,
        ListTile,
        FutureBuilder,
        AsyncSnapshot,
        ConnectionState,
        Tab,
        TabBar,
        TabBarView,
        TabController,
        TickerProviderStateMixin,
        SingleTickerProviderStateMixin,
        Badge,
        Flexible,
        WillPopScope,
        kToolbarHeight,
        ScrollController,
        BoxConstraints,
        IntrinsicHeight,
        VerticalDivider,
        Wrap,
        Spacer,
        InkWell,
        debugPrint;

import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODEL
// ─────────────────────────────────────────────────────────────────────────────

class PendingFacility {
  final String id;
  String name;
  String type;
  String address;
  String phoneNumber;
  String district;
  String submittedBy;
  DateTime? submittedAt;

  PendingFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.phoneNumber,
    required this.district,
    required this.submittedBy,
    this.submittedAt,
  });

  factory PendingFacility.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PendingFacility(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      district: data['district'] ?? '',
      submittedBy: data['submittedBy'] ?? '',
      submittedAt: (data['submittedAt'] as Timestamp?)?.toDate(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class FacilityVerificationScreen extends StatefulWidget {
  static const String routeName = '/facility-verification';
  const FacilityVerificationScreen({Key? key}) : super(key: key);

  @override
  State<FacilityVerificationScreen> createState() =>
      _FacilityVerificationScreenState();
}

class _FacilityVerificationScreenState
    extends State<FacilityVerificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  List<PendingFacility> _pendingFacilities = [];

  @override
  void initState() {
    super.initState();
    _loadPendingFacilities();
  }

  Future<void> _loadPendingFacilities() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore
          .collection('health_facilities')
          .where('status', isEqualTo: false)
          .orderBy('submittedAt', descending: true)
          .get();

      setState(() {
        _pendingFacilities =
            snapshot.docs.map((doc) => PendingFacility.fromDoc(doc)).toList();
      });
    } catch (e) {
      debugPrint('🔴 FIRESTORE INDEX ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Error loading facilities: $e')),
      //   );
      // }
    }
    setState(() => _isLoading = false);
  }

  /// Opens the verification bottom sheet for a given facility.
  void _openVerificationSheet(PendingFacility facility) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerificationSheet(
        facility: facility,
        onApproved: () {
          setState(() {
            _pendingFacilities.removeWhere((f) => f.id == facility.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facility approved and published ✓'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onRejected: () {
          setState(() {
            _pendingFacilities.removeWhere((f) => f.id == facility.id);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facility submission deleted.'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Facility Verification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadPendingFacilities,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _pendingFacilities.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadPendingFacilities,
                  color: Colors.teal,
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          itemCount: _pendingFacilities.length,
                          itemBuilder: (context, index) {
                            final facility = _pendingFacilities[index];
                            return _PendingFacilityCard(
                              facility: facility,
                              onTap: () => _openVerificationSheet(facility),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.teal.shade50,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pending_actions,
                    size: 16, color: Colors.orange.shade700),
                const SizedBox(width: 6),
                Text(
                  '${_pendingFacilities.length} awaiting review',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tap a card to verify',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline,
              size: 72, color: Colors.teal.shade200),
          const SizedBox(height: 16),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'No facilities are awaiting verification.',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _loadPendingFacilities,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.teal),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PENDING FACILITY CARD
// ─────────────────────────────────────────────────────────────────────────────

class _PendingFacilityCard extends StatelessWidget {
  final PendingFacility facility;
  final VoidCallback onTap;

  const _PendingFacilityCard({
    required this.facility,
    required this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown date';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule,
                            size: 12, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Pending',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(facility.submittedAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                facility.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      facility.type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (facility.district.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Text(
                          facility.district,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                ],
              ),
              if (facility.address.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.map_outlined,
                        size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        facility.address,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                        maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(Icons.edit_location_alt, size: 18),
                      label: const Text('Review & Verify'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VERIFICATION BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _VerificationSheet extends StatefulWidget {
  final PendingFacility facility;
  final VoidCallback onApproved;
  final VoidCallback onRejected;

  const _VerificationSheet({
    required this.facility,
    required this.onApproved,
    required this.onRejected,
  });

  @override
  State<_VerificationSheet> createState() => _VerificationSheetState();
}

class _VerificationSheetState extends State<_VerificationSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  bool _isSubmitting = false;
  bool _isRejecting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.facility.name);
    _phoneController = TextEditingController(text: widget.facility.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _approveFacility() async {
    if (!_formKey.currentState!.validate()) return;

    final double? lat = double.tryParse(_latController.text.trim());
    final double? lng = double.tryParse(_lngController.text.trim());

    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid latitude and longitude values.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Basic range validation
    if (lat < -90 || lat > 90) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Latitude must be between -90 and 90.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (lng < -180 || lng > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Longitude must be between -180 and 180.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance
          .collection('health_facilities')
          .doc(widget.facility.id)
          .update({
        'name': _nameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'location': GeoPoint(lat, lng),
        'latitude': lat,
        'longitude': lng,
        'status': true,
        'verifiedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      widget.onApproved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error approving facility: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isSubmitting = false);
  }

  Future<void> _rejectFacility() async {
    // Show confirmation dialog before deleting
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reject & Delete?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will permanently delete the submission for "${widget.facility.name}". This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isRejecting = true);

    try {
      await FirebaseFirestore.instance
          .collection('health_facilities')
          .doc(widget.facility.id)
          .delete();

      if (mounted) Navigator.pop(context);
      widget.onRejected();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting facility: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isRejecting = false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          const Icon(Icons.verified_user, color: Colors.teal),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Facility',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Review, edit if needed, and approve or reject.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // ── SECTION: Submitted info (read-only display) ──
                _sectionLabel('Submitted Information', Icons.info_outline),
                const SizedBox(height: 10),
                _readOnlyRow(
                    Icons.category_outlined, 'Type', widget.facility.type),
                const SizedBox(height: 8),
                _readOnlyRow(
                    Icons.location_city, 'District', widget.facility.district),
                const SizedBox(height: 8),
                _readOnlyRow(
                    Icons.map_outlined, 'Address', widget.facility.address),
                const SizedBox(height: 8),
                _readOnlyRow(Icons.person_outline, 'Submitted by (UID)',
                    widget.facility.submittedBy),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // ── SECTION: Editable fields ──
                _sectionLabel('Edit Before Approving', Icons.edit_outlined),
                const SizedBox(height: 12),

                // Facility name (editable)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Facility Name',
                    prefixIcon: const Icon(Icons.local_hospital_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 14),

                // Phone number (editable)
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),

                // ── SECTION: GPS Coordinates ──
                _sectionLabel('GPS Coordinates', Icons.my_location),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.amber.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search the facility on Google Maps, long-press the pin to copy coordinates.',
                          style: TextStyle(
                              fontSize: 12, color: Colors.amber.shade900),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    // Latitude
                    Expanded(
                      child: TextFormField(
                        controller: _latController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          hintText: 'e.g. 9.0765',
                          prefixIcon: const Icon(Icons.north, size: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Longitude
                    Expanded(
                      child: TextFormField(
                        controller: _lngController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          hintText: 'e.g. 7.4985',
                          prefixIcon: const Icon(Icons.east, size: 18),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(v.trim()) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── ACTION BUTTONS ──
                Row(
                  children: [
                    // Reject / Delete button
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: (_isSubmitting || _isRejecting)
                            ? null
                            : _rejectFacility,
                        icon: _isRejecting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.red),
                              )
                            : const Icon(Icons.delete_outline, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Approve button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: (_isSubmitting || _isRejecting)
                            ? null
                            : _approveFacility,
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.check_circle_outline, size: 20),
                        label: const Text(
                          'Approve & Publish',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Helpers ──

  Widget _sectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.teal),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _readOnlyRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '—',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
