import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi_nakes/features/authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:eimunisasi_nakes/features/appointment/logic/appointment_cubit/appointment_cubit.dart';
import 'package:eimunisasi_nakes/routers/medical_record_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../routers/appointment_router.dart';
import '../../../../routers/calendar_router.dart';
import '../../../../routers/clinic_router.dart';
import '../../../authentication/data/models/user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HelloHeader(
                      data: state.user,
                    ),
                    BlocBuilder<AppointmentCubit, AppointmentState>(
                      builder: (context, stateJadwal) {
                        return const _AppoinmentToday();
                      },
                    ),
                    const Flexible(child: _MenuList()),
                  ]),
            ),
          );
        }
        return Column(children: const [
          Text('Unknown'),
        ]);
      },
    );
  }
}

class _HelloHeader extends StatelessWidget {
  final ProfileModel? data;

  const _HelloHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'Halo',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            () {
              if (data?.fullName != null) {
                return Text(data?.fullName ?? '');
              } else {
                if (data?.phone == '' || data?.phone == null) {
                  return Text(
                    data?.email ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                } else {
                  return Text(
                    data?.phone ?? '',
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                }
              }
            }(),
          ]),
          CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(data?.photo ??
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
          ),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {
        'title': 'Kalender',
        'icon': FontAwesomeIcons.calendar,
        'route': CalendarRouter.calendarRoute,
      },
      {
        'title': 'Klinik',
        'icon': FontAwesomeIcons.hospital,
        'route': ClinicRouter.wrapperRoute,
      },
      {
        'title': 'Jadwal',
        'icon': FontAwesomeIcons.clipboardList,
        'route': AppointmentRouter.wrapperRoute,
      },
      {
        'title': 'Rekam Medis',
        'icon': FontAwesomeIcons.bookMedical,
        'route': MedicalRecordRouter.wrapperRoute,
      }
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.2,
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      data[index]['route'].name,
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: FaIcon(
                            data[index]['icon'],
                            size: 30,
                            color: Colors.blue[100],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AppoinmentToday extends StatelessWidget {
  const _AppoinmentToday();

  @override
  Widget build(BuildContext context) {
    final jadwal =
        context.read<AppointmentCubit>().state.paginationAppointment?.data;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jadwal Pasien Hari Ini',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  context.pushNamed(
                    AppointmentRouter.historiesRoute.name,
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blue[300],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        BlocBuilder<AppointmentCubit, AppointmentState>(
                          builder: (context, state) {
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                state.paginationAppointment?.data?.first.child
                                        ?.photoURL ??
                                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        BlocBuilder<AppointmentCubit, AppointmentState>(
                          builder: (context, state) {
                            if (state is AppointmentLoading) {
                              return const Expanded(
                                  child: LinearProgressIndicator());
                            }
                            return Text(
                              state.paginationAppointment?.data?.first.child
                                      ?.nama ??
                                  'Tidak ada pasien',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.blue[200],
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.calendarDays,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    jadwal?.first.date ?? DateTime.now()),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.clock,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BlocBuilder<AppointmentCubit, AppointmentState>(
                                builder: (context, state) {
                                  return Text(
                                    DateFormat('HH:mm').format(
                                      state.paginationAppointment?.data?.first
                                              .date ??
                                          DateTime.now(),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
