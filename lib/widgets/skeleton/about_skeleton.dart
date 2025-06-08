import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';

class AboutSkeleton extends StatelessWidget {
  const AboutSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: Theme.of(context).textTheme.titleLarge!.fontSize!,
          color: HColors.darkgrey.withOpacity(0.1),
        ),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: _CustomHeaderSkeleton(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeaderSkeleton(context),
              const SizedBox(height: 12),
              _buildInfoTileSkeleton(context),
              _buildInfoTileSkeleton(context),
              _buildInfoTileSkeleton(context),
              const SizedBox(height: 24),
              _buildSectionHeaderSkeleton(context),
              const SizedBox(height: 12),
              _buildInfoTileSkeleton(context),
              _buildInfoTileSkeleton(context),
              _buildInfoTileSkeleton(context),
              const SizedBox(height: 24),
              _buildSectionHeaderSkeleton(context),
              const SizedBox(height: 12),
              ...List.generate(3, (index) => _buildScannerTileSkeleton(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeaderSkeleton(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 20.0,
          color: HColors.darkgrey.withOpacity(0.1),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  Widget _buildInfoTileSkeleton(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 35.0,
          width: 35.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: HColors.darkgrey.withOpacity(0.1),
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: HColors.darkgrey.withOpacity(0.1),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: HColors.darkgrey.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16.0,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
                const SizedBox(height: 4.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 12.0,
                  color: HColors.darkgrey.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerTileSkeleton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: HColors.darkgrey.withOpacity(0.1)),
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
                    color: HColors.darkgrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 16.0,
                        color: HColors.darkgrey.withOpacity(0.1),
                      ),
                      const SizedBox(height: 4.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 12.0,
                        color: HColors.darkgrey.withOpacity(0.1),
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
                width: 80.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: HColors.darkgrey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                width: 60.0,
                height: 12.0,
                color: HColors.darkgrey.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomHeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: HColors.darkgrey.withOpacity(0.1),
      child: Container(
        width: double.infinity,
        height: 32.0,
        color: HColors.darkgrey.withOpacity(0.1),
      ),
    );
  }
}