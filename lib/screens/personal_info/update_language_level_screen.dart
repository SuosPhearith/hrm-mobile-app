import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';

import 'package:mobile_app/providers/local/personalinfo/update_language_provider.dart';
import 'package:mobile_app/services/personal_info/create_personalinfo_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class UpdateLanguageLevelScreen extends StatefulWidget {
  const UpdateLanguageLevelScreen({super.key, this.id, required this.userLanguageId});
  final String? id;
  final String userLanguageId;
  @override
  State<UpdateLanguageLevelScreen> createState() => _UpdateLanguageLevelScreenState();
}

class _UpdateLanguageLevelScreenState extends State<UpdateLanguageLevelScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  
  // Add this missing variable
  bool _isDataLoaded = false;
  
  Future<void> _refreshData(UpdateLanguageProvider provider) async {
    return await provider.getHome();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _langauge = TextEditingController();
  final TextEditingController _speakingLevel = TextEditingController();
  final TextEditingController _readingLevel = TextEditingController();
  final TextEditingController _writtingLevel = TextEditingController();
  final TextEditingController _listeningLevel = TextEditingController();

  final CreatePersonalService _service = CreatePersonalService();
  // Variables to store selected IDs
  String? selectedLanguageId;
  String? selectedSpeakingLevelId;
  String? selectedReadingLevelId;
  String? selectedWritingLevelId;
  String? selectedListeningLevelId;

  @override
  void dispose() {
    _langauge.dispose();
    _speakingLevel.dispose();
    _readingLevel.dispose();
    _writtingLevel.dispose();
    _listeningLevel.dispose();
    super.dispose();
  }

  void _clearAllControllers() {
    _langauge.clear();
    _speakingLevel.clear();
    _readingLevel.clear();
    _writtingLevel.clear();
    _listeningLevel.clear();

    // Also clear any selected IDs if needed
    setState(() {
      selectedLanguageId = null;
      selectedSpeakingLevelId = null;
      selectedReadingLevelId = null;
      selectedWritingLevelId = null;
      selectedListeningLevelId = null;
    });
  }

  // Corrected method to load existing language data
  void _loadExistingData(UpdateLanguageProvider provider, SettingProvider settingProvider) {
    if (_isDataLoaded || provider.data == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final languageData = provider.data?.data;
      if (languageData == null) return;

      setState(() {
        final currentLang = settingProvider.lang ?? 'kh';
        
        // Set language field
        _langauge.text = currentLang == 'kh' 
            ? (languageData['language']?['name_kh'] ?? languageData['language']?['name_en'] ?? '')
            : (languageData['language']?['name_en'] ?? languageData['language']?['name_kh'] ?? '');
        
        // Set speaking level
        _speakingLevel.text = currentLang == 'kh'
            ? (languageData['speaking_level']?['name_kh'] ?? languageData['speaking_level']?['name_en'] ?? '')
            : (languageData['speaking_level']?['name_en'] ?? languageData['speaking_level']?['name_kh'] ?? '');
            
        // Set reading level
        _readingLevel.text = currentLang == 'kh'
            ? (languageData['reading_level']?['name_kh'] ?? languageData['reading_level']?['name_en'] ?? '')
            : (languageData['reading_level']?['name_en'] ?? languageData['reading_level']?['name_kh'] ?? '');
            
        // Set writing level
        _writtingLevel.text = currentLang == 'kh'
            ? (languageData['writing_level']?['name_kh'] ?? languageData['writing_level']?['name_en'] ?? '')
            : (languageData['writing_level']?['name_en'] ?? languageData['writing_level']?['name_kh'] ?? '');
            
        // Set listening level
        _listeningLevel.text = currentLang == 'kh'
            ? (languageData['listening_level']?['name_kh'] ?? languageData['listening_level']?['name_en'] ?? '')
            : (languageData['listening_level']?['name_en'] ?? languageData['listening_level']?['name_kh'] ?? '');

        // Set selected IDs
        selectedLanguageId = languageData['language_id']?.toString();
        selectedSpeakingLevelId = languageData['speaking_level_id']?.toString();
        selectedReadingLevelId = languageData['reading_level_id']?.toString();
        selectedWritingLevelId = languageData['writing_level_id']?.toString();
        selectedListeningLevelId = languageData['listening_level_id']?.toString();

        _isDataLoaded = true;
      });
    });
  }

  void _handleSubmit() async {
    // if (!_formKey.currentState!.validate()) return;

    // // Validate required fields
    // if (selectedLanguageId == null ||
    //     selectedSpeakingLevelId == null ||
    //     selectedReadingLevelId == null ||
    //     selectedWritingLevelId == null ||
    //     selectedListeningLevelId == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('សូមបំពេញព័ត៌មានចាំបាច់')),
    //   );
    //   return;
    // }

    showConfirmDialogWithNavigation(
        context,
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'update'), // 'update'
        AppLang.translate(
            lang: Provider.of<SettingProvider>(context, listen: false).lang ??
                'kh',
            key: 'Are you sure to update'), // 'update'
        DialogType.primary, () async {
      try {
        await _service.updateUserLanguage(
          userId: widget.id ?? '',
          userLanguageId: widget.userLanguageId,
          languageId: selectedLanguageId!,
          speakingLevelId: selectedSpeakingLevelId!,
          writingLevelId: selectedWritingLevelId!,
          listeningLevelId: selectedListeningLevelId!,
          readingLevelId: selectedReadingLevelId!,
        );
        _clearAllControllers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ការកែប្រែត្រូវបានរក្សាទុកដោយជោគជ័យ')), // Changed message
          );
          context.pop();
        }
      } catch (e) {
        if (e is DioException) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(parseErrorResponse(e.response?.data)['message']
                      ?['name_kh'])),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UpdateLanguageProvider(userId: widget.id!, languageId:widget.userLanguageId), // Load existing data
        child: Consumer2<UpdateLanguageProvider, SettingProvider>(
            builder: (context, provider, settingProvider, child) {
          
          // Load existing data when provider data is available
          _loadExistingData(provider, settingProvider);
          
          final languages = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'languages',
              settingProvider: settingProvider);
          final proficiencyLevels = _buildEducationSelectionMap(
              apiData: provider.dataSetup,
              dataKey: 'language_levels',
              settingProvider: settingProvider);
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                  AppLang.translate(lang: settingProvider.lang?? 'kh', key: 'user_info_language_update')), 
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(provider),
              child: provider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Language Selection
                              _buildSelectionField(
                                controller: _langauge,
                                label:
                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'user_info_language')} *',
                                items: languages,
                                selectedId:
                                    selectedLanguageId, // Pass current selection
                                onSelected: (id, value) {
                                  setState(() {
                                    selectedLanguageId = id;
                                    _langauge.text = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              // Speaking and Reading Levels
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSelectionField(
                                      controller: _speakingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'speaking level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedSpeakingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedSpeakingLevelId = id;
                                          _speakingLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildSelectionField(
                                      controller: _readingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'reading level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedReadingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedReadingLevelId = id;
                                          _readingLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Writing and Listening Levels
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSelectionField(
                                      controller: _writtingLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'writting level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedWritingLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedWritingLevelId = id;
                                          _writtingLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildSelectionField(
                                      controller: _listeningLevel,
                                      label:
                                          '${AppLang.translate(lang: settingProvider.lang ?? 'kh', key: 'listenning level')} *',
                                      items: proficiencyLevels,
                                      selectedId:
                                          selectedListeningLevelId, // Pass current selection
                                      onSelected: (id, value) {
                                        setState(() {
                                          selectedListeningLevelId = id;
                                          _listeningLevel.text = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    _handleSubmit();
                  },
                  child: Text(
                    AppLang.translate(
                        lang: settingProvider.lang ?? 'kh', key: 'update'), // Changed from 'create'
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Map<String, String> _buildEducationSelectionMap({
    required dynamic apiData,
    required String dataKey,
    required SettingProvider settingProvider,
  }) {
    final dataSetUp = apiData?.data[dataKey];

    if (dataSetUp == null || dataSetUp is! List) {
      return {};
    }

    Map<String, String> result = {};

    for (var item in dataSetUp) {
      if (item is Map<String, dynamic>) {
        final id = item['id']?.toString();
        final currentLang = settingProvider.lang ?? 'kh';
        final name = currentLang == 'kh'
            ? (item['name_kh']?.toString() ?? item['name_en']?.toString() ?? '')
            : (item['name_en']?.toString() ??
                item['name_kh']?.toString() ??
                '');

        if (id != null && name.isNotEmpty) {
          result[id] = name;
        }
      }
    }

    return result;
  }

  // Reusable Selection Field widget
  Widget _buildSelectionField({
    required TextEditingController controller,
    required String label,
    required Map<String, String> items,
    required void Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        await _showSelectionBottomSheet(
          context: context,
          title: label,
          items: items,
          onSelected: onSelected,
          selectedId: selectedId, // Pass current selection
        );
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1.0),
        ),
        suffixIcon: Icon(Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary),
        filled: true,
      ),
    );
  }

  Future<void> _showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required Map<String, String> items,
    required Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
  }) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final entry = items.entries.elementAt(index);
                    final isSelected = selectedId == entry.key;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onSelected(entry.key, entry.value);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24.0,
                                  )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}