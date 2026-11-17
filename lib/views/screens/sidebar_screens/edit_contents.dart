import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = '\EditScreen';

  @override
  State<EditScreen> createState() => _EditScreenState();
}

// ─────────────────────────────────────────────
// STATE
// ─────────────────────────────────────────────
class _EditScreenState extends State<EditScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── List / search ──
  List<Map<String, dynamic>> _allContent = [];
  List<Map<String, dynamic>> _filteredContent = [];
  final TextEditingController _searchController = TextEditingController();
  bool _loadingList = true;

  // ── Selected document ──
  Map<String, dynamic>? _selectedDoc;
  bool _editMode = false;

  // ── Form state ──
  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _timeTextControllers = {};
  final Map<String, TextEditingController> _firstParagraphControllers = {};
  final Map<String, TextEditingController> _secParagraphControllers = {};
  final Map<String, TextEditingController> _thirdParagraphControllers = {};

  dynamic _newImageBytes; // bytes of newly picked image (null = no change)
  String? _newFileName;
  String _currentImageUrl = ''; // existing image URL from Firestore

  String _selectedContentType = 'banners';
  String? _selectedEducativeType;
  String? _selectedModule;
  bool _isActive = true;
  int _displayOrder = 1;
  String _currentLanguage = 'en';

  // ── Constants (mirrors UploadScreen) ──
  final List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'sw', 'name': 'Swahili', 'flag': '🇰🇪'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'},
    {'code': 'ny', 'name': 'Chichewa', 'flag': '🇲🇼'},
    {'code': 'kg', 'name': 'Kikongo', 'flag': '🇨🇩'},
    {'code': 'so', 'name': 'Somali', 'flag': '🇸🇴'},
  ];

  final Map<String, Map<String, List<String>>> contentTypes = {
    'banners': {'subtypes': [], 'modules': []},
    'educative': {
      'subtypes': [
        'pregnancy_journey',
        'baby_development',
        'health_tips',
        'nutrition_guide',
      ],
      'modules': ['mothers', 'health_providers'],
    }
  };

  // ─────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _initControllers();
    _fetchAllContent();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _initControllers() {
    for (var lang in supportedLanguages) {
      final code = lang['code']!;
      _titleControllers[code] = TextEditingController();
      _timeTextControllers[code] = TextEditingController();
      _firstParagraphControllers[code] = TextEditingController();
      _secParagraphControllers[code] = TextEditingController();
      _thirdParagraphControllers[code] = TextEditingController();
    }
  }

  void _disposeControllers() {
    for (var c in [
      ..._titleControllers.values,
      ..._timeTextControllers.values,
      ..._firstParagraphControllers.values,
      ..._secParagraphControllers.values,
      ..._thirdParagraphControllers.values,
    ]) {
      c.dispose();
    }
  }

  // ─────────────────────────────────────────────
  // DATA LOADING
  // ─────────────────────────────────────────────
  Future<void> _fetchAllContent() async {
    setState(() => _loadingList = true);
    try {
      final snapshot = await _firestore
          .collection('content')
          .orderBy('createdAt', descending: true)
          .get();

      _allContent =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
      _filteredContent = List.from(_allContent);
    } catch (e) {
      _showSnack('Failed to load content: $e');
    }
    setState(() => _loadingList = false);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredContent = List.from(_allContent);
      } else {
        _filteredContent = _allContent.where((doc) {
          // Search in all language variants of title
          final titleMap = doc['title'];
          if (titleMap is Map) {
            return titleMap.values.any(
              (v) => v.toString().toLowerCase().contains(query),
            );
          }
          return false;
        }).toList();
      }
    });
  }

  // ─────────────────────────────────────────────
  // SELECT DOCUMENT → populate form
  // ─────────────────────────────────────────────
  void _selectDocument(Map<String, dynamic> doc) {
    setState(() {
      _selectedDoc = doc;
      _editMode = true;
      _newImageBytes = null;
      _newFileName = null;
      _currentLanguage = 'en';

      _selectedContentType = doc['type'] ?? 'banners';
      _selectedEducativeType = doc['subType'];
      _selectedModule = doc['module'];
      _isActive = doc['isActive'] ?? true;
      _displayOrder = doc['displayOrder'] ?? 1;
      _currentImageUrl = doc['imageUrl'] ?? '';

      // Populate multilingual controllers
      _populateControllers(_titleControllers, doc['title']);
      _populateControllers(_timeTextControllers, doc['timeText']);
      _populateControllers(_firstParagraphControllers, doc['firstParagraph']);
      _populateControllers(_secParagraphControllers, doc['secParagraph']);
      _populateControllers(_thirdParagraphControllers, doc['thirdParagraph']);
    });
  }

  void _populateControllers(
    Map<String, TextEditingController> controllers,
    dynamic rawMap,
  ) {
    // Clear first
    for (var c in controllers.values) c.clear();

    if (rawMap is Map) {
      for (var lang in supportedLanguages) {
        final code = lang['code']!;
        final value = rawMap[code]?.toString() ?? '';
        controllers[code]?.text = value;
      }
    }
  }

  // ─────────────────────────────────────────────
  // IMAGE PICK
  // ─────────────────────────────────────────────
  Future<void> _pickImage() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      setState(() {
        _newImageBytes = result.files.first.bytes;
        _newFileName = result.files.first.name;
      });
    }
  }

  // ─────────────────────────────────────────────
  // SAVE CHANGES
  // ─────────────────────────────────────────────
  Future<void> _saveChanges() async {
    if (_selectedDoc == null) return;

    // Validation
    if (_titleControllers['en']!.text.trim().isEmpty) {
      _showSnack('Please enter at least an English title');
      return;
    }
    if (_selectedContentType == 'educative') {
      if (_selectedEducativeType == null) {
        _showSnack('Please select a content category');
        return;
      }
      if (_selectedModule == null) {
        _showSnack('Please select a module');
        return;
      }
      if (_firstParagraphControllers['en']!.text.trim().isEmpty) {
        _showSnack('Please enter at least an English first paragraph');
        return;
      }
    }

    EasyLoading.show(status: 'Saving...');
    try {
      final docId = _selectedDoc!['id'] as String;
      String imageUrl = _currentImageUrl;

      // ── Replace image if a new one was picked ──
      if (_newImageBytes != null && _newFileName != null) {
        // Delete old image
        if (_currentImageUrl.isNotEmpty) {
          try {
            await _storage.refFromURL(_currentImageUrl).delete();
          } catch (_) {
            // Old image might not exist; continue
          }
        }

        // Upload new image
        final storagePath = _getStoragePath();
        final ext = _newFileName!.split('.').last;
        final ref = _storage.ref().child(storagePath).child('$docId.$ext');
        final task = await ref.putData(_newImageBytes);
        imageUrl = await task.ref.getDownloadURL();
      }

      // ── Build update map ──
      final Map<String, dynamic> data = {
        'type': _selectedContentType,
        'title': _getTranslations(_titleControllers),
        'imageUrl': imageUrl,
        'isActive': _isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (_selectedContentType == 'banners') {
        data['displayOrder'] = _displayOrder;
      } else if (_selectedContentType == 'educative') {
        data.addAll({
          'subType': _selectedEducativeType,
          'module': _selectedModule,
          'timeText': _getTranslations(_timeTextControllers),
          'firstParagraph': _getTranslations(_firstParagraphControllers),
          'secParagraph': _getTranslations(_secParagraphControllers),
          'thirdParagraph': _getTranslations(_thirdParagraphControllers),
          'displayOrder': _displayOrder,
        });
      }

      await _firestore.collection('content').doc(docId).update(data);

      EasyLoading.showSuccess('Saved successfully!');

      // Refresh the list and go back to browse
      await _fetchAllContent();
      setState(() {
        _editMode = false;
        _selectedDoc = null;
      });
    } catch (e) {
      EasyLoading.showError('Save failed: $e');
    }
  }

  // ─────────────────────────────────────────────
  // DELETE DOCUMENT
  // ─────────────────────────────────────────────
  Future<void> _deleteContent() async {
    if (_selectedDoc == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Content'),
        content: Text(
            'This will permanently delete the content and its image. Continue?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed != true) return;

    EasyLoading.show(status: 'Deleting...');
    try {
      final docId = _selectedDoc!['id'] as String;

      // Delete image from Storage
      if (_currentImageUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(_currentImageUrl).delete();
        } catch (_) {}
      }

      // Delete Firestore document
      await _firestore.collection('content').doc(docId).delete();

      EasyLoading.showSuccess('Deleted!');
      await _fetchAllContent();
      setState(() {
        _editMode = false;
        _selectedDoc = null;
      });
    } catch (e) {
      EasyLoading.showError('Delete failed: $e');
    }
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  String _getStoragePath() {
    if (_selectedContentType == 'banners') return 'content/banners';
    if (_selectedContentType == 'educative') {
      return 'content/educative/$_selectedModule/$_selectedEducativeType';
    }
    return 'content/general';
  }

  Map<String, String> _getTranslations(
      Map<String, TextEditingController> controllers) {
    final Map<String, String> out = {};
    for (var entry in controllers.entries) {
      final text = entry.value.text.trim();
      if (text.isNotEmpty) out[entry.key] = text;
    }
    return out;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _getDisplayTitle(Map<String, dynamic> doc) {
    final titleMap = doc['title'];
    if (titleMap is Map) {
      return titleMap['en']?.toString() ??
          titleMap.values.firstOrNull?.toString() ??
          'Untitled';
    }
    return 'Untitled';
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return _editMode ? _buildEditForm() : _buildBrowseScreen();
  }

  // ══════════════════════════════════════════════
  // BROWSE SCREEN
  // ══════════════════════════════════════════════
  Widget _buildBrowseScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Content',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
              Divider(color: Colors.grey),
              SizedBox(height: 8),

              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by title…',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_filteredContent.length} item(s)',
                    style: TextStyle(color: Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    onPressed: _fetchAllContent,
                  ),
                ],
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: _loadingList
              ? Center(child: CircularProgressIndicator())
              : _filteredContent.isEmpty
                  ? Center(child: Text('No content found'))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredContent.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final doc = _filteredContent[index];
                        final imageUrl = doc['imageUrl']?.toString() ?? '';
                        final type = doc['type']?.toString() ?? '';
                        final isActive = doc['isActive'] ?? true;

                        return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _imagePlaceholder(),
                                  )
                                : _imagePlaceholder(),
                          ),
                          title: Text(
                            _getDisplayTitle(doc),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(
                            children: [
                              _typeChip(type),
                              SizedBox(width: 6),
                              _statusChip(isActive),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () => _selectDocument(doc),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() => Container(
        width: 56,
        height: 56,
        color: Colors.grey.shade200,
        child: Icon(Icons.image, color: Colors.grey),
      );

  Widget _typeChip(String type) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: type == 'banners'
              ? Colors.blue.withOpacity(0.1)
              : Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: type == 'banners' ? Colors.blue : Colors.purple,
          ),
        ),
      );

  Widget _statusChip(bool active) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: active
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          active ? 'ACTIVE' : 'INACTIVE',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: active ? Colors.green : Colors.red,
          ),
        ),
      );

  // ══════════════════════════════════════════════
  // EDIT FORM
  // ══════════════════════════════════════════════
  Widget _buildEditForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => setState(() {
                    _editMode = false;
                    _selectedDoc = null;
                  }),
                  tooltip: 'Back to list',
                ),
                Expanded(
                  child: Text(
                    'Edit Content',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                ),
                // Delete button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: _deleteContent,
                ),
              ],
            ),
            Divider(color: Colors.grey),

            // ── Content Configuration ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Content Configuration',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: _dropdownField(
                          label: 'Content Type',
                          value: _selectedContentType,
                          items: contentTypes.keys.toList(),
                          onChanged: (v) => setState(() {
                            _selectedContentType = v!;
                            _selectedEducativeType = null;
                            _selectedModule = null;
                          }),
                          displayName: (v) => v.toUpperCase(),
                        )),
                        if (_selectedContentType == 'educative') ...[
                          SizedBox(width: 16),
                          Expanded(
                              child: _dropdownField(
                            label: 'Content Category',
                            value: _selectedEducativeType,
                            items: contentTypes['educative']!['subtypes']!,
                            onChanged: (v) =>
                                setState(() => _selectedEducativeType = v),
                            hint: 'Select category',
                            displayName: (v) =>
                                v.replaceAll('_', ' ').toUpperCase(),
                          )),
                        ],
                      ],
                    ),
                    if (_selectedContentType == 'educative') ...[
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                              child: _dropdownField(
                            label: 'Module',
                            value: _selectedModule,
                            items: contentTypes['educative']!['modules']!,
                            onChanged: (v) =>
                                setState(() => _selectedModule = v),
                            hint: 'Select module',
                            displayName: (v) =>
                                v.replaceAll('_', ' ').toUpperCase(),
                          )),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Display Order',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: TextEditingController(
                                      text: _displayOrder.toString()),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (v) =>
                                      _displayOrder = int.tryParse(v) ?? 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _isActive,
                            onChanged: (v) =>
                                setState(() => _isActive = v ?? true),
                          ),
                          Text('Active'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // ── Language tabs ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Language for Translation',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    SizedBox(height: 12),
                    _buildLanguageTabs(),
                    SizedBox(height: 16),
                    _buildTranslationStatus(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // ── Multilingual text fields ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Content Details - ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          supportedLanguages.firstWhere(
                              (l) => l['code'] == _currentLanguage)['name']!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                        SizedBox(width: 6),
                        Text(
                          supportedLanguages.firstWhere(
                              (l) => l['code'] == _currentLanguage)['flag']!,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _titleControllers[_currentLanguage],
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_selectedContentType == 'educative') ...[
                      SizedBox(height: 16),
                      TextField(
                        controller: _timeTextControllers[_currentLanguage],
                        decoration: InputDecoration(
                          labelText: 'Time Period (e.g., WEEK 1-3)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller:
                            _firstParagraphControllers[_currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'First Paragraph *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _secParagraphControllers[_currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Second Paragraph',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller:
                            _thirdParagraphControllers[_currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Third Paragraph',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // ── Image section ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Image',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    if (_newImageBytes == null && _currentImageUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(
                          'Current image shown below. Pick a new one to replace it.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        // Preview
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.grey.shade200,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _newImageBytes != null
                                ? Image.memory(_newImageBytes,
                                    fit: BoxFit.cover)
                                : _currentImageUrl.isNotEmpty
                                    ? Image.network(_currentImageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                            Icons.broken_image,
                                            color: Colors.grey))
                                    : Icon(Icons.image,
                                        size: 50, color: Colors.grey),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_newFileName != null) ...[
                                Text('New: $_newFileName',
                                    style: TextStyle(fontSize: 12)),
                                SizedBox(height: 8),
                              ],
                              ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: Icon(Icons.upload_file),
                                label: Text('Replace Image'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 45),
                                ),
                              ),
                              if (_newImageBytes != null) ...[
                                SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () => setState(() {
                                    _newImageBytes = null;
                                    _newFileName = null;
                                  }),
                                  icon: Icon(Icons.clear),
                                  label: Text('Cancel replacement'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // ── Action buttons ──
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _editMode = false;
                      _selectedDoc = null;
                    }),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SHARED WIDGETS
  // ─────────────────────────────────────────────
  Widget _buildLanguageTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: supportedLanguages.map((lang) {
          final isSelected = _currentLanguage == lang['code'];
          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang['flag']!, style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text(lang['name']!, style: TextStyle(fontSize: 13)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _currentLanguage = lang['code']!);
                }
              },
              selectedColor: Colors.blue.withOpacity(0.3),
              backgroundColor: Colors.grey.withOpacity(0.1),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTranslationStatus() {
    int completed = 0;
    for (var lang in supportedLanguages) {
      if (_titleControllers[lang['code']!]!.text.trim().isNotEmpty) {
        completed++;
      }
    }
    final allDone = completed == supportedLanguages.length;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: allDone
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: allDone ? Colors.green : Colors.orange),
      ),
      child: Row(
        children: [
          Icon(
            allDone ? Icons.check_circle : Icons.info_outline,
            color: allDone ? Colors.green : Colors.orange,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Translation Progress: $completed/${supportedLanguages.length} languages',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? hint,
    required String Function(String) displayName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: SizedBox(),
            hint: hint != null ? Text(hint) : null,
            onChanged: onChanged,
            items: items
                .map((v) => DropdownMenuItem(
                      value: v,
                      child: Text(displayName(v)),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
