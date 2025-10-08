// features/dealer_dashboard/presentation/pages/dealer_dashboard_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/route_constants.dart';
import '../../../side_drawer/presentation/bloc/drawer_bloc.dart';
import '../../../side_drawer/presentation/widgets/app_drawer.dart';

class DealerDashboardPage extends StatelessWidget {
  final String dealerId;

  const DealerDashboardPage({Key? key, required this.dealerId})
      : super(key: key);

  static const _tabs = [
    {'icon': Icons.build, 'label': 'Service Request', 'route': RouteConstants.dashboard},
    {'icon': Icons.sell, 'label': 'Selling Device', 'route': RouteConstants.dashboard},
    {'icon': Icons.person_search, 'label': 'Customer Device', 'route': RouteConstants.dashboard},
    {'icon': Icons.devices, 'label': 'My Device', 'route': RouteConstants.myDevicePage},
    {'icon': Icons.group_work, 'label': 'Shared Device', 'route': RouteConstants.dashboard},
    {'icon': Icons.check_box, 'label': 'Selected Customer', 'route': RouteConstants.dashboard},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Home', style: TextStyle(fontWeight: FontWeight.w600)),
        flexibleSpace: _buildAppBarBackground(),
      ),
      drawer: BlocProvider(
        create: (_) => DrawerBloc(userName: "Venkat", userRole: "Dealer"),
        child: AppDrawer(
          onItemTap: (itemId) {
            if (itemId == "logout") {
              // TODO: Add logout logic
            }
          },
        ),
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Colors.black87,
                ],
              ),
            ),
          ),
          Positioned.fill(child: _buildBackgroundDecorations()),

          // Main content with cards
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: _tabs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  final label = tab['label'] as String;
                  final route = tab['route'] as String;

                  return _glossyCard(
                    context,
                    icon: tab['icon'] as IconData,
                    label: label,
                    onTap: () {
                      if (route.contains(":id")) {
                        Navigator.pushNamed(
                          context,
                          route.replaceFirst(":id", dealerId),
                        );
                      } else {
                        Navigator.pushNamed(context, route);
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarBackground() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.06),
                Colors.white.withOpacity(0.02)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _glossyCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        VoidCallback? onTap,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: Colors.white70),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.06), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          right: -80,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.white.withOpacity(0.04), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
