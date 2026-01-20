import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herbal_app/Feature/praktisi/bloc/praktisi_bloc.dart';
import 'package:herbal_app/components/practitioner_card_horizontal.dart';
import 'package:herbal_app/components/search_bar_widget.dart';

class PraktisiView extends StatefulWidget {
  const PraktisiView({super.key});

  @override
  State<PraktisiView> createState() => _PraktisiViewState();
}

class _PraktisiViewState extends State<PraktisiView> {
  PraktisiBloc praktisiBloc = PraktisiBloc();

  @override
  void initState() {
    super.initState();
    praktisiBloc.add(LoadPractitionersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: searchBar(
                () {},
                "Cari praktisi, layanan, atau keahlian...",
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<PraktisiBloc, PraktisiState>(
                bloc: praktisiBloc,
                builder: (context, state) {
                  if (state is PraktisiLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PraktisiLoaded) {
                    final practitioners = state.practitioners;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Praktisi Terdaftar",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              itemCount: practitioners.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final practitioner = practitioners[index];
                                return PractitionerCardHorizontal(
                                  practitioner: practitioner,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is PraktisiInitial) {
                    return const Center(child: Text('Mulai mencari praktisi'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
