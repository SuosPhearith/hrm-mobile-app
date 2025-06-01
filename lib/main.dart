import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/app_lang.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/screens/about_screen.dart';
import 'package:mobile_app/screens/daily_screen.dart';
import 'package:mobile_app/screens/evaluate_screen.dart';
import 'package:mobile_app/screens/holliday_screen.dart';
import 'package:mobile_app/screens/personal_info/create_education_screen.dart';
import 'package:mobile_app/screens/personal_info/create_language_level.dart';
import 'package:mobile_app/screens/personal_info/create_relative_screen.dart';
import 'package:mobile_app/screens/personal_info/update_education_screen.dart';
import 'package:mobile_app/screens/personal_info/update_language_level_screen.dart';
import 'package:mobile_app/screens/personal_info/update_relative_screen.dart';
import 'package:mobile_app/screens/personal_info/update_screen.dart';
import 'package:mobile_app/screens/personal_info_screen.dart';
import 'package:mobile_app/screens/request/create_request_screen.dart';
import 'package:mobile_app/screens/request/detail_request_screen.dart';
import 'package:mobile_app/screens/request_screen.dart';
import 'package:mobile_app/screens/salary_screen.dart';
import 'package:mobile_app/screens/scan_screen.dart';
import 'package:mobile_app/screens/select_language_screen.dart';
import 'package:mobile_app/screens/welcome_screen.dart';
import 'package:mobile_app/screens/work/create_user_medal_screen.dart';
import 'package:mobile_app/screens/work/create_work_history_screen.dart';
import 'package:mobile_app/screens/work/update_user_medal_screen.dart';
import 'package:mobile_app/screens/work/update_user_work_screen.dart';
import 'package:mobile_app/screens/work/update_work_history_screen.dart';
import 'package:mobile_app/screens/work_screen.dart';
import 'package:mobile_app/shared/color/colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/app_routes.dart';
import 'package:mobile_app/middlewares/auth_middleware.dart';
import 'package:mobile_app/providers/global/auth_provider.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/profile_screen.dart';
import 'package:mobile_app/utils/dio.client.dart';

// Main function remains unchanged
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await dotenv.load(fileName: '.env.$flavor');

  final requiredVars = ['APP_NAME', 'API_URL', 'API_KEY'];
  for (var variable in requiredVars) {
    if (!dotenv.env.containsKey(variable)) {
      throw Exception('$variable is not set in .env.$flavor');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DioClient.setupInterceptors(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        fontFamily: 'Kantumruy',
        primaryColor: const Color(0xFF002458),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF002458),
          secondary: Color(0xFF002458),
          surface: Colors.white,
        ),
        textTheme:  TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black),
          bodySmall: TextStyle(fontSize: 12, color: HColors.darkgrey),
        ),
        appBarTheme: const AppBarTheme(
          // backgroundColor: Color(0xFF002458),
          // foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF002458),
          unselectedItemColor: HColors.darkgrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          showUnselectedLabels: true,
          elevation: 8,
        ),
      ),
    );
  }
}

// Updated Router Configuration with StatefulShellRoute
final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.home,
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Wrap the MainLayout with AuthMiddleware
        return AuthMiddleware(
          child: MainLayout(navigationShell: navigationShell),
        );
      },
      branches: [
        // Home Tab
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // About Tab
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.about,
              builder: (context, state) => const AboutScreen(),
            ),
          ],
        ),
        // Holiday Tab
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.holliday,
              builder: (context, state) => const HollidayScreen(),
            ),
          ],
        ),
        // Profile Tab
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) =>
          AuthMiddleware(child: const AuthLayout(child: LoginScreen())),
    ),
    GoRoute(
      path: AppRoutes.selectLanguage,
      builder: (context, state) => AuthMiddleware(
        child: const AuthLayout(child: SelectLanguageScreen()),
      ),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.request,
      builder: (context, state) => const RequestScreen(),
    ),
    GoRoute(
      path: AppRoutes.scan,
      builder: (context, state) => const ScanScreen(),
    ),
    GoRoute(
      path: AppRoutes.daily,
      builder: (context, state) => const DailyScreen(),
    ),
    GoRoute(
      path: AppRoutes.evaluate,
      builder: (context, state) => const EvaluateScreen(),
    ),
    GoRoute(
      path: AppRoutes.personalInfo,
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: AppRoutes.work,
      builder: (context, state) => const WorkScreen(),
    ),
    GoRoute(
      path: AppRoutes.salary,
      builder: (context, state) => const SalaryScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.createRequest}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateRequestScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.detailRequest}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return DetailRequestScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.updatePersonalInfo}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return UpdatePersonalInfoScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.createUserRelative}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateRelativeScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.createEducation}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateEducationScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.createLanguageLevel}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateLanguageLevel(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.createWorkHistory}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateWorkHistoryScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.createUserMedal}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return CreateUserMedalScreen(id: id);
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateRelative}/:userId/:familyId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String familyId = state.pathParameters['familyId']!;
        return UpdateRelativeScreen(
          userId: userId,
          familyId: familyId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateEducation}/:userId/:educationId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String educationId = state.pathParameters['educationId']!;
        return UpdateEducationScreen(
          userId: userId,
          educationId: educationId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateLanguageLevel}/:userId/:userLanguageId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String userLanguageId = state.pathParameters['userLanguageId']!;
        return UpdateLanguageLevelScreen(
          id: userId,
          userLanguageId: userLanguageId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateWorkHistory}/:userId/:workId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String userWorkId = state.pathParameters['workId']!;
        return UpdateWorkHistoryScreen(
          id: userId,
          workId: userWorkId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateUserMedal}/:userId/:medalId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String medalId = state.pathParameters['medalId']!;
        return UpdateUserMedalScreen(
          id: userId,
          userMedalId: medalId,
        );
      },
    ),
    GoRoute(
      path: '${AppRoutes.updateUserWork}/:userId/:workId',
      builder: (context, state) {
        final String userId = state.pathParameters['userId']!;
        final String workId = state.pathParameters['workId']!;
        return UpdateUserWorkScreen(
          id: userId,
          workId: workId,
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Error: ${state.error}',
        style: const TextStyle(fontSize: 18, color: Colors.red),
      ),
    ),
  ),
);

