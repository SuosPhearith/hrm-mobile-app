// import 'package:flutter/material.dart';
// import 'package:mobile_app/app_lang.dart';
// import 'package:mobile_app/providers/global/setting_provider.dart';
// import 'package:mobile_app/providers/local/request/detail_request_provider.dart';
// import 'package:mobile_app/services/request/detail_request_service.dart';
// import 'package:mobile_app/utils/help_util.dart';
// import 'package:provider/provider.dart';

// class DetailRequestScreen extends StatefulWidget {
//   final String? id;
//   const DetailRequestScreen({super.key, this.id});

//   @override
//   State<DetailRequestScreen> createState() => _DetailRequestScreenState();
// }

// class _DetailRequestScreenState extends State<DetailRequestScreen> {
//   final TextEditingController _comment = TextEditingController();
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();
//   Future<void> _refreshData(DetailRequestProvider provider) async {
//     return await provider.getHome(id: widget.id ?? "");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DetailRequestProvider(id: widget.id ?? ""),
//       child: Consumer2<DetailRequestProvider, SettingProvider>(
//         builder: (context, provider, settingProvider, child) {
//           final data = provider.data?.data;
//           final dataSetup = provider.dataSetup?.data;
//           final dataUsers = provider.users?.data.results;
//           return Scaffold(
//             // backgroundColor: Colors.grey[100],
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: Text(
//                   'ស្នើរសុំ | ${getSafeString(safeValue: '...', value: AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']?['request_status']))}'),
//               centerTitle: true,
//             ),
//             body: RefreshIndicator(
//               key: _refreshIndicatorKey,
//               color: Colors.blue[800],
//               backgroundColor: Colors.white,
//               onRefresh: () => _refreshData(provider),
//               child: provider.isLoading
//                   ? Center(child: Text('Loading...'))
//                   : SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // User Profile Card
//                             ...mapToList(data?['requesters']).map(
//                               (record) {
//                                 return Card(
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(12)),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8),
//                                     child: Row(
//                                       children: [
//                                         CircleAvatar(
//                                             radius: 30,
//                                             backgroundImage: NetworkImage(
//                                                 '${record?['user']['avatar']?['file_domain']}${record?['user']['avatar']['uri']}')),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 '${getSafeString(safeValue: '...', value: record?['user']?['name_kh'])} (${getSafeString(safeValue: '...', value: record?['user']?['name_en'])})',
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                               Text(
//                                                 '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record?['user']?['user_work']?['general_department'])} ',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                               Wrap(
//                                                 crossAxisAlignment:
//                                                     WrapCrossAlignment.center,
//                                                 spacing: 8,
//                                                 runSpacing: 4,
//                                                 children: [
//                                                   Icon(Icons.star_border,
//                                                       size: 16),
//                                                   Text(
//                                                     '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record?['user']?['user_work']?['staff_type'])} |',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                   Text(
//                                                     '# ${getSafeString(value: record?['user']?['user_work']?['id_number'])} |',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                   Icon(
//                                                       Icons.phone_android_sharp,
//                                                       size: 16),
//                                                   Text(
//                                                     '${getSafeString(value: record?['user']?['phone_number'])} ',
//                                                     style: TextStyle(
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),

//                             const SizedBox(height: 16),
//                             // Timeline
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text('ព័ត៌មានលម្អិត',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium),
//                                 Icon(
//                                   Icons.edit,
//                                   color: Colors.grey[600],
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 12),

//                             // Leave Info
//                             _infoRow(
//                                 Icons.calendar_today,
//                                 '${getSafeString(value: formatDate(data?['request']['start_datetime']))} ដល់ ${getSafeString(value: formatDate(data?['request']['end_datetime']))}',
//                                 'កាលបរិច្ឆេទ',
//                                 trailing:
//                                     '${getSafeInteger(value: data?['request']['num_day'])} ថ្ងៃ'),
//                             _infoRow(
//                                 Icons.category,
//                                 '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']['request_category'])} (${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']['request_type'])})',
//                                 'ប្រភេទ'),
//                             _infoRow(
//                                 Icons.chat_bubble_outline,
//                                 getSafeString(
//                                     value: data?['request']['objective']),
//                                 'មូលហេតុ'),
//                             _infoRow(Icons.picture_as_pdf,
//                                 'ឯកសារភ្ជាប់ស្នើសុំ.pdf', 'ឯកសារភ្ជាប់'),
//                             _infoRowWithAvatar(
//                               '${getSafeString(value: data?['request']?['creator']?['avatar']?['file_domain'])}${getSafeString(value: data?['request']?['creator']['avatar']['uri'])}',
//                               '${getSafeString(value: data?['request']?['creator']?['name_kh'])} (${getSafeString(value: data?['request']?['creator']?['name_en'])})',
//                               'អ្នកបង្កើត',
//                             ),

