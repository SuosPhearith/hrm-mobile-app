// import 'package:flutter/material.dart';

// void showConfirmDialog(
//   BuildContext context,
//   String title,
//   String message,
//   DialogType type,
//   VoidCallback onConfirm,
// ) {
//   showDialog(
//     context: context,
//     barrierDismissible:
//         false, // Prevent closing dialog by tapping outside during loading
//     builder: (BuildContext context) {
//       bool isLoading = false; // Local loading state

//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             backgroundColor: Colors.white,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             title: Row(
//               children: [
//                 Icon(
//                   Icons.warning,
//                   color: type == DialogType.primary ? Colors.blue : Colors.red,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             content: Text(
//               message,
//               style: const TextStyle(fontSize: 16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: isLoading
//                     ? null // Disable Cancel button during loading
//                     : () => Navigator.pop(context),
//                 style: TextButton.styleFrom(foregroundColor: Colors.grey),
//                 child: const Text(
//                   "បោះបង់",
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: isLoading
//                     ? null // Disable Confirm button during loading
//                     : () async {
//                         setState(() => isLoading = true); // Start loading
//                         try {
//                           await Future(
//                               () => onConfirm()); // Execute async action
//                           if (context.mounted) {
//                             Navigator.pop(context);
//                           }
//                         } catch (e) {
//                           setState(() => isLoading = false);
//                         }
//                       },
//                 icon: isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Icon(
//                         type == DialogType.primary ? Icons.check : Icons.delete,
//                         color: Colors.white,
//                       ),
//                 label: isLoading
//                     ? const SizedBox.shrink() // Hide text during loading
//                     : const Text(
//                         "បាទ/ចាស",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                         ),
//                       ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       type == DialogType.primary ? Colors.blue : Colors.red,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// void showErrorDialog(
//   BuildContext context,
//   String title,
// ) {
//   showDialog(
//     context: context,
//     barrierDismissible: true, // Allow closing by tapping outside
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         contentPadding: const EdgeInsets.all(20), // Uniform padding
//         content: Column(
//           mainAxisSize: MainAxisSize.min, // Minimize dialog height
//           children: [
//             const Icon(
//               Icons.warning_rounded, // Static warning icon
//               color: Colors.red, // Consistent error color
//               size: 48, // Larger size for prominence
//             ),
//             const SizedBox(height: 16), // Spacing between icon and title
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center, // Center title
//             ), // Spacing before button
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity, // Full-width button
//               child: TextButton(
//                 onPressed: () => Navigator.pop(context), // Close dialog
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.blue, // Professional blue color
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),

//                 child: const Text(
//                   "បិទ", // "OK" in Khmer
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// void showConfirmDialogWithNavigation(
//   BuildContext context,
//   String title,
//   String message,
//   DialogType type,
//   VoidCallback onConfirm,
// ) {
//   showDialog(
//     context: context,
//     barrierDismissible:
//         false, // Prevent closing dialog by tapping outside during loading
//     builder: (BuildContext context) {
//       bool isLoading = false; // Local loading state

