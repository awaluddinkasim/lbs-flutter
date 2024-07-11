import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:locomotive21/cubit/register_cubit.dart';
import 'package:locomotive21/cubit/register_state.dart';
import 'package:locomotive21/models/data_user.dart';
import 'package:locomotive21/shared/widgets/dialog/loading.dart';
import 'package:locomotive21/shared/widgets/dialog/message.dart';
import 'package:locomotive21/shared/widgets/form/dropdown_outline.dart';
import 'package:locomotive21/shared/widgets/form/input_outline.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _emailConfirmation = TextEditingController();
  final _password = TextEditingController();
  final _noHp = TextEditingController();
  final _tglLahir = TextEditingController();
  final _alamat = TextEditingController();

  DateTime? _tglLahirSelected;
  String? _jenisKelamin;

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 108),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/svg/sign-up.svg",
                  width: 350,
                ),
              ),
              Text(
                "Sign Up",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
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
                controller: _emailConfirmation,
                label: "Konfirmasi Email",
                hint: "Masukkan ulang email",
                prefixIcon: const Icon(Icons.email),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email tidak boleh kosong";
                  }

                  if (value != _email.text) {
                    return "Email tidak sama";
                  }

                  return null;
                },
              ),
              InputOutline(
                controller: _password,
                label: "Password",
                hint: "Masukkan password",
                obscureText: _passwordVisible,
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
              InputOutline(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _tglLahir.text = DateFormat("dd-MM-yyyy").format(value);
                        _tglLahirSelected = value;
                      });
                    }
                  });
                },
                controller: _tglLahir,
                label: "Tanggal Lahir",
                readOnly: true,
                hint: "Masukkan tanggal lahir",
                prefixIcon: const Icon(Icons.calendar_month),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tgl. Lahir tidak boleh kosong";
                  }
                  return null;
                },
              ),
              DropdownOutline(
                value: _jenisKelamin,
                label: "Jenis Kelamin",
                hint: "Pilih jenis kelamin",
                prefixIcon: const Icon(Icons.person),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jenis kelamin tidak boleh kosong";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value;
                  });
                },
              ),
              InputOutline(
                controller: _alamat,
                label: "Alamat",
                hint: "Masukkan alamat",
                prefixIcon: const Icon(Icons.location_on),
                maxLines: null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat tidak boleh kosong";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocListener<RegisterCubit, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterLoading) {
                    showDialog(
                      context: context,
                      builder: (context) => const LoadingDialog(),
                    );
                  }
                  if (state is RegisterFailed) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    showDialog(
                      context: context,
                      builder: (context) => MessageDialog(
                        status: 'Gagal',
                        message: state.message,
                        onOkPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
                  if (state is RegisterSuccess) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    showDialog(
                      context: context,
                      builder: (context) => PopScope(
                        onPopInvoked: (didPop) => false,
                        child: MessageDialog(
                          status: 'Berhasil',
                          message: state.message,
                          onOkPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  }
                },
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<RegisterCubit>().register(
                            DataUser(
                              nama: _nama.text,
                              email: _email.text,
                              password: _password.text,
                              noHp: _noHp.text,
                              tglLahir: _tglLahirSelected.toString(),
                              jenisKelamin: _jenisKelamin!,
                              alamat: _alamat.text,
                            ),
                          );
                    }
                  },
                  child: Text("Daftar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
