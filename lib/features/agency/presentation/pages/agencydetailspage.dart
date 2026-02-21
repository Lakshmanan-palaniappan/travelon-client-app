import 'package:Travelon/core/utils/services/url_launcher_service.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/agency/domain/entities/agency.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_bloc.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_event.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_state.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart'; // Added AuthBloc import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/apiclient.dart';
import '../../data/datasources/agency_remote_datasource.dart';
import '../../data/repositories/agency_repository_impl.dart';
import '../../domain/usecases/get_agency_details.dart';

class AgencyDetailsPage extends StatelessWidget {
  const AgencyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Extract the agencyId from the AuthBloc state
    final authState = context.read<AuthBloc>().state;
    String agencyId = "0";

    if (authState is AuthSuccess) {
      agencyId = authState.tourist.agencyId.toString();
    }

    return BlocProvider<AgencyDetailsBloc>(
      create:
          (context) => AgencyDetailsBloc(
            getAgencyDetails: GetAgencyDetails(
              AgencyRepositoryImpl(
                AgencyRemoteDataSourceImpl(
                  ApiClient(), // 👈 if ApiClient is provided globally
                  // OR: ApiClient(),          // 👈 if not provided, use this
                ),
              ),
            ),
          )..add(FetchAgencyDetails(int.parse(agencyId))),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: Text(
            "Travel Partner",
            style: TextStyle(color: theme.textTheme.titleLarge?.color),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            onPressed: () {
              context.go('/trips');
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.iconTheme.color,
            ),
          ),
        ),
        body: BlocBuilder<AgencyDetailsBloc, AgencyState>(
          builder: (context, state) {
            if (state is AgencyLoading) {
              return const Center(child: Myloader());
            }

            if (state is AgencyError) {
              return _buildErrorState(theme, state.message);
            }

            if (state is AgencyDetailLoaded) {
              return _buildBody(context, theme, state.agency);
            }

            // Fallback for when the user isn't logged in or ID is missing
            if (agencyId == "0") {
              return _buildErrorState(
                theme,
                "No agency associated with this account.",
              );
            }

            return Center(
              child: Text(
                "Initializing agency details...",
                style: TextStyle(color: theme.textTheme.titleLarge?.color),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── UI SECTIONS ───

  Widget _buildBody(BuildContext context, ThemeData theme, Agency agency) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      children: [
        // HEADER
        Center(
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.business_rounded,
                  size: 50,
                  color: theme.iconTheme.color,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                agency.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Authorized Travel Partner",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // CONTACT INFORMATION
        _buildSectionLabel(theme, "Contact Information"),
        const SizedBox(height: 12),
        _buildInfoCard(context, theme, [
          _buildDetailRow(
            theme,
            Icons.person_outline_rounded,
            "Owner Name",
            agency.ownerName ?? "Not Available",
          ),
          _buildDivider(context),
          _buildDetailRow(
            theme,
            Icons.phone_iphone_rounded,
            "Contact Number",
            agency.contact ?? "Not Available",
            // Pass the buttons here
            callBtn:
                agency.contact != null
                    ? IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed:
                          () =>
                              UrlLauncherService.makePhoneCall(agency.contact!),
                    )
                    : null,
            msgBtn:
                agency.contact != null
                    ? IconButton(
                      icon: Icon(
                        Icons.message,
                        color: theme.colorScheme.tertiary,
                      ),
                      onPressed:
                          () => UrlLauncherService.sendSMS(
                            agency.contact!,
                            "Hi ${agency.name}, I'm interested in your travel services.",
                          ),
                    )
                    : null,
          ),
          _buildDivider(context),
          _buildDetailRow(
            theme,
            Icons.email_outlined,
            "Email Address",
            agency.emailId ?? "Not Available",
          ),
        ]),

        const SizedBox(height: 32),

        // LEGAL SECTION
        _buildSectionLabel(theme, "License & Verification"),
        const SizedBox(height: 12),
        _buildInfoCard(context, theme, [
          _buildDetailRow(
            theme,
            Icons.verified_user_outlined,
            "License Number",
            _maskLicense(agency.licenceNo),
          ),

          _buildDivider(context),
          _buildDetailRow(
            theme,
            Icons.map_outlined,
            "Business Address",
            agency.addressInfo ?? "Not Available",
          ),
          const SizedBox(height: 12),

          // 👇 View License Button
          if (agency.licenceNo != null && agency.licenceNo!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final url = _buildLicenseUrl(context, agency.id);
                    _launchURL(url);
                  },
                  icon: Icon(
                    Icons.picture_as_pdf_outlined,
                    color:
                        theme.brightness == Brightness.dark
                            ? Colors.black
                            : theme.iconTheme.color,
                  ),
                  label: Text(
                    "View Digital License",
                    style: TextStyle(
                      color:
                          theme.brightness == Brightness.dark
                              ? Colors.black
                              : theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
        ]),

        const SizedBox(height: 40),
      ],
    );
  }

  // ─── UI HELPERS ───

  Widget _buildSectionLabel(ThemeData theme, String text) {
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.textTheme?.bodyMedium?.color,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    ThemeData theme,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(
    ThemeData theme,
    IconData icon,
    String label,
    String value, {
    IconButton? callBtn, // Added optional button
    IconButton? msgBtn, // Added optional button
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: theme.iconTheme.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (callBtn != null) callBtn,
              if (msgBtn != null) msgBtn,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) => Divider(
    height: 1,
    indent: 20,
    color: Theme.of(context).dividerColor,
    endIndent: 20,
  );

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text("Oops!", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String _buildLicenseUrl(BuildContext context, int agencyId) {
    // Change this to your API base URL
    const String baseUrl = "http://103.207.1.87:5821/api";
    return "$baseUrl/agency/$agencyId/license";
  }

  String _maskLicense(String? licenseNo) {
    if (licenseNo == null || licenseNo.isEmpty) return "Not Available";

    final digits = licenseNo.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length <= 4) return digits; // fallback safety

    final last4 = digits.substring(digits.length - 4);
    return "XXXX-XXXX-$last4";
  }
}
