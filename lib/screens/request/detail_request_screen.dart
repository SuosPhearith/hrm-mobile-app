import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request/detail_request_provider.dart';
import 'package:mobile_app/services/request/detail_request_service.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:mobile_app/widgets/custom_header.dart';
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
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'ស្នើរសុំ | ${getSafeString(safeValue: '...', value: AppLang.translate(lang: settingProvider.lang ?? 'kh', data: data?['request']?['request_status']))}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                centerTitle: true,
                bottom: CustomHeader(),
              ),
              body: SafeArea(
                child: RefreshIndicator(
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
                                ...mapToList(data?['requesters'])
                                    .asMap()
                                    .entries
                                    .map(
                                  (entry) {
                                    int index = entry.key;
                                    var record = entry.value;
                                    bool isLastItem = index ==
                                        mapToList(data?['requesters']).length -
                                            1;

                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: isLastItem
                                              ? 0
                                              : 12), // Add spacing except for last item
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                            width: 1,
                                            color: Color(0xFFCBD5E1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
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
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    '${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record?['user']?['user_work']?['general_department'])} ',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
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
                                                          Icons
                                                              .phone_android_sharp,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ព័ត៌មានលម្អិត',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    provider.data?.data['request_permission']
                                                ?['allow_update'] ==
                                            true
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: HColors.darkgrey,
                                            ),
                                            onPressed: () {
                                              // Navigate to edit screen or show edit dialog
                                              context
                                                  .push(AppRoutes.updateRequest);
                                            },
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                // const SizedBox(height: 12),

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

                                Stack(
                                  children: [
                                    // Continuous vertical line
                                    Positioned(
                                      left:
                                          18, // Align with the center of the icon (icon size 24 / 2 + padding)
                                      top: 20,
                                      bottom: 0,
                                      child: Container(
                                        width: 2,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    // Timeline entries
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(), // Disable scrolling in ListView
                                      shrinkWrap:
                                          true, // Make ListView take only the space it needs
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      itemCount: mapToList(data?['request']
                                              ?['request_reviewers'])
                                          .length,
                                      itemBuilder: (context, index) {
                                        final record = mapToList(
                                            data?['request']
                                                ?['request_reviewers'])[index];
                                        return _timelineEntry(
                                          profileUrl:
                                              '${getSafeString(value: record?['user']?['avatar']?['file_domain'])}${getSafeString(value: record?['user']?['avatar']['uri'])}',
                                          title: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: record?['reviewer_type']),
                                          date: formatDateTime(
                                              record?['updated_at']),
                                          userName:
                                              '${getSafeString(value: record?['user']?['salute']?['name_kh'])} ${getSafeString(value: record?['user']?['name_kh'])}',
                                          role: AppLang.translate(
                                              lang:
                                                  settingProvider.lang ?? 'kh',
                                              data: record?['user']
                                                  ?['user_work']?['position']),
                                          content: record?['comment'],
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                // const SizedBox(height: 24),

                                // data?['request_permission']['allow_assign'] ==
                                //         true
                                //     ? Column(
                                //         children: [
                                //           Row(
                                //             children: [
                                //               Container(
                                //                 width: 36,
                                //                 height: 36,
                                //                 decoration: BoxDecoration(
                                //                     color: HColors.darkgrey
                                //                         .withOpacity(0.1),
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             50)),
                                //                 child: Icon(Icons.add,
                                //                     color: HColors.darkgrey),
                                //               ),
                                //               const SizedBox(width: 10),
                                //               const Text("ស្នើរសុំ",
                                //                   style: TextStyle(
                                //                       fontSize: 16,
                                //                       fontWeight:
                                //                           FontWeight.w500)),
                                //             ],
                                //           ),
                                //           // Group Sections
                                //           ...mapToList(
                                //                   dataSetup?['reviewer_types'])
                                //               .map((record) {
                                //             // Get selected users for this reviewer_type from state
                                //             final selectedUsers =
                                //                 selectedUsersByReviewerType[
                                //                         record['id']] ??
                                //                     [];
                                //             return Padding(
                                //               padding:
                                //                   const EdgeInsets.symmetric(
                                //                       vertical: 8.0),
                                //               child: _buildGroupSection(
                                //                 title:
                                //                     "${mapToList(selectedUsersByReviewerType[record['id']]).length} ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}",
                                //                 children:
                                //                     selectedUsers.map((user) {
                                //                   return _buildApprovalTile(
                                //                     imageUrl: user[
                                //                             'avatarUrl'] ??
                                //                         'lib/assets/images/pp.png',
                                //                     name: user['name'] ??
                                //                         'Unknown',
                                //                     position:
                                //                         user['department'] ??
                                //                             'No Position',
                                //                   );
                                //                 }).toList(),
                                //                 onAdd: () {
                                //                   _showSelectionBottomSheet(
                                //                     data: dataUsers!,
                                //                     context: context,
                                //                     title:
                                //                         'ជ្រើសរើស ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}',
                                //                     onSelected: (List<
                                //                             Map<String, String>>
                                //                         selectedUsers) {
                                //                       // Update state with selected users for this reviewer_type
                                //                       setState(() {
                                //                         selectedUsersByReviewerType[
                                //                                 record['id']] =
                                //                             selectedUsers;
                                //                       });
                                //                     },
                                //                   );
                                //                 },
                                //               ),
                                //             );
                                //           }),
                                //         ],
                                //       )
                                //     : const SizedBox.shrink(),
                                data?['request_permission']['allow_assign'] ==
                                        true
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                    color: HColors.darkgrey
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Icon(Icons.add,
                                                    color: HColors.darkgrey),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text("ស្នើរសុំ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ],
                                          ),
                                          // Group Sections
                                          ...mapToList(
                                                  dataSetup?['reviewer_types'])
                                              .map((record) {
                                            // Get selected users for this reviewer_type from state
                                            final selectedUsers =
                                                selectedUsersByReviewerType[
                                                        record['id']] ??
                                                    [];
                                            // More flexible name checking
                                            final nameEn =
                                                (record['name_en'] ?? '')
                                                    .toLowerCase();
                                            final nameKh =
                                                record['name_kh'] ?? '';
                                            // final isReviewer = nameEn
                                            //         .contains('review') ||
                                            //     nameKh.contains('ត្រួតពិនិត្យ');
                                            final isApprover =
                                                nameEn.contains('approv') ||
                                                    nameKh.contains('អនុម័ត');

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: _buildGroupSection(
                                                title:
                                                    "${mapToList(selectedUsersByReviewerType[record['id']]).length} ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}",
                                                children:
                                                    selectedUsers.map((user) {
                                                  return _buildApprovalTile(
                                                    imageUrl: user[
                                                            'avatarUrl'] ??
                                                        'lib/assets/images/pp.png',
                                                    name: user['name'] ??
                                                        'Unknown',
                                                    position:
                                                        user['department'] ??
                                                            'No Position',
                                                  );
                                                }).toList(),
                                                onAdd: () {
                                                  // Find reviewer type dynamically by checking names
                                                  final reviewerTypes =
                                                      mapToList(dataSetup?[
                                                          'reviewer_types']);
                                                  final reviewerType =
                                                      reviewerTypes.firstWhere(
                                                    (type) {
                                                      final nameEn =
                                                          (type['name_en'] ??
                                                                  '')
                                                              .toLowerCase();
                                                      final nameKh =
                                                          type['name_kh'] ?? '';
                                                      return nameEn.contains(
                                                              'review') ||
                                                          nameKh.contains(
                                                              'ត្រួតពិនិត្យ');
                                                    },
                                                    orElse: () => {'id': null},
                                                  );
                                                  final reviewerTypeId =
                                                      reviewerType['id'];

                                                  // Get assigned reviewer IDs to exclude from approver list
                                                  final assignedReviewerIds =
                                                      reviewerTypeId != null
                                                          ? (selectedUsersByReviewerType[
                                                                      reviewerTypeId] ??
                                                                  [])
                                                              .map((user) =>
                                                                  user['id']
                                                                      .toString())
                                                              .toSet()
                                                          : <String>{};

                                                  // Filter users based on type
                                                  List<Map<String, dynamic>>
                                                      filteredUsers =
                                                      dataUsers!;
                                                  if (isApprover) {
                                                    // For approver: exclude users already assigned as reviewers
                                                    filteredUsers = dataUsers
                                                        .where((user) =>
                                                            !assignedReviewerIds
                                                                .contains(user[
                                                                        'id']
                                                                    .toString()))
                                                        .toList();
                                                  }

                                                  _showSelectionBottomSheet(
                                                    data: filteredUsers,
                                                    context: context,
                                                    title:
                                                        'ជ្រើសរើស ${AppLang.translate(lang: settingProvider.lang ?? 'kh', data: record)}',
                                                    onSelected: (List<
                                                            Map<String, String>>
                                                        selectedUsers) {
                                                      // Update state with selected users for this reviewer_type
                                                      setState(() {
                                                        if (isApprover) {
                                                          // For approver: only allow one selection
                                                          selectedUsersByReviewerType[
                                                                  record[
                                                                      'id']] =
                                                              selectedUsers
                                                                  .take(1)
                                                                  .toList();
                                                        } else {
                                                          // For reviewer: allow multiple selections
                                                          selectedUsersByReviewerType[
                                                                  record[
                                                                      'id']] =
                                                              selectedUsers;
                                                        }
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
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              bottomNavigationBar: data?['request_permission']
                          ['allow_comment'] ==
                      true
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: HColors.darkgrey.withOpacity(0.1),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          top: 12.0,
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 12.0,
                        ),
                        child: SafeArea(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Profile picture (optional)
                              ClipOval(
                                child: Image.network(
                                  '${Provider.of<AuthProvider>(context, listen: false).profile?.data['user']['avatar']['file_domain']}${Provider.of<AuthProvider>(context, listen: false).profile?.data['user']['avatar']['uri']}',
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 40.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[600],
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.person,
                                          size: 30.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              // Comment input field
                              Expanded(
                                child: TextField(
                                  controller: _comment,
                                  minLines: 1,
                                  maxLines: 4,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 16.0,
                                    ),
                                    isDense: true,
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              // Send button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: _comment.text.trim().isEmpty
                                      ? null
                                      : () async {
                                          // Handle send comment

                                          try {
                                            final DetailRequestService service =
                                                DetailRequestService();

                                            await service.assign(
                                              requestId: widget.id ?? '',
                                              comment: _comment.text.trim(),
                                              reviewers:
                                                  convertSelectedUsersToReviewers(
                                                      selectedUsersByReviewerType),
                                            );
                                            _comment.clear();
                                            selectedUsersByReviewerType.clear();
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

                                          // Add your send logic here
                                        },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.send,
                                      size: 20,
                                      // color: _comment.text.trim().isEmpty
                                      //     ? Colors.grey[400]
                                      //     : Colors.blue,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
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
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.blue),
                    onPressed: onAdd,
                  ),
                ],
              ),
            ),
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
          color: HColors.darkgrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 22, backgroundImage: NetworkImage(imageUrl)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(position, style: TextStyle(color: HColors.darkgrey)),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
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
                        style: TextStyle(fontWeight: FontWeight.w400),
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
          Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: HColors.darkgrey.withOpacity(0.1)),
              child: Icon(icon, color: HColors.darkgrey, size: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(title,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ))),
                    if (trailing != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: HColors.bluegrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(trailing,
                            style: TextStyle(
                                fontSize: 12, color: HColors.bluegrey)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: HColors.darkgrey)),
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
      // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon positioned over the continuous line
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: HColors.darkgrey.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(50), // Large value = fully rounded
            ),
            child: Icon(
              icon,
              color: HColors.bluegrey,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                Text(
                  date,
                  style: TextStyle(color: HColors.darkgrey, fontSize: 12),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(profileUrl),
                      onBackgroundImageError: (_, __) => Container(
                          color: Colors.grey), // Fallback for image error
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            userName.isNotEmpty ? userName : 'Unknown User',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SizedBox(height: 5,),
                          if (role.isNotEmpty)
                            Text(
                              role,
                              style: TextStyle(
                                fontSize: 12,
                                color: HColors.darkgrey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (content != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFFCBD5E1),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      content,
                      softWrap: true,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                SizedBox(
                  height: 5,
                )
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
          insetPadding: EdgeInsets.zero, // Make it full screen
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SafeArea(
            child: StatefulBuilder(builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    // Header with title and close button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, size: 24.0),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, size: 24.0),
                            onPressed: selectedItems.value.isNotEmpty
                                ? () {
                                    onSelected(selectedItems.value);
                                    Navigator.pop(context);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Improved Search field
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Container(
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
                          controller: searchController,
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
                            suffixIcon: searchController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      searchController.clear();
                                      // Reset to original filtered data
                                      setState(() {
                                        staticData = data;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.clear_rounded,
                                        color: Colors.grey[500],
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.grey[300]!.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.blue.withOpacity(0.8),
                                width: 2,
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
                            setState(() {
                              if (value.isEmpty) {
                                staticData =
                                    data; // Reset to original filtered data
                              } else {
                                staticData = data.where((item) {
                                  final name = item['name_kh']
                                          ?.toString()
                                          .toLowerCase() ??
                                      '';
                                  return name.contains(value.toLowerCase());
                                }).toList();
                              }
                            });
                          },
                        ),
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
                          height: 100.0,
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

                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(28.0),
                                        child: CircleAvatar(
                                          radius: 28.0,
                                          backgroundImage: avatarUrl.isNotEmpty
                                              ? NetworkImage(avatarUrl)
                                              : null,
                                          backgroundColor: Colors.grey[300],
                                          child: avatarUrl.isEmpty
                                              ? Icon(
                                                  Icons.person,
                                                  size: 30,
                                                  color: Colors.grey[600],
                                                )
                                              : null,
                                        ),
                                      ),
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle close/remove action
                                            setState(() {
                                              selectedItems
                                                  .value = List.from(selected)
                                                ..removeWhere(
                                                    (s) => s['id'] == userId);
                                            });
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: HColors.darkgrey,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    userName,
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
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
                          final name = '${item['name_kh']}';
                          final department = item['user_work']['position']
                                  ['name_kh'] ??
                              'No Department';
                          final id = item['id'].toString();

                          return ValueListenableBuilder<
                              List<Map<String, String>>>(
                            valueListenable: selectedItems,
                            builder: (context, selected, _) {
                              final isSelected =
                                  selected.any((s) => s['id'] == id);

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedItems
                                            .value = List.from(selected)
                                          ..removeWhere((s) => s['id'] == id);
                                      } else {
                                        selectedItems.value =
                                            List.from(selected)
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 24.0,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                selectedItems
                                                    .value = List.from(selected)
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
                                          activeColor: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
