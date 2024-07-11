import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/auth_cubit.dart';
import 'package:locomotive21/cubit/auth_state.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/models/data_login.dart';
import 'package:locomotive21/pages/app.dart';
import 'package:locomotive21/pages/auth/register.dart';
import 'package:locomotive21/shared/widgets/dialog/loading.dart';
import 'package:locomotive21/shared/widgets/dialog/message.dart';
import 'package:locomotive21/shared/widgets/form/input_styled.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 108),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              Center(
                child: Image.asset(
                  "assets/logo.png",
                  width: 200,
                ),
              ),
              const SizedBox(height: 24),
              InputStyled(
                controller: _email,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                label: "Email",
                hint: "Masukkan email",
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InputStyled(
                controller: _password,
                obscureText: !_passwordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                label: "Password",
                hint: "Masukkan password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.visibility),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const LoadingDialog();
                      },
                    );
                  }
                  if (state is AuthFailed) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MessageDialog(
                          status: 'Gagal',
                          message: state.message,
                          onOkPressed: () {
                            Navigator.pop(context);
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    );
                  }
                  if (state is AuthSuccess) {
                    context.read<EventCubit>().getEvents();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const App(),
                      ),
                      (route) => false,
                    );
                  }
                },
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthCubit>().login(
                            DataLogin(
                              email: _email.text,
                              password: _password.text,
                            ),
                          );
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    'Daftar Akun',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
