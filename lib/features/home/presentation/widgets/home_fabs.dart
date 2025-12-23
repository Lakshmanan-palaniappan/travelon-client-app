import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/map/presentation/cubit/gps_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeFABs extends StatelessWidget {
  final Tourist? tourist;
  const HomeFABs({super.key, required this.tourist});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "gps",
          onPressed: () {
            context.read<GpsCubit>().fetchCurrentLocation(context);
          },
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 12),

        FloatingActionButton(
          heroTag: "wifi",
          onPressed: tourist == null
              ? null
              : () {
                  context.read<LocationBloc>().add(
                        GetLocationEvent(int.parse(tourist!.id!)),
                      );
                },
          child: const Icon(Icons.wifi),
        ),
      ],
    );
  }
}