//                             ...mapToList(data?['request']?['request_reviewers'])
//                                 .map((record) {
//                               return _timelineEntry(
//                                 profileUrl:
//                                     '${getSafeString(value: record?['user']?['avatar']?['file_domain'])}${getSafeString(value: record?['user']?['avatar']['uri'])}',
//                                 title: AppLang.translate(
//                                     lang: settingProvider.lang ?? 'kh',
//                                     data: record?['reviewer_type']),
//                                 date: formatDateTime(record?['updated_at']),
//                                 userName:
//                                     '${getSafeString(value: record?['user']?['salute']?['name_kh'])} ${getSafeString(value: record?['user']?['name_kh'])} (${getSafeString(value: record?['user']?['name_en'])})',
//                                 role: AppLang.translate(
//                                     lang: settingProvider.lang ?? 'kh',
//                                     data: record?['user']?['user_work']
//                                         ?['position']),
//                                 content: record?['comment'],
//                               );
//                             }),

//                             const SizedBox(height: 24),

//                             data?['request_permission']['allow_assign'] != null
//                                 ? Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(Icons.add_circle,
//                                               color: Colors.grey[600]),
//                                           const SizedBox(width: 10),
//                                           const Text("ស្នើរសុំ",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold)),
//                                         ],
//                                       ),
//                                       // Group Sections
//                                       ...mapToList(dataSetup?['reviewer_types'])
//                                           .map((record) {
//                                         return Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               vertical: 8.0),
//                                           child: _buildGroupSection(
//                                               title:
//                                                   "1 ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}",
//                                               children: [
//                                                 // this is loop of each user
//                                                 _buildApprovalTile(
//                                                   imageUrl:
//                                                       'lib/assets/images/pp.png',
//                                                   name: 'ហង ស៊ីន ចំរើន',
//                                                   position:
//                                                       'អគ្គនាយកលក្ខណៈ (អនុ.គ្រប់)',
//                                                 )
//                                               ],
//                                               onAdd: () {
//                                                 _showSelectionBottomSheet(
//                                                   data: dataUsers!,
//                                                   context: context,
//                                                   title: 'Select Users',
//                                                   onSelected:
//                                                       (List<Map<String, String>>
//                                                           selectedUsers) {
//                                                     print(
//                                                         'Selected users: $selectedUsers');
//                                                   },
//                                                 );
//                                               }),
//                                         );
//                                       }),
//                                     ],
//                                   )
//                                 : const SizedBox.shrink(),

//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _buildTextField(
//                                     controller: _comment,
//                                     label: "Comment",
//                                     validator: (value) => value!.isEmpty
//                                         ? AppLang.translate(
//                                             lang: settingProvider.lang ?? 'kh',
//                                             key: 'please enter name_en')
//                                         : null,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey),
//                                       borderRadius: BorderRadius.circular(12)),
//                                   child: IconButton(
//                                     icon: Icon(Icons.send,
//                                         color: _comment.text.trim().isNotEmpty
//                                             ? Colors.indigo[400]
//                                             : Colors.grey[400]),
//                                     onPressed: _comment.text.trim().isNotEmpty
//                                         ? () {
//                                             // Handle send action here
//                                             print(
//                                                 'Sent comment: ${_comment.text.trim()}');
//                                             _comment.clear();
//                                           }
//                                         : null,
//                                   ),
//                                 ),
//                               ],
//                             )

