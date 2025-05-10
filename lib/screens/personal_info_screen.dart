import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/local/personal_info_provider.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData(PersonalInfoProvider provider) async {
    return await provider.getHome();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PersonalInfoProvider(),
      child: Consumer2<PersonalInfoProvider, SettingProvider>(
        builder: (context, evaluateProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('Personal info'),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child: evaluateProvider.isLoading
                  ? Center(child: Text('Loading...'))
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          buildContainer(
                            text: 'រូបភាព',
                            onEditTap: () => {},
                          ),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 48.0,
                                backgroundImage: NetworkImage(
                                    'https://file-v4-api.uat.camcyber.com/upload/file/49892209-72de-401d-9722-73f5501344d0'),
                              ),
                            ),
                          ),
                          buildContainer(
                            text: 'ព័ត៌មានផ្ទាល់ខ្លួន',
                            onEditTap: () => {},
                          ),
                          buildProfileContainer(
                            name: 'ឃួច កឿន (KHOUCH KOEUN)',
                            description: 'ប្រុស',
                            icon: Icons.face,
                          ),
                          buildProfileContainer(
                            name: 'ឃួច កឿន (KHOUCH KOEUN)',
                            description: 'ប្រុស',
                            icon: Icons.face,
                          ),
                          buildContainer(
                            text: 'គ្រួសារ និងសាចញាតិ',
                          ),
                          buildIconTextContainer(
                            text: 'អ្នកប្រើប្រាស់ សម្រាប់បាយ',
                            icon: Icons.group,
                          ),
                          buildProfileContainerAction(
                            name: 'ឃួច ទីទ្ធ (khouch tith)',
                            description:
                                '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                            icon: Icons.person,
                          ),
                          buildContainer(
                            text: 'ការសិក្សា',
                          ),
                          buildIconTextContainer(
                            text: 'អ្នកប្រើប្រាស់ សម្រាប់បាយ',
                            icon: Icons.group,
                          ),
                          buildProfileContainerAction(
                            name: 'ឃួច ទីទ្ធ (khouch tith)',
                            description:
                                '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                            icon: Icons.person,
                          ),
                          buildContainer(
                            text: 'កម្រិតភាសា',
                          ),
                          buildProfileContainerAction(
                            name: 'ឃួច ទីទ្ធ (khouch tith)',
                            description:
                                '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                            icon: Icons.person,
                          ),
                          buildProfileContainerAction(
                            name: 'ឃួច ទីទ្ធ (khouch tith)',
                            description:
                                '01-01-1965 (60 ឆ្នាំ) • នារីជនជាតិខ្មែរ • សញ្ញាតិ ABA\nភេទ: ស្ត្រី',
                            icon: Icons.person,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      )),
            ),
          );
        },
      ),
    );
  }

  Widget buildIconTextContainer({
    required String text,
    IconData icon = Icons.group,
    Color textColor = Colors.blueGrey,
    Color iconColor = Colors.grey,
    Color? avatarColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: avatarColor ?? Colors.grey[300],
            child: Icon(icon, size: 20.0, color: iconColor),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0, color: textColor),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContainer({
    required String text,
    VoidCallback? onEditTap, // Made optional with nullable type
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(width: 8.0),
          Icon(Icons.info_outline, size: 20.0, color: Colors.grey),
          Spacer(),
          // Only show edit icon if onEditTap is provided
          if (onEditTap != null)
            GestureDetector(
              onTap: onEditTap,
              child: Icon(Icons.edit, size: 20.0, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget buildProfileContainer({
    required String name,
    required String description,
    IconData icon = Icons.person, // Default icon is person
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .start, // Align to top so avatar stays at top when text wraps
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[300],
            child: Icon(icon, size: 20.0, color: Colors.grey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            // Expanded to allow text to fill available space
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  softWrap: true, // Allow text to wrap to multiple lines
                ),
                SizedBox(
                    height: 2.0), // Small spacing between name and description
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  softWrap: true, // Allow text to wrap to multiple lines
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileContainerAction({
    required String name,
    required String description,
    IconData icon = Icons.person, // Default icon is person
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[300],
            child: Icon(icon, size: 20.0, color: Colors.grey),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  softWrap: true,
                ),
                SizedBox(height: 2.0),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                  softWrap: true,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 20.0, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
