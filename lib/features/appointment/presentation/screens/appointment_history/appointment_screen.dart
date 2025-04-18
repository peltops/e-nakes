import 'package:eimunisasi_nakes/core/widgets/error.dart';
import 'package:eimunisasi_nakes/features/appointment/logic/appointment_cubit/appointment_cubit.dart';
import 'package:eimunisasi_nakes/routers/appointment_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../injection.dart';
import '../../../data/models/appointment_model.dart';

class RiwayatJanjiScreen extends StatelessWidget {
  const RiwayatJanjiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppointmentCubit>()..getAllJadwal(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Janji'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const _Header(),
              Expanded(
                child:
                    _ListDate(onTap: (index) => debugPrint(index.toString())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.blue,
      child: const Text(
        'Daftar Janji',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class _ListDate extends StatelessWidget {
  final void Function(int)? onTap;

  const _ListDate({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoaded) {
          if (state.paginationAppointment?.data?.isEmpty ?? true) {
            return const Center(
              child: Text('Tidak ada janji'),
            );
          }
          final data = state.paginationAppointment?.data;
          return ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              if ((index == 0) ||
                  (DateFormat('dd MMMM yyyy').format(
                        data?[index].date ?? DateTime.now(),
                      ) !=
                      DateFormat('dd MMMM yyyy')
                          .format(data?[index - 1].date ?? DateTime.now()))) {
                return ExpansionTile(
                  title: Text(
                    DateFormat('dd MMMM yyyy').format(
                      data?[index].date ?? DateTime.now(),
                    ),
                  ),
                  children: [
                    for (final appointment in data ?? <PatientAppointmentModel>[])
                      if (DateFormat('dd-MM-yyyy')
                              .format(appointment.date ?? DateTime.now()) ==
                          DateFormat('dd-MM-yyyy')
                              .format(data?[index].date ?? DateTime.now()))
                        ListTile(
                          title: Text(
                            DateFormat('hh:mm').format(
                              appointment.date ?? DateTime.now(),
                            ),
                          ),
                          subtitle: Text(appointment.note ?? '-'),
                          onTap: () {
                            context.pushNamed(
                              AppointmentRouter.historyDetailRoute.name,
                              pathParameters: {'id': appointment.id ?? ''},
                            );
                          },
                        ),
                  ],
                );
              }
              return Container();
            },
          );
        }
        if (state is AppointmentLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is AppointmentError) {
          return ErrorContainer(
            title: state.message,
            message: 'Coba lagi',
            onRefresh: () {
              BlocProvider.of<AppointmentCubit>(context).getAllJadwal();
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
