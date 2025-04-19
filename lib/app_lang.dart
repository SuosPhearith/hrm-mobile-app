class AppLang {
  static const Map<String, String> _english = {
    'greeting': 'Hello',
    'request': 'Request',
    // Home ================================================
    'home_today': 'Daily',
    'home_monthly': 'Monthly',
    'home_request': 'Request',
    'home_review': 'Review',
    'home_total_working_hours': 'Total Working Hours',
    'home_grade_received': 'Grade Received',
    'home_scan': 'Scan',
    'home_daily': 'Daily',
    'home_evaluation': 'Evaluation',
    'home_personal_info': 'Personal Info',
    'home_job': 'Job',
    'home_salary': 'Salary',
    'home_id_card': 'ID Card',
    'home_document': 'Document',
    'home_no_name': 'No Name',
    'home_no_department': 'No Department',
    'hour': 'H',
    'minute': 'M',
    // About ================================================
    'about_system': 'About System',
    'about_rule': 'Rule',
    'about_daily_scan': 'Daily Scan',
    'about_face_scanner': 'Face Scanner',
    'about_working_hours': 'Working Hours',
    'about_number_of_days': 'Number of Days',
    'about_total_hours': 'Total Hours',
    'about_scan_in': 'Scan In',
    'about_scan_out': 'Scan Out',
    'about_note': 'Note',
    'about_active': 'Active',
    'about_hours': 'Hours',
    'about_day': 'Day',
    'about_week': 'Week',
    'about_lunch_break': 'Lunch Break Exemption 2 Hours',
    // Layout ================================================
    'layout_home': 'Home',
    'layout_about': 'About',
    'layout_holiday': 'Holiday',
    'layout_other': 'Other',
  };

  static const Map<String, String> _khmer = {
    'greeting': 'សួស្តី',
    'request': 'សំណើរ',
    // Home ================================================
    'home_today': 'ថ្ងៃនេះ',
    'home_monthly': 'ប្រចាំខែ',
    'home_request': 'ស្នើសុំ',
    'home_review': 'ត្រួតពិនិត្យ',
    'home_total_working_hours': 'សរុបម៉ោងធ្វើការ',
    'home_grade_received': 'ទទួលនិទ្ទេស',
    'home_scan': 'ស្កេន',
    'home_daily': 'ប្រចាំថ្ងៃ',
    'home_evaluation': 'វាយតម្លៃ',
    'home_personal_info': 'ព័ត៌មានផ្ទាល់ខ្លួន',
    'home_job': 'ការងារ',
    'home_salary': 'ប្រាក់បៀវត្សរ៍',
    'home_id_card': 'ប័ណ្ណសម្គាល់ខ្លួន',
    'home_document': 'ឯកសារ',
    'home_no_name': 'មិនមានឈ្មោះ',
    'home_no_department': 'មិនមានផ្នែក',
    'hour': 'ម៉ោង',
    'minute': 'នាទី',
    // About ================================================
    'about_system': 'អំពីប្រព័ន្ធ',
    'about_rule': 'អនុក្រឹត',
    'about_daily_scan': 'ការស្កេនប្រចាំថ្ងៃ',
    'about_face_scanner': 'ម៉ាស៊ីនស្កេនមុខ',
    'about_working_hours': 'ម៉ោងធ្វើការ',
    'about_number_of_days': 'ចំនួនថ្ងៃ',
    'about_total_hours': 'ចំនួនម៉ោង',
    'about_scan_in': 'ស្កេនចូល',
    'about_scan_out': 'ស្កេនចេញ',
    'about_note': 'សម្គាល់',
    'about_active': 'សកម្ម',
    'about_hours': 'ម៉ោង',
    'about_day': 'ថ្ងៃ',
    'about_week': 'សប្តាហ៍',
    'about_lunch_break': 'លើកលែងម៉ោងបាយថ្ងៃត្រង់ 2 ម៉ោង',
    // Layout ================================================
    'layout_home': 'ទំព័រដើម',
    'layout_about': 'អំពីប្រព័ន្ធ',
    'layout_holiday': 'ឈប់សម្រាក',
    'layout_other': 'ផ្សេងៗ',
  };

  static String translate({
    String? key,
    Map<String, dynamic>? data,
    required String lang,
  }) {
    // Handle JSON-based translation if data is provided
    if (data != null) {
      final dataKey = lang == 'en' ? 'name_en' : 'name_kh';
      if (data.containsKey(dataKey) &&
          data[dataKey] is String &&
          (data[dataKey] as String).isNotEmpty) {
        return data[dataKey] as String;
      }
      return 'N/A';
    }

    // Handle static key-based translation if key is provided
    if (key != null) {
      if (lang == 'kh') {
        return _khmer[key] ?? 'N/A';
      } else {
        return _english[key] ?? 'N/A';
      }
    }

    // Return N/A if neither key nor data is provided
    return 'N/A';
  }
}
