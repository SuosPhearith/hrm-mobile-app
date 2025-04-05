import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Softer background
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'អំពីប្រព័ន្ធ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('អនុក្រឹត', Icons.edit_document),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.access_time,
                title: '08 ម៉ោង / ថ្ងៃ',
                subtitle: 'ម៉ោងធ្វើការ',
              ),
              _buildInfoTile(
                icon: Icons.calendar_month,
                title: '05 ថ្ងៃ / សប្តាហ៍',
                subtitle: 'ចំនួនថ្ងៃ',
              ),
              _buildInfoTile(
                icon: Icons.av_timer,
                title: '40 ម៉ោង / សប្តាហ៍',
                subtitle: 'ចំនួនម៉ោង',
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('ការស្កេនប្រចាំថ្ងៃ', Icons.face),
              const SizedBox(height: 12),
              _buildInfoTile(
                icon: Icons.login,
                title: '07:30AM',
                subtitle: 'ស្កេនចូល',
              ),
              _buildInfoTile(
                icon: Icons.logout,
                title: '05:50PM',
                subtitle: 'ស្កេនចេញ',
              ),
              _buildInfoTile(
                icon: Icons.message_outlined,
                title: 'លើកលែងម៉ោងបាយថ្ងៃត្រង់ 2 ម៉ោង',
                subtitle: 'សម្គាល់',
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('ម៉ាស៊ីនស្កេនមុខ', Icons.face),
              const SizedBox(height: 12),
              _buildScannerTile(
                title: 'Terminal 001',
                subtitle: '# FC002 | អគារ ក | ស្កេនចូល',
                status: 'សកម្ម',
                count: '12 ដង',
              ),
              _buildScannerTile(
                title: 'Terminal 001',
                subtitle: '# FC002 | អគារ ក | ស្កេនចូល',
                status: 'សកម្ម',
                count: '12 ដង',
              ),
              _buildScannerTile(
                title: 'Terminal 001',
                subtitle: '# FC002 | អគារ ក | ស្កេនចូល',
                status: 'សកម្ម',
                count: '12 ដង',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8.0),
        // Icon(
        //   icon,
        //   size: 24.0,
        //   color: Colors.blue[700],
        // ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24.0,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerTile({
    required String title,
    required String subtitle,
    required String status,
    required String count,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.face,
                      size: 24.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[200]!],
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                count,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
