class User {
  final String nama;
  final String email;
  final String noHp;
  final String tglLahir;
  final String jenisKelamin;
  final String alamat;

  User({
    required this.nama,
    required this.email,
    required this.noHp,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.alamat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'],
      email: json['email'],
      noHp: json['no_hp'],
      tglLahir: json['tgl_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
    );
  }
}