/// Main Layout with Stateful Navigation
class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({required this.navigationShell, super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Track the actual selected index including the FAB space
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.navigationShell.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<SettingProvider>(context).lang;

    return Scaffold(
      
      body: SafeArea(
        top: false,
        child: widget.navigationShell,
      ),
      // floatingActionButton: Container(
      //   margin: const EdgeInsets.only(top: 20),
      //   height: 64,
      //   width: 64,
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black26,
      //         blurRadius: 8,
      //         offset: const Offset(0, 3),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       _showAddRequestBottomSheet(context);
      //     },
      //     backgroundColor: Theme.of(context).colorScheme.secondary,
      //     elevation: 0,
      //     shape: const CircleBorder(),
      //     child: const Icon(Icons.add, size: 32),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            if (index == 2) return; // FAB placeholder, do nothing

            // Map bottom nav indices to branch indices
            // 0 -> 0 (Home)
            // 1 -> 1 (About)
            // 2 -> FAB (skip)
            // 3 -> 2 (Holiday)
            // 4 -> 3 (Other/Profile)
            final branchIndex = index >= 3 ? index - 1 : index;
            widget.navigationShell.goBranch(branchIndex);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home, 0,),
              activeIcon: _buildNavIcon(Icons.home, 0, active: true,),
              label: AppLang.translate(key: 'layout_home', lang: lang ?? 'kh'),
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.info, 1),
              activeIcon: _buildNavIcon(Icons.info, 1, active: true),
              label: AppLang.translate(key: 'layout_about', lang: lang ?? 'kh'),
            ),
            // BottomNavigationBarItem(
            //   icon: Container(width: 24), // Empty space for FAB
            //   label: '',
            // ),
            BottomNavigationBarItem(
                icon: GestureDetector(
                  onTap: () {
                    _showAddRequestBottomSheet(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: HColors.blue,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 28.0,
                      color: HColors.yellow,
                    ),
                  ),
                ),
                label: '',
              ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.calendar_month, 3),
              activeIcon: _buildNavIcon(Icons.calendar_month, 3, active: true),
              label: AppLang.translate(
                key: 'layout_holiday',
                lang: lang ?? 'kh',
              ),
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.grid_view_rounded, 4),
              activeIcon: _buildNavIcon(
                Icons.grid_view_rounded,
                4,
                active: true,
              ),
              label: AppLang.translate(key: 'layout_other', lang: lang ?? 'kh'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRequestBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              _buildBottomSheetOption(
                icon: Icons.account_circle,
                label: 'សំណើរច្បាប់',
                onTap: () {},
              ),
              const SizedBox(height: 12.0),
              _buildBottomSheetOption(
                icon: Icons.airplanemode_active_rounded,
                label: 'សំណើរបេសកកម្ម',
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24.0, color: Colors.blue[800]),
            ),
            const SizedBox(width: 12.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool active = false}) {
    // Check if this icon's index matches the currently selected index
    bool isSelected = index == _selectedIndex;

    return Container(
      padding: const EdgeInsets.all(6.0),
      child: Icon(
        icon,
        size: 28.0,
        color: isSelected || active
            ? Theme.of(context).colorScheme.secondary
            : HColors.darkgrey,
      ),
    );
  }
}

/// Auth Layout remains unchanged
class AuthLayout extends StatelessWidget {
  final Widget child;
  const AuthLayout({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(child: child),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    '© ${DateTime.now().year} ${dotenv.env['APP_NAME']}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
