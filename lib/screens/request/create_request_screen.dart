import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request/create_request_provider.dart';
import 'package:mobile_app/providers/local/request_provider.dart';
import 'package:mobile_app/services/request/create_request_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/date/field_date.dart';
import 'package:mobile_app/shared/image/full_screen.dart';
// import 'package:mobile_app/shared/component/show_confirm_dialog.dart';
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
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();
  // Future<void> _refreshData(CreateRequestProvider provider) async {
  //   return await provider.getHome();
  // }

  // Variables to store form field values
  int? _selectedTypeId;
  // int isCheckId = 0;
  // String? _selectedTypeNameKh;
  // final TextEditingController _type = TextEditingController(); //
  DateTime? _startDate;
  DateTime? _endDate;
  String? _description;
  bool isClick = false;
  // File? _image; // Store the selected image
  // final ImagePicker _picker = ImagePicker();
  // String? _imageBase64;
  final List<PlatformFile> _selectedFiles = [];
  int selectedThumbnail = 0; // Now it can never be null

  // Future<void> _pickImage(ImageSource source) async {
  //   final XFile? pickedFile = await _picker.pickImage(source: source);

  //   if (pickedFile != null) {
  //     // First create the File from the picked image
  //     final File imageFile = File(pickedFile.path);

  //     // Then read the bytes
  //     final bytes = await imageFile.readAsBytes();
  //     final base64Image = base64Encode(bytes);

  //     setState(() {
  //       _image = imageFile;
  //       _imageBase64 = base64Image;
  //     });
  //   }
  // }

  List<dio.MultipartFile>? _selectedMultipartFiles; // Add this variable
  Future<PlatformFile> _convertXFileToPlatformFile(XFile xFile) async {
    final bytes = await xFile.readAsBytes(); // Better to use async read
    final name = xFile.name;
    final size = bytes.length;

    return PlatformFile(name: name, path: xFile.path, size: size, bytes: bytes);
  }

  Future<void> _addImagesToSelectedFiles(List<XFile> images) async {
    try {
      final converted = await Future.wait(
        images.map((xFile) => _convertXFileToPlatformFile(xFile)),
      );

      final multipartFiles = converted.map((pf) {
        return dio.MultipartFile.fromBytes(pf.bytes!, filename: pf.name);
      }).toList();

      setState(() {
        _selectedFiles.addAll(converted);
        _selectedMultipartFiles ??= [];
        _selectedMultipartFiles!.addAll(multipartFiles);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add files: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
    // if (_imageBase64 == null) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(const SnackBar(content: Text('សូមជ្រើសរើសរូប')));
    //   }
    //   return;
    // }

    try {
      await _createRequestService.createRequest(
        startDate: DateFormat('yyyy-MM-dd').format(_startDate!),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate!),
        objective:
            _description?.trim().isNotEmpty == true ? _description! : null,
        requestTypeId: _selectedTypeId!,
        requestCategoryId: int.parse(widget.id!),
        // attachment: _imageBase64!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ការស្នើសុំត្រូវបានបញ្ជូនដោយជោគជ័យ')),
        );
        Provider.of<RequestProvider>(context, listen: false).getHome();
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
          final List<dynamic>? requestCategories = createRequestProvider
              .data?.data['request_categories'] as List<dynamic>?;

          Map<String, dynamic>? data;
          if (requestCategories != null) {
            try {
              data = requestCategories.firstWhere(
                (item) => item['id'] == int.parse(widget.id!),
                orElse: () => <String, dynamic>{},
              ) as Map<String, dynamic>;

              // If we got an empty map from orElse, set data to null
              if (data.isEmpty) {
                data = null;
              }
            } catch (e) {
              data = null;
            }
          }
          return Scaffold(
            // backgroundColor: Colors.grey[100],
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('ស្នើសុំច្បាប់'),
              centerTitle: true,
              bottom: CustomHeader(),
              actions: [
                // GestureDetector(
                //   onTap: () {
                // showConfirmDialog(
                //   context,
                //   'Confirm Create',
                //   'Are you sure to create request?',
                //   DialogType.primary,
                //   () {
                //     _validateAndSubmit();
                //   },
                // );
                // // ConfirmationDialog.show(
                // //   context: context,
                // //   title: 'Confirm Create',
                // //   message: 'Are you sure to create request?',
                // //   confirmText: 'រួចរាល់',
                // //   cancelText: 'បិត',
                // //   onCancel: () {},
                // //   onConfirm: () {
                // //     _validateAndSubmit();
                // //   },
                // // );
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       padding: const EdgeInsets.all(6.0),
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.white,
                //       ),
                //       child: Icon(
                //         Icons.check,
                //         size: 28.0,
                //         color: Colors.blue[800],
                //       ),
                //     ),
                //   ),
                // ),
                IconButton(
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
                      // ConfirmationDialog.show(
                      //   context: context,
                      //   title: 'Confirm Create',
                      //   message: 'Are you sure to create request?',
                      //   confirmText: 'រួចរាល់',
                      //   cancelText: 'បិត',
                      //   onCancel: () {},
                      //   onConfirm: () {
                      //     _validateAndSubmit();
                      //   },
                      // );
                    },
                    icon: Icon(Icons.check))
              ],
            ),
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: createRequestProvider.isLoading
                  ? const Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Loading...'),
                      ],
                    ))
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SingleChildScrollView(
                              //   scrollDirection: Axis.horizontal,
                              //   child: Wrap(
                              //     spacing: 10,
                              //     runSpacing: 10,
                              //     children:
                              //         (data!['request_types'] as List).map((
                              //       record,
                              //     ) {
                              //       return Container(
                              //         margin: EdgeInsets.zero,
                              //         padding: const EdgeInsets.symmetric(
                              //           vertical: 4,
                              //           horizontal: 8,
                              //         ),
                              //         decoration: BoxDecoration(
                              //           color: const Color.fromRGBO(
                              //             33,
                              //             150,
                              //             243,
                              //             0.1,
                              //           ),
                              //           borderRadius: const BorderRadius.all(
                              //             Radius.circular(16),
                              //           ),
                              //         ),
                              //         child: Text(
                              //           '${getSafeString(value: AppLang.translate(data: record, lang: settingProvider.lang ?? 'kh'))} ${getSafeInteger(value: record['max_per_year'])}',
                              //           style: TextStyle(
                              //             color: Colors.blue[800],
                              //           ),
                              //         ),
                              //       );
                              //     }).toList(),
                              //   ),
                              // ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children:
                                      (data!['request_types'] as List).map((
                                    record,
                                  ) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedTypeId = record['id'];
                                        });
                                        // print(_selectedTypeId);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.zero,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
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
                                            Radius.circular(5),
                                          ),
                                          border: Border.all(
                                            color: HColors.darkgrey
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${getSafeString(value: AppLang.translate(data: record, lang: settingProvider.lang ?? 'kh'))} ',
                                              style: TextStyle(
                                                color: _selectedTypeId ==
                                                        record['id']
                                                    ? Colors.blue
                                                    : HColors.darkgrey,
                                              ),
                                            ),
                                            _selectedTypeId == record['id']
                                                ? Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Colors.blue,
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
              
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: DateInputField(
                                      label: 'ថ្ងៃចាប់ផ្តើម',
                                      hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                      initialDate: DateTime.now(),
                                      selectedDate: _startDate,
                                      onDateSelected: (date) {
                                        setState(() {
                                          _startDate = date;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: DateInputField(
                                      label: 'ថ្ងៃបញ្ចប់',
                                      hint: 'សូមជ្រើសរើសកាលបរិច្ឆេទ',
                                      initialDate: DateTime.now(),
                                      selectedDate: _endDate,
                                      onDateSelected: (date) {
                                        setState(() {
                                          _endDate = date;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              DescriptionTextField(
                                controller: _descriptionController,
                                onChanged: (value) {
                                  _description = value;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Center(
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       // Display selected image or placeholder
                              //       _image == null
                              //           ? Text('រូបភាព')
                              //           : Image.file(
                              //               _image!,
                              //               height: 200,
                              //             ),
                              //       SizedBox(height: 20),
                              //       // Button to pick image from gallery
                              //       ElevatedButton(
                              //         onPressed: () => _pickImage(
                              //           ImageSource.gallery,
                              //         ),
                              //         child: Text(
                              //           'Pick Image from Gallery',
                              //         ),
                              //       ),
                              //       // Button to pick image from camera
                              //       // ElevatedButton(
                              //       //   onPressed: () =>
                              //       //       _pickImage(ImageSource.camera),
                              //       //   child: Text('Take Photo'),
                              //       // ),
                              //       // Button to upload image
                              //       // ElevatedButton(
                              //       //   onPressed: _image == null ? null : _uploadImage,
                              //       //   child: Text('Upload Image'),
                              //       // ),
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          HColors.darkgrey.withOpacity(0.1),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.image,
                                            color: HColors.darkgrey),
                                        SizedBox(width: 8),
                                        Text("រូបភាព")
                                        // EText(text: "រូបភាព", size: EFontSize.content),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _showBottomSheetFile(context);
                                          },
                                          child: Icon(
                                            Icons.attach_file_outlined,
                                            color: HColors.darkgrey,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isClick = !isClick;
                                            });
                                          },
                                          child: isClick
                                              ? Icon(
                                                  Icons.menu,
                                                  color: HColors.darkgrey,
                                                )
                                              : Icon(
                                                  Icons.grid_view,
                                                  color: HColors.darkgrey,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (_selectedFiles.isNotEmpty)
                                Row(children: [
                                  Expanded(child: _buildFileDisplay(isClick))
                                ]),
                              SizedBox(height: 100),
                            ],
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

  // File display widget
  Widget _buildFileDisplay(bool isGrid) {
    if (_selectedFiles.isEmpty) return SizedBox.shrink();

    return isGrid
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _selectedFiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final file = _selectedFiles[index];
              return _buildGridFileItem(file, index);
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _selectedFiles.length,
            itemBuilder: (context, index) {
              final file = _selectedFiles[index];
              return _buildListFileItem(file, index);
            },
          );
  }

  Widget _buildGridFileItem(PlatformFile file, int index) {
    // Check if the file is an image by its extension
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final isImage = file.path != null &&
        imageExtensions.any((ext) => file.path!.toLowerCase().endsWith(ext));

    if (!isImage) {
      return _buildGenericFileItem(file, index);
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () => _showFullscreenImage(file, index),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: 'imageHero_$index',
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: FileImage(File(file.path!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: IconButton(
                  //     icon: Icon(
                  //       selectedThumbnail == index ? Icons.star : Icons.star,
                  //       color: selectedThumbnail == index
                  //           ? Colors.amber
                  //           : HColors.darkgrey,
                  //       size: 30,
                  //     ),
                  //     onPressed: () {
                  //       setState(() {
                  //         // Toggle selection - if already selected, deselect; otherwise select this one
                  //         selectedThumbnail =
                  //             selectedThumbnail == index ? 0 : index;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 4), // Add some spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    file.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Kantumruy Pro',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showBottomSheet(context, file, index);
                  },
                  child: Icon(Icons.more_vert, color: HColors.darkgrey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericFileItem(PlatformFile file, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 40),
          SizedBox(height: 4),
          Text(
            file.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Kantumruy Pro'),
          ),
        ],
      ),
    );
  }

  Widget _buildListFileItem(PlatformFile file, int index) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final isImage = file.path != null &&
        imageExtensions.any((ext) => file.path!.toLowerCase().endsWith(ext));

    return ListTile(
      leading: Icon(
        isImage ? Icons.image : Icons.insert_drive_file,
        color: HColors.darkgrey,
      ),
      // title: EText(
      //   text: file.name,
      //   size: EFontSize.small,
      //   maxLines: 1,
      //   textOverflow: TextOverflow.ellipsis,
      // ),
      title: Text(file.name),
      subtitle: Text(formatFileSize(file.size), style: TextStyle(fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              selectedThumbnail == index ? Icons.star : Icons.star_border,
              color:
                  selectedThumbnail == index ? Colors.amber : HColors.darkgrey,
            ),
            onPressed: () {
              setState(() {
                selectedThumbnail = selectedThumbnail == index ? 0 : index;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: HColors.darkgrey),
            onPressed: () => _showBottomSheet(context, file, index),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, PlatformFile file, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.remove_red_eye, color: HColors.darkgrey),
                title: Text('មើល'),
                onTap: () {
                  // Get.to(
                  //   () => FullscreenImage(
                  //     imageBytes: File(file.path!).readAsBytesSync(),
                  //     tag: 'imageHero_$index',
                  //   ),
                  // );
                },
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.folder_open_outlined,
              //     color: HColors.darkgrey,
              //   ),
              //   title: EText(text: "ឯកសារអង្គភាព"),
              //   onTap: () {
              //     // Handle folder picking (if needed)
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.delete, color: HColors.danger),
                title: Text("លុប"),
                onTap: () {
                  // Handle recent files selection
                  _removeFileAtIndex(index);
                  // Get.back();
                },
              ),
              // ListTile(
              //   leading: Icon(NewsIcon.mdi_light__tag, color: HColors.darkgrey),

              //   title: EText(text: "tag".tr, size: EFontSize.footer),
              //   onTap: () {
              //     // Handle recent files selection
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  void _showFullscreenImage(PlatformFile file, int index) {
    if (file.path == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullscreenImage(
          imageBytes: File(file.path!).readAsBytesSync(),
          tag: 'imageHero_$index',
        ),
      ),
    );
  }

  void _removeFileAtIndex(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _selectedMultipartFiles?.removeAt(index);

      context.pop();
    });
  }

  String formatFileSize(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    if (bytes < kb) {
      return "$bytes B";
    } else if (bytes < mb) {
      return "${(bytes / kb).round()} KB";
    } else {
      return "${(bytes / mb).toStringAsFixed(2)} MB";
    }
  }

  void _showBottomSheetFile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Wrap(
            children: [
              // ListTile(
              //   leading: Icon(
              //     Icons.camera_alt,
              //     color: HColors.darkgrey,
              //   ),
              //   title: EText(text: "កាមេរ៉ា"),
              //   onTap: () {
              //     // Handle camera usage here (use image_picker package)
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: Icon(
                  Icons.folder_open_outlined,
                  color: HColors.darkgrey,
                ),
                title: Text('ជ្រើសរើសពីម៉ាសុីន'),
                onTap: () async {
                  final picker = ImagePicker();
                  final List<XFile> pickedImages =
                      await picker.pickMultiImage();

                  if (pickedImages.isNotEmpty) {
                    _addImagesToSelectedFiles(pickedImages);
                  }

                  Navigator.pop(context); // Close bottom sheet
                },
              ),
              // ListTile(
              //   leading: Icon(
              //     Icons.folder_open_outlined,
              //     color: HColors.darkgrey,
              //   ),
              //   title: EText(text: "ឯកសារអង្គភាព"),
              //   onTap: () {
              //     // Handle folder picking (if needed)
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.attach_file, color: HColors.darkgrey),
                title: Text("ជ្រើសរើសរូបពីឯកសារខ្ញុំ"),
                onTap: () async {
                  // Use FilePicker to pick files
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: true, // Allow multiple file selection
                  );
                  if (result != null) {
                    setState(() {
                      // Assuming _selectedFiles is a List of PlatformFile
                      _selectedFiles.addAll(result.files);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
        // Text(
        //   'ហេតុផល (ស្រេចចិត្ត)',
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w500,
        //     color: Colors.blue[800],
        //   ),
        // ),

        TextField(
          controller: controller,
          maxLines: null,
          onChanged: onChanged,
          decoration: InputDecoration(
            label: Text("មូលហេតុ"),
            hintText: 'បញ្ចូលហេតុផល',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: HColors.darkgrey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              color: HColors.darkgrey,
              fontWeight: FontWeight.w400,
            ),
            hintStyle: TextStyle(
              color: HColors.darkgrey,
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
