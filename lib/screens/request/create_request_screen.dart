import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request/create_request_provider.dart';
import 'package:mobile_app/services/request/create_request_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/helper.dart';
import 'package:provider/provider.dart';

class CreateRequestScreen extends StatefulWidget {
  final String? id;
  const CreateRequestScreen({super.key, this.id});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(CreateRequestProvider provider) async {
    return await provider.getHome();
  }

  // Variables to store form field values
  int? _selectedTypeId;
  String? _selectedTypeNameKh;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _description;

  File? _image; // Store the selected image
  final ImagePicker _picker = ImagePicker();
  String? _imageBase64;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      // First create the File from the picked image
      final File imageFile = File(pickedFile.path);

      // Then read the bytes
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _image = imageFile;
        _imageBase64 = base64Image;
      });
    }
  }

  // Controller for description field
  final TextEditingController _descriptionController = TextEditingController();
  final CreateRequestService _createRequestService = CreateRequestService();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to validate and submit
  void _validateAndSubmit() async {
    if (_selectedTypeId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('សូមជ្រើសរើសប្រភេទច្បាប់')),
        );
      }
      return;
    }
    if (_startDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('សូមជ្រើសរើសកាលបរិច្ឆេទចាប់ផ្តើម')),
        );
      }
      return;
    }
    if (_description == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('សូមបញ្ចូលមូលហេតុ')));
      }
      return;
    }
    if (_endDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('សូមជ្រើសរើសកាលបរិច្ឆេទបញ្ចប់')),
        );
      }
      return;
    }
    if (_imageBase64 == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('សូមជ្រើសរើសរូប')));
      }
      return;
    }

    try {
      await _createRequestService.createRequest(
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
        objective:
            _description?.trim().isNotEmpty == true ? _description! : null,
        requestTypeId: _selectedTypeId!,
        requestCategoryId: int.parse(widget.id!),
        attachment: _imageBase64!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('មានបញ្ហាក្នុងការបញ្ជូនសំណើ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRequestProvider(),
      child: Consumer2<CreateRequestProvider, SettingProvider>(
        builder: (context, createRequestProvider, settingProvider, child) {
          final List<dynamic>? requestCategories =
              createRequestProvider.data?.data['request_categories']
                  as List<dynamic>?;

          Map<String, dynamic>? data;
          if (requestCategories != null) {
            try {
              data =
                  requestCategories.firstWhere(
                        (item) => item['id'] == int.parse(widget.id!),
                        orElse: () => <String, dynamic>{},
                      )
                      as Map<String, dynamic>;

              // If we got an empty map from orElse, set data to null
              if (data.isEmpty) {
                data = null;
              }
            } catch (e) {
              data = null;
            }
          }
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('ស្នើសុំច្បាប់'),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () {
                    showConfirmDialog(
                      context,
                      'Confirm Create',
                      'Are you sure to create request?',
                      DialogType.primary,
                      () {
                        _validateAndSubmit();
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 28.0,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      color: Colors.blue[800],
                      backgroundColor: Colors.white,
                      onRefresh: () => _refreshData(createRequestProvider),
                      child:
                          createRequestProvider.isLoading
                              ? const Center(child: Text('Loading...'))
                              : SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children:
                                            (data!['request_types'] as List).map((
                                              record,
                                            ) {
                                              return Container(
                                                margin: EdgeInsets.zero,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                    33,
                                                    150,
                                                    243,
                                                    0.1,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(16),
                                                      ),
                                                ),
                                                child: Text(
                                                  '${getSafeString(value: AppLang.translate(data: record, lang: settingProvider.lang ?? 'kh'))} ${getSafeInteger(value: record['max_per_year'])}',
                                                  style: TextStyle(
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                      const SizedBox(height: 16),
                                      MyDropdown(
                                        items:
                                            (data['request_types'] as List)
                                                .map(
                                                  (item) =>
                                                      item
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >,
                                                )
                                                .toList(),
                                        label: 'ប្រភេទច្បាប់',
                                        displayKey: 'name_kh',
                                        onChanged: (item) {
                                          setState(() {
                                            _selectedTypeId = item['id'];
                                            _selectedTypeNameKh =
                                                item['name_kh'];
                                          });
                                        },
                                        selectedValue: _selectedTypeNameKh,
                                      ),
                                      const SizedBox(height: 16),
                                      DateInputField(
                                        label: 'កាលបរិច្ឆេទចាប់ផ្តើម',
                                        initialDate: DateTime.now(),
                                        selectedDate: _startDate,
                                        onDateSelected: (date) {
                                          setState(() {
                                            _startDate = date;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      DateInputField(
                                        label: 'កាលបរិច្ឆេទបញ្ចប់',
                                        initialDate: DateTime.now(),
                                        selectedDate: _endDate,
                                        onDateSelected: (date) {
                                          setState(() {
                                            _endDate = date;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      DescriptionTextField(
                                        controller: _descriptionController,
                                        onChanged: (value) {
                                          _description = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Display selected image or placeholder
                                            _image == null
                                                ? Text('No image selected.')
                                                : Image.file(
                                                  _image!,
                                                  height: 200,
                                                ),
                                            SizedBox(height: 20),
                                            // Button to pick image from gallery
                                            ElevatedButton(
                                              onPressed:
                                                  () => _pickImage(
                                                    ImageSource.gallery,
                                                  ),
                                              child: Text(
                                                'Pick Image from Gallery',
                                              ),
                                            ),
                                            // Button to pick image from camera
                                            // ElevatedButton(
                                            //   onPressed: () =>
                                            //       _pickImage(ImageSource.camera),
                                            //   child: Text('Take Photo'),
                                            // ),
                                            // Button to upload image
                                            // ElevatedButton(
                                            //   onPressed: _image == null ? null : _uploadImage,
                                            //   child: Text('Upload Image'),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        showConfirmDialog(
                          context,
                          'Confirm Create',
                          'Are you sure to create request?',
                          DialogType.primary,
                          () {
                            _validateAndSubmit();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'បញ្ជូនសំណើ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDropdown extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String label;
  final String displayKey;
  final Function(Map<String, dynamic>) onChanged;
  final String? selectedValue;

  const MyDropdown({
    super.key,
    required this.items,
    required this.label,
    required this.displayKey,
    required this.onChanged,
    this.selectedValue,
  });

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ជ្រើសរើស$label',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              ...items.map((item) {
                return ListTile(
                  title: Text(
                    item[displayKey],
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    onChanged(item);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue ?? 'សូមជ្រើសរើស$label',
                  style: TextStyle(
                    color:
                        selectedValue != null
                            ? Colors.black87
                            : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class KhmerDateFormatter {
  static String format(DateTime date) {
    final Map<int, String> khmerMonths = {
      1: 'មករា',
      2: 'កុម្ភៈ',
      3: 'មីនា',
      4: 'មេសា',
      5: 'ឧសភា',
      6: 'មិថុនា',
      7: 'កក្កដា',
      8: 'សីហា',
      9: 'កញ្ញា',
      10: 'តុលា',
      11: 'វិច្ឆិកា',
      12: 'ធ្នូ',
    };
    final Map<int, String> khmerDigits = {
      0: '០',
      1: '១',
      2: '២',
      3: '៣',
      4: '៤',
      5: '៥',
      6: '៦',
      7: '៧',
      8: '៨',
      9: '៩',
    };

    String day =
        date.day
            .toString()
            .padLeft(2, '0')
            .split('')
            .map((d) => khmerDigits[int.parse(d)]!)
            .join();
    String month = khmerMonths[date.month]!;
    String year =
        date.year
            .toString()
            .split('')
            .map((d) => khmerDigits[int.parse(d)]!)
            .join();

    return '$day $month $year';
  }
}

class DateInputField extends StatelessWidget {
  final String label;
  final DateTime initialDate;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateInputField({
    super.key,
    required this.label,
    required this.initialDate,
    required this.onDateSelected,
    this.selectedDate,
  });

  void _openDatePickerBottomSheet(BuildContext context) {
    DateTime tempDate = selectedDate ?? initialDate;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: tempDate,
                  minimumDate: DateTime(2000),
                  maximumDate: DateTime(2100),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onDateSelected(tempDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('ជ្រើសរើស'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openDatePickerBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? KhmerDateFormatter.format(selectedDate!)
                      : 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedDate != null
                            ? Colors.black87
                            : Colors.grey[600],
                  ),
                ),
                Icon(Icons.calendar_today, color: Colors.blue[800]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DescriptionTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const DescriptionTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ហេតុផល (ស្រេចចិត្ត)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 4,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'បញ្ចូលហេតុផលសម្រាប់ការស្នើសុំ...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
