import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/auth_cubit.dart';
import 'package:locomotive21/cubit/auth_state.dart';
import 'package:locomotive21/cubit/event_cubit.dart';
import 'package:locomotive21/shared/widgets/user_detail.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<EventCubit>().getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 220,
                      color: Theme.of(context).primaryColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 90,
                          ),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 150,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Image.asset(
                                    "assets/avatar.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      state.auth.user.nama,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      state.auth.user.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => EditAccountScreen(
                                //       user: state.auth.user,
                                //     ),
                                //   ),
                                // );
                              },
                              child: const Wrap(
                                children: [
                                  // Icon(
                                  //   Icons.edit_note_rounded,
                                  //   size: 20,
                                  // ),
                                  // SizedBox(
                                  //   width: 6,
                                  // ),
                                  // Text("Edit"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              UserDetail(
                                label: "Nama",
                                value: state.auth.user.nama,
                              ),
                              UserDetail(
                                label: "Jenis Kelamin",
                                value: state.auth.user.jenisKelamin,
                              ),
                              UserDetail(
                                label: "No. HP",
                                value: state.auth.user.noHp,
                              ),
                              UserDetail(
                                label: "Tanggal Lahir",
                                value: state.auth.user.tglLahir,
                              ),
                              UserDetail(
                                label: "Alamat",
                                value: state.auth.user.alamat,
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  context.read<AuthCubit>().logout();
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text("Logout"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
