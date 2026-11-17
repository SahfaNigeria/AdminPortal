import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadScreen extends StatefulWidget {
  static const String routeName = '\UploadScreen';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Language-specific controllers for each field
  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _timeTextControllers = {};
  final Map<String, TextEditingController> _firstParagraphControllers = {};
  final Map<String, TextEditingController> _secParagraphControllers = {};
  final Map<String, TextEditingController> _thirdParagraphControllers = {};

  dynamic _images;
  String? fileName;

  // Content type selection
  String selectedContentType = 'banners';
  String? selectedEducativeType;
  String? selectedModule;
  bool isActive = true;
  int displayOrder = 1;

  // Current language being edited
  String currentLanguage = 'en';

  // Supported languages
  final List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'code': 'sw', 'name': 'Swahili', 'flag': '🇰🇪'},
    {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'},
    {'code': 'ny', 'name': 'Chichewa', 'flag': '🇲🇼'},
    {'code': 'kg', 'name': 'Kikongo', 'flag': '🇨🇩'},
    {'code': 'so', 'name': 'Somali', 'flag': '🇸🇴'},
  ];

  // Define your content types based on your app structure
  final Map<String, Map<String, List<String>>> contentTypes = {
    'banners': {'subtypes': [], 'modules': []},
    'educative': {
      'subtypes': [
        'pregnancy_journey',
        'baby_development',
        'health_tips',
        'nutrition_guide'
      ],
      'modules': ['mothers', 'health_providers']
    }
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var lang in supportedLanguages) {
      String code = lang['code']!;
      _titleControllers[code] = TextEditingController();
      _timeTextControllers[code] = TextEditingController();
      _firstParagraphControllers[code] = TextEditingController();
      _secParagraphControllers[code] = TextEditingController();
      _thirdParagraphControllers[code] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _titleControllers.values) {
      controller.dispose();
    }
    for (var controller in _timeTextControllers.values) {
      controller.dispose();
    }
    for (var controller in _firstParagraphControllers.values) {
      controller.dispose();
    }
    for (var controller in _secParagraphControllers.values) {
      controller.dispose();
    }
    for (var controller in _thirdParagraphControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _images = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  String _generateContentId() {
    return _firestore.collection('content').doc().id;
  }

  String _getStoragePath() {
    if (selectedContentType == 'banners') {
      return 'content/banners';
    } else if (selectedContentType == 'educative') {
      return 'content/educative/$selectedModule/$selectedEducativeType';
    }
    return 'content/general';
  }

  uploadContentToFirebaseStorage(dynamic image, String contentId) async {
    String storagePath = _getStoragePath();
    String fileExtension = fileName!.split('.').last;
    Reference ref =
        _storage.ref().child(storagePath).child('$contentId.$fileExtension');

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapShot = await uploadTask;

    String downloadUrl = await snapShot.ref.getDownloadURL();
    return downloadUrl;
  }

  Map<String, String> _getTranslationsFromControllers(
      Map<String, TextEditingController> controllers) {
    Map<String, String> translations = {};
    for (var entry in controllers.entries) {
      String text = entry.value.text.trim();
      if (text.isNotEmpty) {
        translations[entry.key] = text;
      }
    }
    return translations;
  }

  uploadToFireStore() async {
    // Validation
    if (_images == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    // Check if at least English translation is provided for title
    if (_titleControllers['en']!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter at least English title')),
      );
      return;
    }

    if (selectedContentType == 'educative') {
      if (selectedEducativeType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an educative type')),
        );
        return;
      }

      if (selectedModule == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a module')),
        );
        return;
      }

      if (_firstParagraphControllers['en']!.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please enter at least English first paragraph')),
        );
        return;
      }
    }

    EasyLoading.show(status: 'Uploading...');

    try {
      // Generate unique content ID
      String contentId = _generateContentId();

      // Upload image to Firebase Storage
      String imageUrl =
          await uploadContentToFirebaseStorage(_images, contentId);

      // Prepare document data with multilingual support
      Map<String, dynamic> data = {
        'type': selectedContentType,
        'title': _getTranslationsFromControllers(_titleControllers),
        'imageUrl': imageUrl,
        'isActive': isActive,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add content-specific fields
      if (selectedContentType == 'banners') {
        data['displayOrder'] = displayOrder;
      } else if (selectedContentType == 'educative') {
        data.addAll({
          'subType': selectedEducativeType,
          'module': selectedModule,
          'timeText': _getTranslationsFromControllers(_timeTextControllers),
          'firstParagraph':
              _getTranslationsFromControllers(_firstParagraphControllers),
          'secParagraph':
              _getTranslationsFromControllers(_secParagraphControllers),
          'thirdParagraph':
              _getTranslationsFromControllers(_thirdParagraphControllers),
          'displayOrder': displayOrder,
        });
      }

      // Save to Firestore
      await _firestore.collection('content').doc(contentId).set(data);

      EasyLoading.showSuccess('Content uploaded successfully!');

      // Clear form
      _clearForm();
    } catch (e) {
      EasyLoading.showError('Upload failed: ${e.toString()}');
    }
  }

  void _clearForm() {
    setState(() {
      _images = null;
      fileName = null;
      selectedContentType = 'banners';
      selectedEducativeType = null;
      selectedModule = null;
      isActive = true;
      displayOrder = 1;
      currentLanguage = 'en';
    });

    for (var controller in _titleControllers.values) {
      controller.clear();
    }
    for (var controller in _timeTextControllers.values) {
      controller.clear();
    }
    for (var controller in _firstParagraphControllers.values) {
      controller.clear();
    }
    for (var controller in _secParagraphControllers.values) {
      controller.clear();
    }
    for (var controller in _thirdParagraphControllers.values) {
      controller.clear();
    }
  }

  Widget _buildLanguageTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: supportedLanguages.map((lang) {
          final isSelected = currentLanguage == lang['code'];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lang['flag']!,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 6),
                  Text(
                    lang['name']!,
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    currentLanguage = lang['code']!;
                  });
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
    int completedLanguages = 0;
    for (var lang in supportedLanguages) {
      String code = lang['code']!;
      if (_titleControllers[code]!.text.trim().isNotEmpty) {
        completedLanguages++;
      }
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completedLanguages == supportedLanguages.length
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: completedLanguages == supportedLanguages.length
              ? Colors.green
              : Colors.orange,
        ),
      ),
      child: Row(
        children: [
          Icon(
            completedLanguages == supportedLanguages.length
                ? Icons.check_circle
                : Icons.info_outline,
            color: completedLanguages == supportedLanguages.length
                ? Colors.green
                : Colors.orange,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Translation Progress: $completedLanguages/${supportedLanguages.length} languages',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Upload Multilingual Content',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ),
            ),
            Divider(color: Colors.grey),

            // Content Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Configuration',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 16),

                    // Content Type Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Content Type:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedContentType,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedContentType = newValue!;
                                      selectedEducativeType = null;
                                      selectedModule = null;
                                    });
                                  },
                                  items: contentTypes.keys
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toUpperCase()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Show educative subtypes if educative is selected
                        if (selectedContentType == 'educative') ...[
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Content Category:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedEducativeType,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    hint: Text('Select category'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedEducativeType = newValue;
                                      });
                                    },
                                    items:
                                        contentTypes['educative']!['subtypes']!
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value
                                            .replaceAll('_', ' ')
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Module selection for educative content
                    if (selectedContentType == 'educative') ...[
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Module:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButton<String>(
                                    value: selectedModule,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    hint: Text('Select module'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedModule = newValue;
                                      });
                                    },
                                    items:
                                        contentTypes['educative']!['modules']!
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value
                                            .replaceAll('_', ' ')
                                            .toUpperCase()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Display Order:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(height: 8),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: '1',
                                  ),
                                  onChanged: (value) {
                                    displayOrder = int.tryParse(value) ?? 1;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: isActive,
                            onChanged: (bool? value) {
                              setState(() {
                                isActive = value ?? true;
                              });
                            },
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

            // Language Selection and Translation Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Language for Translation',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 12),
                    _buildLanguageTabs(),
                    SizedBox(height: 16),
                    _buildTranslationStatus(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Content Details Form (Language-specific)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Content Details - ',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Text(
                          supportedLanguages.firstWhere((lang) =>
                              lang['code'] == currentLanguage)['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          supportedLanguages.firstWhere((lang) =>
                              lang['code'] == currentLanguage)['flag']!,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Title field
                    TextField(
                      controller: _titleControllers[currentLanguage],
                      decoration: InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                        hintText: 'Enter content title in $currentLanguage',
                      ),
                    ),

                    // Time text field (for educative content)
                    if (selectedContentType == 'educative') ...[
                      SizedBox(height: 16),
                      TextField(
                        controller: _timeTextControllers[currentLanguage],
                        decoration: InputDecoration(
                          labelText: 'Time Period (e.g., WEEK 1-3)',
                          border: OutlineInputBorder(),
                          hintText: 'Enter time period',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _firstParagraphControllers[currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'First Paragraph *',
                          border: OutlineInputBorder(),
                          hintText: 'Enter first paragraph content',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _secParagraphControllers[currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Second Paragraph',
                          border: OutlineInputBorder(),
                          hintText: 'Enter second paragraph content',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _thirdParagraphControllers[currentLanguage],
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Third Paragraph',
                          border: OutlineInputBorder(),
                          hintText: 'Enter third paragraph content',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Image Upload Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Upload',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        // Image preview
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade700),
                            color: Colors.grey.shade200,
                          ),
                          child: _images != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    _images,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        size: 50, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text(
                                      'No image selected',
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                        ),

                        SizedBox(width: 20),

                        // Upload controls
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (fileName != null) ...[
                                Text('Selected: $fileName'),
                                SizedBox(height: 8),
                              ],
                              ElevatedButton.icon(
                                onPressed: pickImage,
                                icon: Icon(Icons.upload_file),
                                label: Text('Select Image'),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 45),
                                ),
                              ),
                              if (_images != null) ...[
                                SizedBox(height: 8),
                                TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _images = null;
                                      fileName = null;
                                    });
                                  },
                                  icon: Icon(Icons.clear),
                                  label: Text('Clear Image'),
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

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: uploadToFireStore,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Upload Content'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearForm,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Clear Form'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Helper class for content management tailored to your app structure
class ContentManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get banners
  Future<List<Map<String, dynamic>>> getBanners() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('content')
          .where('type', isEqualTo: 'banners')
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder')
          .get();

      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print('Error fetching banners: $e');
      return [];
    }
  }

  // Get content by module and subtype with language support
  Future<List<Map<String, dynamic>>> getContentByModuleAndType(
      String module, String subType, String languageCode) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('content')
          .where('type', isEqualTo: 'educative')
          .where('module', isEqualTo: module)
          .where('subType', isEqualTo: subType)
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder')
          .get();

      // Process documents to extract language-specific content
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Extract translated fields based on language code
        Map<String, dynamic> processedData = {
          'id': doc.id,
          'type': data['type'],
          'subType': data['subType'],
          'module': data['module'],
          'imageUrl': data['imageUrl'],
          'displayOrder': data['displayOrder'],
          'isActive': data['isActive'],
        };

        // Extract language-specific content, fallback to English if not available
        if (data['title'] is Map) {
          processedData['title'] =
              data['title'][languageCode] ?? data['title']['en'] ?? '';
        }

        if (data['timeText'] is Map) {
          processedData['timeText'] =
              data['timeText'][languageCode] ?? data['timeText']['en'] ?? '';
        }

        if (data['firstParagraph'] is Map) {
          processedData['firstParagraph'] = data['firstParagraph']
                  [languageCode] ??
              data['firstParagraph']['en'] ??
              '';
        }

        if (data['secParagraph'] is Map) {
          processedData['secParagraph'] = data['secParagraph'][languageCode] ??
              data['secParagraph']['en'] ??
              '';
        }

        if (data['thirdParagraph'] is Map) {
          processedData['thirdParagraph'] = data['thirdParagraph']
                  [languageCode] ??
              data['thirdParagraph']['en'] ??
              '';
        }

        return processedData;
      }).toList();
    } catch (e) {
      print('Error fetching content: $e');
      return [];
    }
  }

  // Update content status
  Future<void> updateContentStatus(String contentId, bool isActive) async {
    try {
      await _firestore.collection('content').doc(contentId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating content status: $e');
      throw e;
    }
  }

  // Delete content
  Future<void> deleteContent(String contentId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('content').doc(contentId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'] ?? '';

        // Delete the image from storage
        if (imageUrl.isNotEmpty) {
          Reference ref = _storage.refFromURL(imageUrl);
          await ref.delete();
        }

        // Delete the document
        await _firestore.collection('content').doc(contentId).delete();
      }
    } catch (e) {
      print('Error deleting content: $e');
      throw e;
    }
  }
}
