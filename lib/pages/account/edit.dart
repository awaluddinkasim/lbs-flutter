import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:locomotive21/models/user.dart';
import 'package:locomotive21/shared/widgets/form/dropdown_outline.dart';
import 'package:locomotive21/shared/widgets/form/input_outline.dart';

class EditAccountScreen extends StatefulWidget {
  final User user;
  const EditAccountScreen({super.key, required this.user});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _noHp = TextEditingController();
  final _tglLahir = TextEditingController();
  final _alamat = TextEditingController();

  DateTime? _tglLahirSelected;
  String? _jenisKelamin;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    _nama.text = widget.user.nama;
    _email.text = widget.user.email;
    _noHp.text = widget.user.noHp;
    _tglLahir.text = widget.user.tglLahir;
    _alamat.text = widget.user.alamat;
    _jenisKelamin = widget.user.jenisKelamin;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputOutline(
                controller: _nama,
                label: "Nama",
                hint: "Masukkan nama",
                prefixIcon: const Icon(Icons.badge),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              InputOutline(
                controller: _email,
                label: "Email",
                hint: "Masukkan email",
                prefixIcon: const Icon(Icons.email),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }
                  return null;
                },
              ),
              InputOutline(
                controller: _password,
                label: "Ganti Password",
                hint: "Masukkan password",
                obscureText: !_passwordVisible,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(_passwordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password tidak boleh kosong";
                  }
                  if (value.length < 8) {
                    return "Password minimal 8 karakter";
                  }
                  return null;
                },
              ),
              InputOutline(
                controller: _noHp,
                label: "No. HP",
                keyboardType: TextInputType.number,
                hint: "Masukkan nomor HP",
                prefixIcon: const Icon(Icons.phone),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No. HP tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 24,
              ),
              FilledButton(
                onPressed: () {},
                child: Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
