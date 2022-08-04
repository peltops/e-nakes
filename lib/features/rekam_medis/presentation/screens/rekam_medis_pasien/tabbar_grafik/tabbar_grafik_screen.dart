import 'package:eimunisasi_nakes/core/widgets/grafik/grafik_berat_badan.dart';
import 'package:eimunisasi_nakes/core/widgets/grafik/line_data_berat_badan_boy.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/data/models/pemeriksaan_model.dart';
import 'package:eimunisasi_nakes/features/rekam_medis/logic/pemeriksaan/pemeriksaan_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabbarGrafikScreen extends StatelessWidget {
  const TabbarGrafikScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Berat Badan'),
                Tab(text: 'Tinggi Badan'),
                Tab(text: 'Lingkar Kepala'),
              ],
            ),
          ),
          BlocBuilder<PemeriksaanCubit, PemeriksaanState>(
            builder: (context, state) {
              final List<PemeriksaanModel> data =
                  (state is PemeriksaanLoaded) ? state.pemeriksaan ?? [] : [];
              return Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GrafikBeratBadan(
                      listData: data,
                      isBoy: true,
                    ),
                    GrafikBeratBadan(listData: data),
                    GrafikBeratBadan(listData: data),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
