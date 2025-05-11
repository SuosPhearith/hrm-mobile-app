import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:provider/provider.dart';

class MonthPickerWidget extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate) onMonthSelected;
  final DateTime? initialSelectedMonth;

  const MonthPickerWidget({
    super.key,
    required this.onMonthSelected,
    this.initialSelectedMonth,
  });

  static Future<void> show(
    BuildContext context, {
    required Function(DateTime startDate, DateTime endDate) onMonthSelected,
    DateTime? initialSelectedMonth,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          child: MonthPickerWidget(
            onMonthSelected: onMonthSelected,
            initialSelectedMonth: initialSelectedMonth,
          ),
        );
      },
    );
  }

  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget>
    with SingleTickerProviderStateMixin {
  late DateTime _focusedDay;
  DateTime? _selectedMonth;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _currentYear;
  bool _isAnimating = false;

  // Add scroll variables
  double _dragStartX = 0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialSelectedMonth ?? DateTime.now();
    _selectedMonth = widget.initialSelectedMonth;
    _currentYear = _focusedDay.year;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimating = false;
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeYear(int delta) {
    if (_isAnimating) return;

    _isAnimating = true;
    setState(() {
      _currentYear += delta;
      _focusedDay = DateTime(_currentYear, _focusedDay.month);

      // If there was a selected month, update its year too
      if (_selectedMonth != null) {
        _selectedMonth = DateTime(_currentYear, _selectedMonth!.month);
      }
    });

    _animationController.forward();
  }

  void _handleHorizontalDrag(DragUpdateDetails details) {
    if (_isAnimating) return;

    if (!_isDragging) {
      _dragStartX = details.globalPosition.dx;
      _isDragging = true;
      return;
    }

    final dragDistance = details.globalPosition.dx - _dragStartX;

    // Threshold for year change (adjust as needed)
    if (dragDistance.abs() > 50) {
      _changeYear(dragDistance > 0 ? -1 : 1);
      _isDragging = false;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
  }

  @override
  Widget build(BuildContext context) {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return GestureDetector(
      onHorizontalDragUpdate: _handleHorizontalDrag,
      onHorizontalDragEnd: _handleDragEnd,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'ជ្រើសរើសខែ និងឆ្នាំ',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),

            // Year selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: primaryColor),
                    onPressed: () => _changeYear(-1),
                    tooltip: 'Previous Year',
                  ),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_animation.value * 0.1),
                        child: Text(
                          '${_focusedDay.year}',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: primaryColor),
                    onPressed: () => _changeYear(1),
                    tooltip: 'Next Year',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16.0),

            // Month grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final monthIndex = index + 1;
                    final isSelected = _selectedMonth != null &&
                        _selectedMonth!.month == monthIndex &&
                        _selectedMonth!.year == _focusedDay.year;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedMonth =
                                  DateTime(_focusedDay.year, monthIndex);
                            });
                          },
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                settingProvider.lang == 'kh'
                                    ? _getMonthName(monthIndex)
                                    : _getMonthNameEn(monthIndex),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? primaryColor
                                      : onSurfaceColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'បោះបង់',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedMonth == null
                          ? null
                          : () {
                              // Calculate start date (first day of month)
                              final startDate = DateTime(_selectedMonth!.year,
                                  _selectedMonth!.month, 1);

                              // Calculate end date (last day of month)
                              final endDate = DateTime(
                                _selectedMonth!.year,
                                _selectedMonth!.month + 1,
                                0, // Day 0 of next month = last day of current month
                              );

                              widget.onMonthSelected(startDate, endDate);
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text(
                        'ជ្រើសរើស',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ',
    ];
    return months[month - 1];
  }

  String _getMonthNameEn(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
