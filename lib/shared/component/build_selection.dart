// Reusable Selection Field widget
  import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

// Reusable Selection Field widget
  Widget buildSelectionField({
    required TextEditingController controller,
    required String label,
    required Map<String, String> items,
    required void Function(String id, String value) onSelected,
    String? selectedId, // Add selectedId parameter
    required BuildContext context,
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
          //  selectedId: selectedEducationTypeId, // Pass current selection
          selectedId: selectedId, // Pass current selection
        );
      },
      decoration: InputDecoration(
        labelText: label,
        // hintText: hint,
          suffixIcon: Icon(Icons.arrow_drop_down,
            color: HColors.darkgrey),
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
      // decoration: InputDecoration(
      //   labelText: label,
      //   labelStyle: TextStyle(color: HColors.darkgrey),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(color: HColors.darkgrey),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(12.0),
      //     borderSide: BorderSide(
      //         color: Theme.of(context).colorScheme.primary, width: 1.0),
      //   ),
        // suffixIcon: Icon(Icons.arrow_drop_down,
        //     color: Theme.of(context).colorScheme.primary),
      //   filled: true,
      // ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.close),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  // vertical: 8.0,
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
                            // border: Border.all(
                            //   color: isSelected
                            //       ? HColors.darkgrey
                            //       : HColors.darkgrey,
                            //   width: isSelected ? 1.5 : 1.0,
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_2_outlined,
                                  color: HColors.darkgrey,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w400,
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
  

  class BuildSelectionField extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String label;
  final String displayKey;
  final Function(Map<String, dynamic>) onChanged;
  final String? selectedValue;
  final String? hintText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final int? maxLines;

  const BuildSelectionField({
    super.key,
    required this.items,
    required this.label,
    required this.displayKey,
    required this.onChanged,
    this.selectedValue,
    this.hintText,
    this.readOnly = false,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  State<BuildSelectionField> createState() => _BuildSelectionFieldState();
}

class _BuildSelectionFieldState extends State<BuildSelectionField> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedValue ?? '');
  }

  @override
  void didUpdateWidget(BuildSelectionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text when selectedValue changes
    if (oldWidget.selectedValue != widget.selectedValue) {
      _controller.text = widget.selectedValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  


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
              Container(
                width: 50,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Text(
                    'ជ្រើសរើស${widget.label}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected =
                        widget.selectedValue == item[widget.displayKey];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      title: Text(
                        item[widget.displayKey] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.blue[800] : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: Colors.blue[800], size: 20)
                          : null,
                      onTap: () {
                        widget.onChanged(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
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
        // Text(
        //   widget.label,
        //   style: TextStyle(
        //     fontSize: 16,
        //     fontWeight: FontWeight.w500,
        //     color: Colors.blue[800],
        //   ),
        // ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onTap: widget.readOnly ? () => _openBottomSheet(context) : null,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'សូមជ្រើសរើស${widget.label}',
            hintStyle: TextStyle(
              color: HColors.darkgrey,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: HColors.darkgrey, width: 1),
            ),
            suffixIcon: widget.readOnly && widget.items.isNotEmpty
                ? const Icon(Icons.arrow_drop_down, color: Colors.grey)
                : null,
          ),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

