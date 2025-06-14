import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/shared/component/bottom_appbar.dart';
import 'package:mobile_app/shared/image/full_screen.dart'; // Replace with your actual header widget

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  bool isClick = true;
  final List<PlatformFile> _selectedFiles = [];
  List<dio.MultipartFile>? _selectedMultipartFiles;
  int selectedThumbnail = 0;
  String _searchQuery = '';
  String _sortCriteria = 'name'; // Options: name, size, date
  bool _sortAscending = true;
  String _filterType = 'all'; // Options: all, images, documents
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<PlatformFile> _convertXFileToPlatformFile(XFile xFile) async {
    final bytes = await xFile.readAsBytes();
    final name = xFile.name.isNotEmpty
        ? xFile.name
        : 'image_${DateTime.now().millisecondsSinceEpoch}';
    final size = bytes.length;
    return PlatformFile(
      name: name,
      path: xFile.path,
      size: size,
      bytes: bytes,
      readStream: xFile.openRead(),
    );
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

  List<PlatformFile> _getFilteredAndSortedFiles() {
    List<PlatformFile> filteredFiles = _selectedFiles.where((file) {
      return file.name.toLowerCase().contains(_searchQuery);
    }).toList();

    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final documentExtensions = ['.pdf', '.doc', '.docx', '.txt'];
    if (_filterType == 'images') {
      filteredFiles = filteredFiles.where((file) {
        return file.path != null &&
            imageExtensions
                .any((ext) => file.path!.toLowerCase().endsWith(ext));
      }).toList();
    } else if (_filterType == 'documents') {
      filteredFiles = filteredFiles.where((file) {
        return file.path != null &&
            documentExtensions
                .any((ext) => file.path!.toLowerCase().endsWith(ext));
      }).toList();
    }

    filteredFiles.sort((a, b) {
      int comparison;
      if (_sortCriteria == 'name') {
        comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else if (_sortCriteria == 'size') {
        comparison = a.size.compareTo(b.size);
      } else {
        comparison =
            _selectedFiles.indexOf(a).compareTo(_selectedFiles.indexOf(b));
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filteredFiles;
  }

  final data = [
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
    {
      'id': 1,
      'name': 'Personal Information',
      'size': 13,
      'date': '22/06/2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ឯកសារ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        bottom: CustomHeader(),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         InkWell(
        //           onTap: () {
        //             _showBottomSheetFile(context);
        //           },
        //           child: Icon(
        //             Icons.attach_file_outlined,
        //             color: HColors.darkgrey,
        //           ),
        //         ),
        //         SizedBox(width: 8),
        //         InkWell(
        //           onTap: () {
        //             setState(() {
        //               isClick = !isClick;
        //             });
        //           },
        //           child: isClick
        //               ? Icon(Icons.menu, color: HColors.darkgrey)
        //               : Icon(Icons.grid_view, color: HColors.darkgrey),
        //         ),
        //         SizedBox(width: 8),
        //         InkWell(
        //           onTap: () {
        //             _showSortBottomSheet(context);
        //           },
        //           child: Icon(Icons.sort, color: HColors.darkgrey),
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextField(

                  //   controller: _searchController,
                  //   decoration: InputDecoration(
                  //     hintText: 'ស្វែងរក...',
                  //     prefixIcon: Icon(Icons.search, color: HColors.darkgrey),
                  //     suffixIcon: _searchQuery.isNotEmpty
                  //         ? IconButton(
                  //             icon: Icon(Icons.clear, color: HColors.darkgrey),
                  //             onPressed: () {
                  //               _searchController.clear();
                  //             },
                  //           )
                  //         : null,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide:
                  //           BorderSide(color: HColors.darkgrey.withOpacity(0.3)),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide:
                  //           BorderSide(color: HColors.darkgrey.withOpacity(0.3)),
                  //     ),
                  //     filled: true,
                  //     fillColor: HColors.darkgrey.withOpacity(0.05),
                  //   ),
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ស្វែងរក',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.grey[600],
                            size: 22,
                          ),
                        ),
                        // suffixIcon: searchController.text.isNotEmpty
                        //     ? GestureDetector(
                        //         onTap: () {
                        //           searchController.clear();
                        //           // Reset to original filtered data
                        //           setState(() {
                        //             staticData = data;
                        //           });
                        //         },
                        //         child: Container(
                        //           padding: EdgeInsets.all(12),
                        //           child: Icon(
                        //             Icons.clear_rounded,
                        //             color: Colors.grey[500],
                        //             size: 20,
                        //           ),
                        //         ),
                        //       )
                        //     : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.blue.withOpacity(0.8),
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        isDense: false,
                      ),
                      onChanged: (value) {
                        // setState(() {
                        //   if (value.isEmpty) {
                        //     staticData =
                        //         data; // Reset to original filtered data
                        //   } else {
                        //     staticData = data.where((item) {
                        //       final name = item['name_kh']
                        //               ?.toString()
                        //               .toLowerCase() ??
                        //           '';
                        //       return name.contains(value.toLowerCase());
                        //     }).toList();
                        //   }
                        // });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildFilterChips(),
                  SizedBox(height: 16),
                  _selectedFiles.isEmpty
                      ? _buildEmptyStateDisplay(isClick)
                      : Row(children: [
                          Expanded(child: _buildFileDisplay(isClick))
                        ]),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateDisplay(bool isGrid) {
    return isGrid
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length, // Use data list length
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return _buildPlaceholderGridItem(
                  data[index], index); // Pass data item
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length, // Use data list length
            itemBuilder: (context, index) {
              return _buildPlaceholderListItem(
                  data[index], index); // Pass data item
            },
          );
  }

  Widget _buildPlaceholderGridItem(Map<String, dynamic> item, int index) {
    // Alternate between image and document placeholders for variety
    final isImage = index % 2 == 0;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: HColors.darkgrey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        color: HColors.darkgrey.withOpacity(0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'lib/assets/images/pdf.png', // Document placeholder
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        item['name'], // Use name from data
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${item['size']} MB', // Use size from data
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 10,
                      color: HColors.darkgrey,
                    ),
                    SizedBox(width: 2),
                    Text(
                      item['date'], // Use date from data
                      style: TextStyle(
                        fontSize: 10,
                        color: HColors.darkgrey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildPlaceholderListItem(Map<String, dynamic> item, int index) {
    // Alternate between image and document placeholders for variety
    final isImage = index % 2 == 0;
    return ListTile(
      leading: Icon(
        isImage ? Icons.image : Icons.insert_drive_file,
        color: HColors.darkgrey.withOpacity(0.5),
      ),
      title: Text(
        item['name'], // Use name from data
        style: TextStyle(
          color: HColors.darkgrey.withOpacity(0.7),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item['size']} MB', // Use size from data
            style: TextStyle(
              fontSize: 12,
              color: HColors.darkgrey.withOpacity(0.7),
            ),
          ),
          Text(
            item['date'], // Use date from data
            style: TextStyle(
              fontSize: 12,
              color: HColors.darkgrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.more_vert,
        color: HColors.darkgrey.withOpacity(0.5),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HColors.darkgrey.withOpacity(0.1))),
          child: Row(children: [
            Icon(
              Icons.check,
              size: 14,
            ),
            SizedBox(
              width: 2,
            ),
            Text("ទាំងអស់")
          ]),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HColors.darkgrey.withOpacity(0.1))),
          child: Row(children: [
            // Icon(
            //   Icons.check,
            //   size: 14,
            // ),
            SizedBox(
              width: 2,
            ),
            Text("ឯកសាររក្សាទុក")
          ]),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: HColors.darkgrey.withOpacity(0.1))),
          child: Row(children: [
            // Icon(
            //   Icons.check,
            //   size: 14,
            // ),
            SizedBox(
              width: 2,
            ),
            Text("ឯកសារសំខាន់ៗ")
          ]),
        ),
      ],
    );
  }

  void _showSortBottomSheet(BuildContext context) {
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
                leading: Icon(Icons.sort_by_alpha, color: HColors.darkgrey),
                title: Text('Sort by Name'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'name';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.storage, color: HColors.darkgrey),
                title: Text('Sort by Size'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'size';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.date_range, color: HColors.darkgrey),
                title: Text('Sort by Date Added'),
                onTap: () {
                  setState(() {
                    _sortCriteria = 'date';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: HColors.darkgrey,
                ),
                title: Text(_sortAscending ? 'Ascending' : 'Descending'),
                onTap: () {
                  setState(() {
                    _sortAscending = !_sortAscending;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileDisplay(bool isGrid) {
    final filteredFiles = _getFilteredAndSortedFiles();
    if (filteredFiles.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No files found'),
        ),
      );
    }

    return isGrid
        ? GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredFiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              return _buildGridFileItem(file, index);
            },
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredFiles.length,
            itemBuilder: (context, index) {
              final file = filteredFiles[index];
              return _buildListFileItem(file, index);
            },
          );
  }

  Widget _buildGridFileItem(PlatformFile file, int index) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
    final isImage = file.path != null &&
        imageExtensions.any((ext) => file.path!.toLowerCase().endsWith(ext));

    if (!isImage) {
      return _buildGenericFileItem(file, index);
    }

    return GestureDetector(
      onTap: () => _showFullscreenImage(file, index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(File(file.path!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      formatFileSize(file.size),
                      style: TextStyle(fontSize: 10, color: HColors.darkgrey),
                    ),
                  ],
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
          ),
          Text(
            formatFileSize(file.size),
            style: TextStyle(fontSize: 10, color: HColors.darkgrey),
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
      title: Text(file.name),
      subtitle: Text(
        formatFileSize(file.size),
        style: TextStyle(fontSize: 12),
      ),
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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.remove_red_eye, color: HColors.darkgrey),
                  title: Text('មើល'),
                  onTap: () {
                    _showFullscreenImage(file, index);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: HColors.danger),
                  title: Text("លុប"),
                  onTap: () {
                    _removeFileAtIndex(index);
                  },
                ),
              ],
            ),
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
    const gb = mb * 1024;
    if (bytes < kb) {
      return "$bytes B";
    } else if (bytes < mb) {
      return "${(bytes / kb).toStringAsFixed(2)} KB";
    } else if (bytes < gb) {
      return "${(bytes / mb).toStringAsFixed(2)} MB";
    } else {
      return "${(bytes / gb).toStringAsFixed(2)} GB";
    }
  }

  void _showBottomSheetFile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Wrap(
              children: [
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
                      await _addImagesToSelectedFiles(pickedImages);
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_file, color: HColors.darkgrey),
                  title: Text("ជ្រើសរើសរូបពីឯកសារខ្ញុំ"),
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                    );
                    if (result != null) {
                      setState(() {
                        _selectedFiles.addAll(result.files);
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
