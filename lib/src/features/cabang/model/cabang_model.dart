// ignore_for_file: public_member_api_docs, sort_constructors_first

class Cabang {
  final int cabangId;
  final String nama;
  final String alamat;
  final String? profilePicture;
  final int totalTreatment;
  final int? happyHourId;
  final int? startDay;
  final String? startTime;
  final int? endDay;
  final String? endTime;
  final String phoneNumber;

  Cabang({
    required this.cabangId,
    required this.nama,
    required this.alamat,
    required this.profilePicture,
    required this.totalTreatment,
    required this.happyHourId,
    required this.startDay,
    required this.startTime,
    required this.endDay,
    required this.endTime,
    required this.phoneNumber,
  });

  Cabang copyWith({
    int? cabangId,
    String? nama,
    String? alamat,
    String? profilePicture,
    int? totalTreatment,
    int? happyHourId,
    int? startDay,
    String? startTime,
    int? endDay,
    String? endTime,
    String? phoneNumber,
  }) {
    return Cabang(
        cabangId: cabangId ?? this.cabangId,
        nama: nama ?? this.nama,
        alamat: alamat ?? this.alamat,
        profilePicture: profilePicture ?? this.profilePicture,
        totalTreatment: totalTreatment ?? this.totalTreatment,
        happyHourId: happyHourId ?? this.happyHourId,
        startDay: startDay ?? this.startDay,
        startTime: startTime ?? this.startTime,
        endDay: endDay ?? this.endDay,
        endTime: endTime ?? this.endTime,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }

  factory Cabang.fromMap(Map<String, dynamic> map) {
    return Cabang(
      cabangId: map['cabang_id'].toInt() as int,
      nama: map['nama'] as String,
      alamat: map['alamat'] as String,
      profilePicture: map['profile_picture'] as String?,
      totalTreatment: map['total_treatment'] ?? 0,
      happyHourId: map['happy_hour_id'] as int?,
      startDay: map['start_day'] as int?,
      startTime: map['start_time'] as String?,
      endDay: map['end_day'] as int?,
      endTime: map['end_time'] as String?,
      phoneNumber: map['phone_number'] as String,
    );
  }

  @override
  String toString() {
    return 'Cabang(cabangId: $cabangId, nama: $nama, alamat: $alamat, profilePicture: $profilePicture, totalTreatment: $totalTreatment, happyHourId: $happyHourId, startDay: $startDay, startTime: $startTime, endDay: $endDay, endTime: $endTime, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(covariant Cabang other) {
    if (identical(this, other)) return true;

    return other.cabangId == cabangId &&
        other.nama == nama &&
        other.alamat == alamat &&
        other.profilePicture == profilePicture &&
        other.totalTreatment == totalTreatment &&
        other.happyHourId == happyHourId &&
        other.startDay == startDay &&
        other.startTime == startTime &&
        other.endDay == endDay &&
        other.endTime == endTime &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode {
    return cabangId.hashCode ^
        nama.hashCode ^
        alamat.hashCode ^
        profilePicture.hashCode ^
        totalTreatment.hashCode ^
        happyHourId.hashCode ^
        startDay.hashCode ^
        startTime.hashCode ^
        endDay.hashCode ^
        endTime.hashCode ^
        phoneNumber.hashCode;
  }
}
