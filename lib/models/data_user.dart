class DataUser {
  final String nama;
  final String email;
  final String password;
  final String noHp;
  final String tglLahir;
  final String jenisKelamin;
  final String alamat;

  DataUser({
    required this.nama,
    required this.email,
    required this.password,
    required this.noHp,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.alamat,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'no_hp': noHp,
      'tgl_lahir': tglLahir,
      'jenis_kelamin': jenisKelamin,
      'alamat': alamat,
    };
  }
}