//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return AlertDialog(
//             backgroundColor: Colors.white,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             title: Row(
//               children: [
//                 Icon(
//                   Icons.warning,
//                   color: type == DialogType.primary ? Colors.blue : Colors.red,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             content: Text(
//               message,
//               style: const TextStyle(fontSize: 16),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: isLoading
//                     ? null // Disable Cancel button during loading
//                     : () => Navigator.pop(context),
//                 style: TextButton.styleFrom(foregroundColor: Colors.grey),
//                 child: const Text(
//                   "បោះបង់",
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: isLoading
//                     ? null // Disable Confirm button during loading
//                     : () async {
//                         setState(() => isLoading = true); // Start loading
//                         try {
//                           await Future(
//                               () => onConfirm()); // Execute async action
//                           if (context.mounted) {
//                             Navigator.pop(context); // Close dialog on success
//                           }
//                         } catch (e) {
//                           // Optionally handle errors (e.g., show a message)
//                           setState(
//                               () => isLoading = false); // Stop loading on error
//                         }
//                       },
//                 icon: isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Icon(
//                         type == DialogType.primary ? Icons.check : Icons.delete,
//                         color: Colors.white,
//                       ),
//                 label: isLoading
//                     ? const SizedBox.shrink() // Hide text during loading
//                     : const Text(
//                         "បាទ/ចាស",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.white,
//                         ),
//                       ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       type == DialogType.primary ? Colors.blue : Colors.red,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// void showConfirmDialogWithNavigationOfSaleInvoice(BuildContext context,
//     String title, Widget message, DialogType type, VoidCallback onConfirm) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.warning,
//                 color: type == DialogType.primary ? Colors.blue : Colors.red,
//                 size: 28),
//             const SizedBox(width: 8),
//             Text(title,
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: message,
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             style: TextButton.styleFrom(foregroundColor: Colors.grey),
//             child: const Text("បោះបង់",
//                 style: TextStyle(fontSize: 16, color: Colors.black)),
//           ),
//           ElevatedButton.icon(
//             onPressed: () {
//               onConfirm(); // Execute the passed function
//             },
//             icon: type == DialogType.primary
//                 ? Icon(Icons.check, color: Colors.white)
//                 : Icon(Icons.delete, color: Colors.white),
//             label: const Text("បាទ/ចាស",
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white)),
//             style: ElevatedButton.styleFrom(
//               backgroundColor:
//                   type == DialogType.primary ? Colors.blue : Colors.red,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

// enum DialogType {
//   primary,
//   danger,
// }
import 'package:flutter/material.dart';

enum DialogType {
  primary,
  danger,
}

void showConfirmDialog(
  BuildContext context,
  String title,
  String message,
  DialogType type,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                // Icon and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.warning,
                    //   color: type == DialogType.primary ? Colors.blue : Colors.red,
                    //   size: 24,
                    // ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),

                // Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        onTap: isLoading ? null : () => Navigator.pop(context),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "បោះបង់",
                            style: TextStyle(
                              color: isLoading ? Colors.grey : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    // Confirm Button
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                        onTap: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  await Future(() => onConfirm());
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  setState(() => isLoading = false);
                                }
                              },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type == DialogType.primary ? Icons.check : Icons.delete,
                                      color: type == DialogType.primary ? Colors.blue : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "បាទ/ចាស",
                                      style: TextStyle(
                                        color: type == DialogType.primary ? Colors.blue : Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showErrorDialog(
  BuildContext context,
  String title,
) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // Error Icon
            // const Icon(
            //   Icons.warning_rounded,
            //   color: Colors.red,
            //   size: 48,
            // ),
            const SizedBox(height: 16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),

            // OK Button
            InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  "បិទ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showConfirmDialogWithNavigation(
  BuildContext context,
  String title,
  String message,
  DialogType type,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      bool isLoading = false;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),

                // Icon and Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.warning,
                    //   color: type == DialogType.primary ? Colors.blue : Colors.red,
                    //   size: 24,
                    // ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Message
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),

                // Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        onTap: isLoading ? null : () => Navigator.pop(context),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "បោះបង់",
                            style: TextStyle(
                              color: isLoading ? Colors.grey : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    // Confirm Button
                    Expanded(
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                        onTap: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                try {
                                  await Future(() => onConfirm());
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  setState(() => isLoading = false);
                                }
                              },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      type == DialogType.primary ? Icons.check : Icons.delete,
                                      color: type == DialogType.primary ? Colors.blue : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "បាទ/ចាស",
                                      style: TextStyle(
                                        color: type == DialogType.primary ? Colors.blue : Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showConfirmDialogWithNavigationOfSaleInvoice(
  BuildContext context,
  String title,
  Widget message,
  DialogType type,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),

            // Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon(
                //   Icons.warning,
                //   color: type == DialogType.primary ? Colors.blue : Colors.red,
                //   size: 24,
                // ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Custom Widget Message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: message,
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                    ),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        "បោះបង់",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 48,
                  color: Colors.grey.withOpacity(0.2),
                ),
                // Confirm Button
                Expanded(
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(16),
                    ),
                    onTap: () {
                      onConfirm();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            type == DialogType.primary ? Icons.check : Icons.delete,
                            color: type == DialogType.primary ? Colors.blue : Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "បាទ/ចាស",
                            style: TextStyle(
                              color: type == DialogType.primary ? Colors.blue : Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}