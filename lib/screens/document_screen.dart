import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/shared/color/colors.dart'; // Replace with your actual color file
import 'package:mobile_app/shared/image/full_screen.dart'; // Replace with your actual full screen widget
import 'package:mobile_app/widgets/custom_header.dart'; // Replace with your actual header widget

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  bool isClick = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search files...',
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: HColors.darkgrey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        bottom: CustomHeader(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    setState(() {
                      isClick = !isClick;
                    });
                  },
                  child: isClick
                      ? Icon(Icons.menu, color: HColors.darkgrey)
                      : Icon(Icons.grid_view, color: HColors.darkgrey),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    _showSortBottomSheet(
                        context); // Updated to use bottom sheet
                  },
                  child: Icon(Icons.sort, color: HColors.darkgrey),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterChips(),
                if (_getFilteredAndSortedFiles().isNotEmpty)
                  Row(children: [Expanded(child: _buildFileDisplay(isClick))])
                else
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No files found'),
                    ),
                  ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text('All'),
          selected: _filterType == 'all',
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _filterType = 'all';
              });
            }
          },
          labelStyle: TextStyle(
            color: _filterType == 'all' ? Colors.white : HColors.darkgrey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          selectedColor: HColors.blue,
          backgroundColor: HColors.darkgrey.withOpacity(0.1),
          checkmarkColor: Colors.white,
          side: BorderSide(
            color: _filterType == 'all'
                ? HColors.bluegrey
                : HColors.darkgrey.withOpacity(0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: _filterType == 'all' ? 2 : 0,
          pressElevation: 4,
        ),
        ChoiceChip(
          label: Text('Images'),
          selected: _filterType == 'images',
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _filterType = 'images';
              });
            }
          },
          labelStyle: TextStyle(
            color: _filterType == 'images' ? Colors.white : HColors.darkgrey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          selectedColor: HColors.blue,
          backgroundColor: HColors.darkgrey.withOpacity(0.1),
          checkmarkColor: Colors.white,
          side: BorderSide(
            color: _filterType == 'images'
                ? HColors.bluegrey
                : HColors.darkgrey.withOpacity(0.3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: _filterType == 'images' ? 2 : 0,
          pressElevation: 4,
        ),
        ChoiceChip(
          label: Text('Documents'),
          selected: _filterType == 'documents',
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _filterType = 'documents';
              });
            }
          },
          labelStyle: TextStyle(
            color: _filterType == 'documents' ? Colors.white : HColors.darkgrey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          selectedColor: HColors.blue,
          backgroundColor: HColors.darkgrey.withOpacity(0.1),
          checkmarkColor: Colors.white,
          side: BorderSide(
            color: _filterType == 'documents'
                ? HColors.bluegrey
                : HColors.darkgrey.withOpacity(0.1),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          elevation: _filterType == 'documents' ? 2 : 0,
          // pressElevation: 4,
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
    if (filteredFiles.isEmpty) return SizedBox.shrink();

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
                        // fontFamily: 'Kantumruy Pro',
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
            // style: TextStyle(fontFamily: 'Kantumruy Pro'),
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
