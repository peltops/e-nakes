import 'package:date_time_picker/date_time_picker.dart';
import 'package:eimunisasi_nakes/core/widgets/custom_text_field.dart';
import 'package:eimunisasi_nakes/features/calendar/logic/form_calendar_activity/form_calendar_activity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class AddEventCalendarScreen extends StatelessWidget {
  const AddEventCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formBloc = BlocProvider.of<FormCalendarActivityCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kegiatan'),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocListener<FormCalendarActivityCubit, FormCalendarActivityState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            formBloc.reset();
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kegiatan berhasil ditambahkan'),
              ),
            );
          } else if (state.status == FormzSubmissionStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Kegiatan gagal ditambahkan'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                BlocBuilder<FormCalendarActivityCubit,
                    FormCalendarActivityState>(
                  builder: (context, state) {
                    return DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: state.date.toString(),
                      firstDate: DateTime.now().add(const Duration(days: -365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      icon: const Icon(FontAwesomeIcons.calendarXmark),
                      dateLabelText: 'Tanggal',
                      timeLabelText: "Jam",
                      selectableDayPredicate: (date) {
                        // Disable weekend days to select from the calendar
                        if (date.weekday == 6 || date.weekday == 7) {
                          return false;
                        }
                        return true;
                      },
                      onChanged: (val) {
                        DateTime value = DateTime.parse(val);
                        formBloc.dateChange(value);
                        debugPrint(val);
                      },
                      onSaved: (val) {
                        DateTime value = DateTime.parse(
                          val ?? DateTime.now().toString(),
                        );
                        formBloc.dateChange(value);
                        debugPrint(val);
                      },
                    );
                  },
                ),
                const SizedBox(height: 10.0),
                _ActivityForm(
                  hintText: 'Periksa bayi dan imunisasi',
                  onChanged: (val) {
                    formBloc.activityChange(val);
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const _SaveButton(),
    );
  }
}

class _ActivityForm extends StatelessWidget {
  final String? hintText;
  final void Function(String)? onChanged;

  const _ActivityForm({
    this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi Kegiatan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        MyTextFormField(
          onChanged: onChanged,
          hintText: hintText,
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final formBloc = context.read<FormCalendarActivityCubit>();
    return BlocBuilder<FormCalendarActivityCubit, FormCalendarActivityState>(
      builder: (context, state) {
        final isLoading = state.status == FormzSubmissionStatus.inProgress;
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            onPressed: isLoading
                ? null
                : () {
                    formBloc.addCalendarActivity();
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  Text('Menyimpan...'),
                  SizedBox(width: 10),
                  CircularProgressIndicator(),
                ] else ...[
                  const Text("Simpan"),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
