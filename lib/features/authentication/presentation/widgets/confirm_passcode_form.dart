import 'package:eimunisasi_nakes/routers/route_paths/root_route_paths.dart';
import 'package:go_router/go_router.dart';

import '../../logic/cubit/local_auth_cubit/local_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ConfirmPasscodeForm extends StatelessWidget {
  const ConfirmPasscodeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Konfirmasi PIN!"),
            const SizedBox(height: 16),
            _PasscodeInput(),
            const SizedBox(height: 16),
            _NextButton(),
          ],
        ),
      ),
    );
  }
}

class _PasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      builder: (context, state) {
        return TextField(
          maxLength: 4,
          key: const Key('confirmPasscodeForm_passcodeInput_textField'),
          onChanged: (value) =>
              context.read<LocalAuthCubit>().passcodeConfirmChanged(value),
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Masukkan kembali PIN',
            helperText: 'Konfirmasi 4-digit PIN',
            // ignore: unrelated_type_equality_checks
            errorText: state.confirmPasscode != state.passcode.value
                ? 'PIN Tidak Sama!'
                : null,
          ),
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.goNamed(RootRoutePaths.dashboard.name);
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Gagal'),
              ),
            );
        }
        if (state.statusSetPasscode.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Gagal'),
              ),
            );
        }
      },
      child: BlocBuilder<LocalAuthCubit, LocalAuthState>(
        builder: (context, state) {
          if (state.status.isInProgress) {
            return const CircularProgressIndicator();
          }
          return ElevatedButton(
            key: const Key('confirmPasscodeForm_next_raisedButton'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              context.read<LocalAuthCubit>().confirmPasscode();
            },
            child: const Text('Konfirmasi'),
          );
        },
      ),
    );
  }
}
