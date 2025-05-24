import 'package:flutter/material.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/request/detail_request_provider.dart';
import 'package:mobile_app/utils/help_util.dart';
import 'package:provider/provider.dart';

class DetailRequestScreen extends StatefulWidget {
  final String? id;
  const DetailRequestScreen({super.key, this.id});

  @override
  State<DetailRequestScreen> createState() => _DetailRequestScreenState();
}

class _DetailRequestScreenState extends State<DetailRequestScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
          return Scaffold(
            // backgroundColor: Colors.grey[100],
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
                                content:
                                    getSafeString(value: record?['comment']),
                              );
                            }),

                            const SizedBox(height: 24),

                            // Title + Date Section
                            Row(
                              children: [
                                Icon(Icons.add_circle, color: Colors.grey[600]),
                                const SizedBox(width: 10),
                                const Text("ស្នើរសុំ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: Text("03-01-2025 17:45",
                                  style: TextStyle(color: Colors.grey)),
                            ),

                            // User Info Section
                            _buildUserInfo(
                              imageUrl: 'lib/assets/images/pp.png',
                              name: 'សopha ម៉េងលឿត',
                              position: 'មន្ត្រីបច្ចេកទេស (ផ្នែកគ្រប់គ្រង)',
                            ),

                            // Group Sections
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildGroupSection("1 អ្នកអនុម័ត", [
                                _buildApprovalTile(
                                  imageUrl: 'lib/assets/images/pp.png',
                                  name: 'ហង ស៊ីន ចំរើន',
                                  position: 'អគ្គនាយកលក្ខណៈ (អនុ.គ្រប់)',
                                )
                              ]),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: _buildGroupSection("1 អ្នកត្រួតពិនិត្យ", [
                                _buildApprovalTile(
                                  imageUrl: 'lib/assets/images/pp.png',
                                  name: 'ហង ស៊ីន ចំរើន',
                                  position: 'អគ្គនាយក',
                                )
                              ]),
                            ),
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

  Widget _buildUserInfo(
      {required String imageUrl,
      required String name,
      required String position}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: 15,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(position, style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGroupSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
              Icon(Icons.add, color: Colors.blue),
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
            CircleAvatar(radius: 15, backgroundImage: AssetImage(imageUrl)),
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
              onPressed: () {},
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
    required String content,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        if (role.isNotEmpty)
                          Text(role,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(content),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
