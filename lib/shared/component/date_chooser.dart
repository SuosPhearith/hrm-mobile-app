// import 'package:flutter/material.dart';
//  DateTime? _selectedDateTime;
// Future<void> _pickDate(BuildContext context) async {
//     final now = DateTime.now();
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDateTime ?? now,
//       firstDate: DateTime(now.year - 1),
//       lastDate: DateTime(now.year + 1),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _selectedDateTime = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           _selectedDateTime?.hour ?? now.hour,
//           _selectedDateTime?.minute ?? now.minute,
//         );
//         log("$_selectedDateTime");
//       });
//     }
//   }

//   Future<void> _pickTime(BuildContext context) async {
//     final now = DateTime.now();
//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime:
//           _selectedDateTime != null
//               ? TimeOfDay.fromDateTime(_selectedDateTime!)
//               : TimeOfDay.fromDateTime(now),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         final date = _selectedDateTime ?? now;
//         _selectedDateTime = DateTime(
//           date.year,
//           date.month,
//           date.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//         log("$_selectedDateTime");
//       });
//     }
//   }