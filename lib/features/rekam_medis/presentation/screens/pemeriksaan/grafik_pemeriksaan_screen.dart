import 'package:eimunisasi_nakes/core/widgets/grafik/grafik_tumbuh_kembang.dart';
import 'package:eimunisasi_nakes/core/widgets/grafik/line_chart_template.dart';
import 'package:eimunisasi_nakes/core/widgets/pasien_card.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/data/models/pemeriksaan_model.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/logic/form_pemeriksaan/form_pemeriksaan_vaksinasi_cubit.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/logic/pemeriksaan/pemeriksaan_cubit.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/presentation/screens/pemeriksaan/form_diagnosa_tindakan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GrafikPemeriksaanScreen extends StatelessWidget {
  const GrafikPemeriksaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pemeriksaanBloc =
        BlocProvider.of<FormPemeriksaanVaksinasiCubit>(context);
    final pasien = pemeriksaanBloc.state.pasien;
    return Scaffold(
      appBar: AppBar(title: const Text('Grafik Pemeriksaan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PasienCard(
              nama: pasien?.nama,
              umur: pasien?.umur,
              jenisKelamin: pasien?.jenisKelamin,
            ),
          ),
          BlocBuilder<PemeriksaanCubit, PemeriksaanState>(
            builder: (context, state) {
              if (state is PemeriksaanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PemeriksaanLoaded) {
                return Expanded(
                  child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.blue,
                            child: const TabBar(
                              indicatorColor: Colors.white,
                              tabs: [
                                Tab(
                                  text: 'Berat badan',
                                ),
                                Tab(
                                  text: 'Tinggi badan',
                                ),
                                Tab(
                                  text: 'Lingkar kepala',
                                ),
                              ],
                            ),
                          ),
                          BlocBuilder<PemeriksaanCubit, PemeriksaanState>(
                            builder: (context, state) {
                              List<PemeriksaanModel> data =
                                  (state is PemeriksaanLoaded)
                                      ? state.pemeriksaan ?? []
                                      : [];
                              PemeriksaanModel pemeriksaanModel =
                                  PemeriksaanModel(
                                bulanKe: pemeriksaanBloc.state.bulanKe,
                                beratBadan: pemeriksaanBloc.state.beratBadan,
                                tinggiBadan: pemeriksaanBloc.state.tinggiBadan,
                                lingkarKepala:
                                    pemeriksaanBloc.state.lingkarKepala,
                              );
                              data.add(pemeriksaanModel);
                              return Expanded(
                                child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    GrafikPertumbuhan(
                                      type: LineChartType.beratBadan,
                                      listData: data,
                                      isBoy:
                                          pasien?.jenisKelamin == "Laki-laki"
                                              ? true
                                              : false,
                                    ),
                                    GrafikPertumbuhan(
                                      type: LineChartType.tinggiBadan,
                                      listData: data,
                                      isBoy:
                                          pasien?.jenisKelamin == "Laki-laki"
                                              ? true
                                              : false,
                                    ),
                                    GrafikPertumbuhan(
                                      type: LineChartType.lingkarKepala,
                                      listData: data,
                                      isBoy:
                                          pasien?.jenisKelamin == "Laki-laki"
                                              ? true
                                              : false,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      bottomNavigationBar: const _NextButton(),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final pemeriksaanBloc =
        BlocProvider.of<FormPemeriksaanVaksinasiCubit>(context);
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: const Text("Lanjut"),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BlocProvider.value(
              value: pemeriksaanBloc,
              child: const FormDiagnosaTindakanScreen(),
            );
          }));
        },
      ),
    );
  }
}
