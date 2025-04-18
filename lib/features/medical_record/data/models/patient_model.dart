import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final String? id;
  final String? parentId;
  final String? nama;
  final String? nik;
  final String? tempatLahir;
  final DateTime? tanggalLahir;
  final String? jenisKelamin;
  final String? golDarah;
  final String? photoURL;

  String get umur {
    if (tanggalLahir == null) return 'Umur belum diisi';

    final diff = DateTime.now().difference(tanggalLahir ?? DateTime.now());
    final years = diff.inDays / 365;
    final months = (diff.inDays % 365) / 30;
    return '${years.floor()} tahun, ${months.floor()} bulan';
  }

  const PatientModel({
    this.id,
    this.parentId,
    this.nik,
    this.tempatLahir,
    this.jenisKelamin,
    this.golDarah,
    this.nama,
    this.tanggalLahir,
    this.photoURL,
  });

  factory PatientModel.fromSeribase(Map<String, dynamic> data) {
    return PatientModel(
      id: data['id'],
      parentId: data['parent_id'],
      nama: data['name'],
      nik: data['nik'] ?? '',
      tempatLahir: data['place_of_birth'] ?? '',
      tanggalLahir: () {
        try {
          return DateTime.parse(data['date_of_birth']);
        } catch (e) {
          return null;
        }
      }(),
      jenisKelamin: data['gender'] ?? '',
      golDarah: data['blood_type'] ?? '',
      photoURL: data['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toSeribaseMap() {
    return {
      if (parentId?.isNotEmpty ?? false) 'parent_id': parentId,
      if (nama?.isNotEmpty ?? false) 'name': nama,
      if (nik?.isNotEmpty ?? false) 'nik': nik,
      if (tempatLahir?.isNotEmpty ?? false) 'place_of_birth': tempatLahir,
      if (tanggalLahir != null)
        'date_of_birth': tanggalLahir?.toIso8601String(),
      if (jenisKelamin?.isNotEmpty ?? false) 'gender': jenisKelamin,
      if (golDarah?.isNotEmpty ?? false) 'blood_type': golDarah,
      if (photoURL?.isNotEmpty ?? false) 'avatar_url': photoURL,
    };
  }

  PatientModel copyWith({
    String? id,
    String? parentId,
    String? nama,
    String? nik,
    String? tempatLahir,
    DateTime? tanggalLahir,
    String? jenisKelamin,
    String? golDarah,
    String? photoURL,
  }) {
    return PatientModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      golDarah: golDarah ?? this.golDarah,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  @override
  List<Object?> get props => [
    id,
    parentId,
    nama,
    nik,
    tempatLahir,
    tanggalLahir,
    jenisKelamin,
    golDarah,
    photoURL,
  ];
}