//                             // Title + Date Section
//                           ],
//                         ),
//                       ),
//                     ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     String? Function(String?)? validator,
//     bool readOnly = false,
//     VoidCallback? onTap,
//     Widget? suffixIcon,
//     int maxLines = 1,
//   }) {
//     return TextFormField(
//       controller: controller,
//       readOnly: readOnly,
//       onTap: onTap,
//       validator: validator,
//       maxLines: maxLines,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.blueGrey),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(color: Colors.blueGrey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(
//               color: Theme.of(context).colorScheme.primary, width: 2.0),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
//         ),
//         suffixIcon: suffixIcon,
//         filled: true,
//       ),
//     );
//   }

//   Widget _buildGroupSection({
//     required String title,
//     required List<Widget> children,
//     required VoidCallback onAdd, // Added callback parameter
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 35),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add, color: Colors.blue),
//                 onPressed: onAdd, // Call the callback when tapped
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 8),
//         ...children,
//       ],
//     );
//   }

//   Widget _buildApprovalTile(
//       {required String imageUrl,
//       required String name,
//       required String position}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 35),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(radius: 15, backgroundImage: AssetImage(imageUrl)),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(name,
//                       style: const TextStyle(fontWeight: FontWeight.bold)),
//                   Text(position, style: const TextStyle(color: Colors.grey)),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {},
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _infoRowWithAvatar(String avatarUrl, String title, String subtitle,
//       {String? trailing}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 12,
//             backgroundImage: NetworkImage(avatarUrl),
//             backgroundColor: Colors.grey[300],
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     if (trailing != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.indigo[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           trailing,
//                           style: TextStyle(fontSize: 12, color: Colors.indigo),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: TextStyle(color: Colors.grey[600])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String title, String subtitle,
//       {String? trailing}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Colors.grey[700], size: 24),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                         child: Text(title,
//                             style: TextStyle(fontWeight: FontWeight.w600))),
//                     if (trailing != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.indigo[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(trailing,
//                             style:
//                                 TextStyle(fontSize: 12, color: Colors.indigo)),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(subtitle, style: TextStyle(color: Colors.grey[600])),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _timelineEntry({
//     required String profileUrl,
//     String? title,
//     required String date,
//     required String userName,
//     required String role,
//     String? content,
//     IconData icon = Icons.star,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Column(
//             children: [
//               Icon(icon, color: Colors.indigo[400]),
//               Container(height: 40, width: 2, color: Colors.grey[300]),
//             ],
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title!,
//                     style: TextStyle(color: Colors.grey[600], fontSize: 16)),
//                 Text(date,
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 14,
//                       backgroundImage: NetworkImage(profileUrl),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       // Constrain the Column to prevent overflow
//                       child: Column(
//                         crossAxisAlignment:
//                             CrossAxisAlignment.start, // Changed from stretch
//                         children: [
//                           Text(
//                             userName.isNotEmpty ? userName : 'Unknown User',
//                             style: const TextStyle(fontWeight: FontWeight.w600),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           if (role.isNotEmpty)
//                             Text(
//                               role,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 content != null
//                     ? Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           content,
//                           softWrap: true,
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _showSelectionBottomSheet({
//     required List<Map<String, dynamic>> data,
//     required BuildContext context,
//     required String title,
//     required Function(List<Map<String, String>>) onSelected,
//   }) async {
//     List<Map<String, dynamic>> staticData = data;

//     final TextEditingController searchController = TextEditingController();
//     final ValueNotifier<List<Map<String, String>>> selectedItems =
//         ValueNotifier([]);

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(0),
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               return Column(
//                 children: [
//                   // Header with title and close button
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close, size: 24.0),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Selected users
//                   ValueListenableBuilder<List<Map<String, String>>>(
//                     valueListenable: selectedItems,
//                     builder: (context, selected, _) {
//                       if (selected.isEmpty) {
//                         return const SizedBox.shrink();
//                       }
//                       return Container(
//                         height: 60.0,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: selected.length,
//                           separatorBuilder: (context, index) =>
//                               const SizedBox(width: 8.0),
//                           itemBuilder: (context, index) {
//                             final selectedUser = selected[index];
//                             final userId = selectedUser['id']!;
//                             final userName = selectedUser['name']!;
//                             final userData = staticData.firstWhere(
//                               (item) => item['id'].toString() == userId,
//                               orElse: () => {},
//                             );
//                             final avatarUrl = userData.isNotEmpty
//                                 ? '${userData['avatar']['file_domain']}${userData['avatar']['uri']}'
//                                 : '';

//                             return Chip(
//                               avatar: CircleAvatar(
//                                 radius: 14.0,
//                                 backgroundImage: avatarUrl.isNotEmpty
//                                     ? NetworkImage(avatarUrl)
//                                     : null,
//                                 backgroundColor: Colors.grey[300],
//                               ),
//                               label: Text(
//                                 userName,
//                                 style: const TextStyle(fontSize: 14.0),
//                               ),
//                               deleteIcon: const Icon(Icons.close, size: 18.0),
//                               onDeleted: () {
//                                 setState(() {
//                                   selectedItems.value = List.from(selected)
//                                     ..removeWhere((s) => s['id'] == userId);
//                                 });
//                               },
//                               backgroundColor: Colors.grey[100],
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 side: BorderSide(color: Colors.grey[300]!),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                   // Search field (non-functional)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 16.0, vertical: 8.0),
//                     child: TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search users...',
//                         hintStyle: TextStyle(color: Colors.grey[600]),
//                         prefixIcon:
//                             const Icon(Icons.search, color: Colors.grey),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                       ),
//                       onChanged: (value) async {
//                         final DetailRequestService detailRequestService =
//                             DetailRequestService();
//                         final resUser =
//                             await detailRequestService.users(key: value);
//                         setState(() {
//                           staticData = resUser.data.results;
//                         });
//                       },
//                     ),
//                   ),
//                   // User list
//                   Expanded(
//                     child: ListView.separated(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 12.0),
//                       itemCount: staticData.length,
//                       separatorBuilder: (context, index) =>
//                           const SizedBox(height: 8.0),
//                       itemBuilder: (context, index) {
//                         final item = staticData[index];
//                         final avatarUrl =
//                             '${item['avatar']['file_domain']}${item['avatar']['uri']}';
//                         final name = '${item['name_kh']}(${item['name_en']})';
//                         final department = item['user_work']['position']
//                                 ['name_kh'] ??
//                             'No Department';
//                         final id = item['id'].toString();

//                         return ValueListenableBuilder<
//                             List<Map<String, String>>>(
//                           valueListenable: selectedItems,
//                           builder: (context, selected, _) {
//                             final isSelected =
//                                 selected.any((s) => s['id'] == id);

//                             return Material(
//                               color: Colors.transparent,
//                               child: InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedItems.value = List.from(selected)
//                                         ..removeWhere((s) => s['id'] == id);
//                                     } else {
//                                       selectedItems.value = List.from(selected)
//                                         ..add({
//                                           'id': id,
//                                           'name': name,
//                                           'department': department
//                                         });
//                                     }
//                                   });
//                                 },
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color:
//                                         Theme.of(context).colorScheme.surface,
//                                     borderRadius: BorderRadius.circular(16.0),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Colors.indigo[400]!
//                                           : Colors.grey,
//                                       width: isSelected ? 2.0 : 1.0,
//                                     ),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 16.0, vertical: 12.0),
//                                     child: Row(
//                                       children: [
//                                         CircleAvatar(
//                                           radius: 20.0,
//                                           backgroundImage:
//                                               NetworkImage(avatarUrl),
//                                           backgroundColor: Colors.grey[300],
//                                         ),
//                                         const SizedBox(width: 12.0),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 name,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .bodyLarge
//                                                     ?.copyWith(
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: Theme.of(context)
//                                                           .colorScheme
//                                                           .onSurface,
//                                                     ),
//                                               ),
//                                               const SizedBox(height: 4.0),
//                                               Text(
//                                                 department,
//                                                 style: TextStyle(
//                                                   fontSize: 14.0,
//                                                   color: Colors.grey[600],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Checkbox(
//                                           value: isSelected,
//                                           onChanged: (value) {
//                                             setState(() {
//                                               if (value == true) {
//                                                 selectedItems.value =
//                                                     List.from(selected)
//                                                       ..add({
//                                                         'id': id,
//                                                         'name': name,
//                                                         'department': department
//                                                       });
//                                               } else {
//                                                 selectedItems.value =
//                                                     List.from(selected)
//                                                       ..removeWhere(
//                                                           (s) => s['id'] == id);
//                                               }
//                                             });
//                                           },
//                                           activeColor: Colors.indigo[400],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   // Confirm button
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: ElevatedButton(
//                       onPressed: selectedItems.value.isNotEmpty
//                           ? () {
//                               onSelected(selectedItems.value);
//                               Navigator.pop(context);
//                             }
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo[400],
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size(double.infinity, 48.0),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                       ),
//                       child: const Text('Confirm Selection'),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request/detail_request_provider.dart';
import 'package:mobile_app/services/request/detail_request_service.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:provider/provider.dart';

class DetailRequestScreen extends StatefulWidget {
  final String? id;
  const DetailRequestScreen({super.key, this.id});

  @override
  State<DetailRequestScreen> createState() => _DetailRequestScreenState();
}

class _DetailRequestScreenState extends State<DetailRequestScreen> {
  final TextEditingController _comment = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  // State to store selected users for each reviewer_type
  final Map<int, List<Map<String, String>>> selectedUsersByReviewerType = {};

  Future<void> _refreshData(DetailRequestProvider provider) async {
    return await provider.getHome(id: widget.id ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailRequestProvider(id: widget.id ?? ""),
      child: Consumer2<DetailRequestProvider, SettingProvider>(
        builder: (context, provider, settingProvider, child) {
          final data = provider.data?.data;
          final dataSetup = provider.dataSetup?.data;
          final dataUsers = provider.users?.data.results;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                  'ស្នើរសុំ | ${getSafeString(safeValue: '...', value: AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']?['request_status']))}'),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Profile Card
                            ...mapToList(data?['requesters']).map(
                              (record) {
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                '${record?['user']['avatar']?['file_domain']}${record?['user']['avatar']['uri']}')),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${getSafeString(safeValue: '...', value: record?['user']?['name_kh'])} (${getSafeString(safeValue: '...', value: record?['user']?['name_en'])})',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record?['user']?['user_work']?['general_department'])} ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Wrap(
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                spacing: 8,
                                                runSpacing: 4,
                                                children: [
                                                  Icon(Icons.star_border,
                                                      size: 16),
                                                  Text(
                                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record?['user']?['user_work']?['staff_type'])} |',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    '# ${getSafeString(value: record?['user']?['user_work']?['id_number'])} |',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Icon(
                                                      Icons.phone_android_sharp,
                                                      size: 16),
                                                  Text(
                                                    '${getSafeString(value: record?['user']?['phone_number'])} ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                            // Timeline
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ព័ត៌មានលម្អិត',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Icon(
                                  Icons.edit,
                                  color: Colors.grey[600],
                                )
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Leave Info
                            _infoRow(
                                Icons.calendar_today,
                                '${getSafeString(value: formatDate(data?['request']['start_datetime']))} ដល់ ${getSafeString(value: formatDate(data?['request']['end_datetime']))}',
                                'កាលបរិច្ឆេទ',
                                trailing:
                                    '${getSafeInteger(value: data?['request']['num_day'])} ថ្ងៃ'),
                            _infoRow(
                                Icons.category,
                                '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']['request_category'])} (${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']['request_type'])})',
                                'ប្រភេទ'),
                            _infoRow(
                                Icons.chat_bubble_outline,
                                getSafeString(
                                    value: data?['request']['objective']),
                                'មូលហេតុ'),
                            _infoRow(Icons.picture_as_pdf,
                                'ឯកសារភ្ជាប់ស្នើសុំ.pdf', 'ឯកសារភ្ជាប់'),
                            _infoRowWithAvatar(
                              '${getSafeString(value: data?['request']?['creator']?['avatar']?['file_domain'])}${getSafeString(value: data?['request']?['creator']['avatar']['uri'])}',
                              '${getSafeString(value: data?['request']?['creator']?['name_kh'])} (${getSafeString(value: data?['request']?['creator']?['name_en'])})',
                              'អ្នកបង្កើត',
                            ),

                            ...mapToList(data?['request']?['request_reviewers'])
                                .map((record) {
                              return _timelineEntry(
                                profileUrl:
                                    '${getSafeString(value: record?['user']?['avatar']?['file_domain'])}${getSafeString(value: record?['user']?['avatar']['uri'])}',
                                title: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    data: record?['reviewer_type']),
                                date: formatDateTime(record?['updated_at']),
                                userName:
                                    '${getSafeString(value: record?['user']?['salute']?['name_kh'])} ${getSafeString(value: record?['user']?['name_kh'])} (${getSafeString(value: record?['user']?['name_en'])})',
                                role: AppLang.translate(
                                    lang: settingProvider.lang ?? 'kh',
                                    data: record?['user']?['user_work']
                                        ?['position']),
                                content: record?['comment'],
                              );
                            }),

                            const SizedBox(height: 24),

                            data?['request_permission']['allow_assign'] == true
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.add_circle,
                                              color: Colors.grey[600]),
                                          const SizedBox(width: 10),
                                          const Text("ស្នើរសុំ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      // Group Sections
                                      ...mapToList(dataSetup?['reviewer_types'])
                                          .map((record) {
                                        // Get selected users for this reviewer_type from state
                                        final selectedUsers =
                                            selectedUsersByReviewerType[
                                                    record['id']] ??
                                                [];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: _buildGroupSection(
                                            title:
                                                "${mapToList(selectedUsersByReviewerType[record['id']]).length} ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}",
                                            children: selectedUsers.map((user) {
                                              return _buildApprovalTile(
                                                imageUrl: user['avatarUrl'] ??
                                                    'lib/assets/images/pp.png',
                                                name: user['name'] ?? 'Unknown',
                                                position: user['department'] ??
                                                    'No Position',
                                              );
                                            }).toList(),
                                            onAdd: () {
                                              _showSelectionBottomSheet(
                                                data: dataUsers!,
                                                context: context,
                                                title:
                                                    'Select Users for ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}',
                                                onSelected:
                                                    (List<Map<String, String>>
                                                        selectedUsers) {
                                                  // Update state with selected users for this reviewer_type
                                                  setState(() {
                                                    selectedUsersByReviewerType[
                                                            record['id']] =
                                                        selectedUsers;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                                : const SizedBox.shrink(),

                            data?['request_permission']['allow_comment'] == true
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _comment,
                                          minLines: 3,
                                          maxLines: 5,
                                          decoration: InputDecoration(
                                            hintText:
                                                'Enter your comment here...',
                                            labelText: 'Comment',
                                            labelStyle: TextStyle(
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 1.5,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Colors.grey[300]!,
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              borderSide: BorderSide(
                                                color: Colors.blueAccent,
                                                width: 2.0,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 16.0,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: IconButton(
                                          icon: Icon(Icons.send,
                                              color: Colors.blueAccent),
                                          onPressed: () async {
                                            try {
                                              final DetailRequestService
                                                  service =
                                                  DetailRequestService();

                                              await service.assign(
                                                requestId: widget.id ?? '',
                                                comment: _comment.text.trim(),
                                                reviewers:
                                                    convertSelectedUsersToReviewers(
                                                        selectedUsersByReviewerType),
                                              );
                                              _comment.clear();
                                              selectedUsersByReviewerType
                                                  .clear();
                                              await provider.getHome(
                                                  id: widget.id ?? '');
                                            } catch (e) {
                                              // Optionally show a user-friendly error message (e.g., using a SnackBar in Flutter)
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to assign request: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGroupSection({
    required String title,
    required List<Widget> children,
    required VoidCallback onAdd,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: onAdd,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildApprovalTile(
      {required String imageUrl,
      required String name,
      required String position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 15, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(position, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Remove the user from the state
                setState(() {
                  selectedUsersByReviewerType.forEach((key, users) {
                    users.removeWhere((user) => user['name'] == name);
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _infoRowWithAvatar(String avatarUrl, String title, String subtitle,
      {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (trailing != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          trailing,
                          style: TextStyle(fontSize: 12, color: Colors.indigo),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle,
      {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.grey[700], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(title,
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    if (trailing != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(trailing,
                            style:
                                TextStyle(fontSize: 12, color: Colors.indigo)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineEntry({
    required String profileUrl,
    String? title,
    required String date,
    required String userName,
    required String role,
    String? content,
    IconData icon = Icons.star,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: Colors.indigo[400]),
              Container(height: 40, width: 2, color: Colors.grey[300]),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                Text(date,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(profileUrl),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName.isNotEmpty ? userName : 'Unknown User',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (role.isNotEmpty)
                            Text(
                              role,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                content != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          content,
                          softWrap: true,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionBottomSheet({
    required List<Map<String, dynamic>> data,
    required BuildContext context,
    required String title,
    required Function(List<Map<String, String>>) onSelected,
  }) async {
    List<Map<String, dynamic>> staticData = data;

    final TextEditingController searchController = TextEditingController();
    final ValueNotifier<List<Map<String, String>>> selectedItems =
        ValueNotifier([]);

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(0),
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                // Header with title and close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 24.0),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Selected users
                ValueListenableBuilder<List<Map<String, String>>>(
                  valueListenable: selectedItems,
                  builder: (context, selected, _) {
                    if (selected.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      height: 60.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: selected.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8.0),
                        itemBuilder: (context, index) {
                          final selectedUser = selected[index];
                          final userId = selectedUser['id']!;
                          final userName = selectedUser['name']!;
                          final userData = staticData.firstWhere(
                            (item) => item['id'].toString() == userId,
                            orElse: () => {},
                          );
                          final avatarUrl = userData.isNotEmpty
                              ? '${userData['avatar']['file_domain']}${userData['avatar']['uri']}'
                              : '';

                          return Chip(
                            avatar: CircleAvatar(
                              radius: 14.0,
                              backgroundImage: avatarUrl.isNotEmpty
                                  ? NetworkImage(avatarUrl)
                                  : null,
                              backgroundColor: Colors.grey[300],
                            ),
                            label: Text(
                              userName,
                              style: const TextStyle(fontSize: 14.0),
                            ),
                            deleteIcon: const Icon(Icons.close, size: 18.0),
                            onDeleted: () {
                              setState(() {
                                selectedItems.value = List.from(selected)
                                  ..removeWhere((s) => s['id'] == userId);
                              });
                            },
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (value) async {
                      final DetailRequestService detailRequestService =
                          DetailRequestService();
                      final resUser =
                          await detailRequestService.users(key: value);
                      setState(() {
                        staticData = resUser.data.results;
                      });
                    },
                  ),
                ),
                // User list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    itemCount: staticData.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8.0),
                    itemBuilder: (context, index) {
                      final item = staticData[index];
                      final avatarUrl =
                          '${item['avatar']['file_domain']}${item['avatar']['uri']}';
                      final name = '${item['name_kh']}(${item['name_en']})';
                      final department = item['user_work']['position']
                              ['name_kh'] ??
                          'No Department';
                      final id = item['id'].toString();

                      return ValueListenableBuilder<List<Map<String, String>>>(
                        valueListenable: selectedItems,
                        builder: (context, selected, _) {
                          final isSelected = selected.any((s) => s['id'] == id);

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedItems.value = List.from(selected)
                                      ..removeWhere((s) => s['id'] == id);
                                  } else {
                                    selectedItems.value = List.from(selected)
                                      ..add({
                                        'id': id,
                                        'name': name,
                                        'department': department,
                                        'avatarUrl': avatarUrl
                                      });
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.indigo[400]!
                                        : Colors.grey,
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.0,
                                        backgroundImage:
                                            NetworkImage(avatarUrl),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
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
                                            const SizedBox(height: 4.0),
                                            Text(
                                              department,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedItems.value =
                                                  List.from(selected)
                                                    ..add({
                                                      'id': id,
                                                      'name': name,
                                                      'department': department,
                                                      'avatarUrl': avatarUrl
                                                    });
                                            } else {
                                              selectedItems.value =
                                                  List.from(selected)
                                                    ..removeWhere(
                                                        (s) => s['id'] == id);
                                            }
                                          });
                                        },
                                        activeColor: Colors.indigo[400],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Confirm button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: selectedItems.value.isNotEmpty
                        ? () {
                            onSelected(selectedItems.value);
                            Navigator.pop(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[400],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text('Confirm Selection'),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}
