import 'package:eimunisasi_nakes/features/bottom_navbar/logic/buttom_navbar/bottom_navbar_cubit.dart';
import 'package:eimunisasi_nakes/features/home/presentation/screens/home_screen.dart';
import 'package:eimunisasi_nakes/features/appointment/logic/appointment_cubit/appointment_cubit.dart';
import 'package:eimunisasi_nakes/features/notifications/presentation/screens/notification_screen.dart';
import 'package:eimunisasi_nakes/features/profile/presentation/screens/profile_screen.dart';
import 'package:eimunisasi_nakes/injection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../routers/route_paths/root_route_paths.dart';
import '../../../authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavbarWrapper extends StatelessWidget {
  const BottomNavbarWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.goNamed(RootRoutePaths.root.name);
        }
      },
      child: BlocProvider(
        create: (context) => BottomNavbarCubit(),
        child: Scaffold(
          extendBodyBehindAppBar: false,
          body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
                  builder: (contextNavbar, stateNavbar) {
                    if (stateNavbar is BottomNavbarHome) {
                      return BlocProvider(
                        create: (context) => getIt<AppointmentCubit>()..getJadwalToday(),
                        child: const HomeScreen(),
                      );
                    } else if (stateNavbar is BottomNavbarProfile) {
                      return const ProfileScreen();
                    } else if (stateNavbar is BottomNavbarMessage) {
                      return const NotificationScreen();
                    } else {
                      return Center(
                        child: Text('Unknown ${state.user?.id}'),
                      );
                    }
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          bottomNavigationBar:
              BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
            builder: (context, state) {
              return BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.itemIndex,
                onTap: (value) =>
                    context.read<BottomNavbarCubit>().navigateTo(value),
                items: const [
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.houseChimneyMedical,
                      size: 20,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.userDoctor,
                      size: 20,
                    ),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.solidBell,
                      size: 20,
                    ),
                    label: 'Message',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
