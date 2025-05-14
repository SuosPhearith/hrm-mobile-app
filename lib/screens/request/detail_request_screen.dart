import 'package:flutter/material.dart';
import 'package:mobile_app/providers/global/setting_provider.dart';
import 'package:mobile_app/providers/sample_provider.dart';
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
  Future<void> _refreshData(SampleProvider provider) async {
    return await provider.getHome();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SampleProvider(),
      child: Consumer2<SampleProvider, SettingProvider>(
        builder: (context, evaluateProvider, settingProvider, child) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('Sample ${widget.id}'),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: Colors.blue[800],
              backgroundColor: Colors.white,
              onRefresh: () => _refreshData(evaluateProvider),
              child:
                  evaluateProvider.isLoading
                      ? Center(child: Text('Loading...'))
                      : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Sample'),
                        ),
                      ),
            ),
          );
        },
      ),
    );
  }
}
