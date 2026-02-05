import 'package:Travelon/core/utils/datehelper.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/MyRequests/presentation/bloc/my_requests_bloc.dart';
import 'package:Travelon/features/MyRequests/presentation/bloc/my_requests_event.dart';
import 'package:Travelon/features/MyRequests/presentation/bloc/my_requests_state.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/my_request_details_page.dart';
import 'package:Travelon/features/MyRequests/presentation/widgets/requesttile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingRequestsPage extends StatelessWidget {
  const PendingRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetch when page builds
    context.read<MyRequestsBloc>().add(FetchMyRequests());

    return Scaffold(
      appBar: AppBar(title: const Text("Pending Requests")),
      body: BlocBuilder<MyRequestsBloc, MyRequestsState>(
        builder: (context, state) {
          if (state is MyRequestsLoading) {
            return const Myloader();
          }

          if (state is MyRequestsLoaded) {
            final pending = state.requests.where((r) {
              final s = r.status.toLowerCase();
              return s == "pending" || s == "planned" || s == "requested";
            }).toList();


            // Sort: newest first (higher RequestId first)
            pending.sort((a, b) => b.requestId.compareTo(a.requestId));

            if (pending.isEmpty) {
              return const Center(child: Text("No pending requests"));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pending.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final req = pending[index];

                return RequestTile(
                  icon: Icons.pending_actions,
                  title: "Request #${req.requestId}",
                  subtitle:
                  "From ${formatDate(req.startDate)} to ${formatDate(req.endDate)}",
                  status: req.status,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyRequestDetailsPage(request: req),
                      ),
                    );
                  },
                );
              },
            );
          }

          if (state is MyRequestsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
