import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/geofence_alert_bloc.dart';
import '../bloc/geofence_alert_event.dart';
import '../bloc/geofence_alert_state.dart';
import '../../domain/entities/geofence_alert.dart';
import '../../../../core/utils/widgets/MyLoader.dart';

class GeofenceAlertsPage extends StatefulWidget {
  const GeofenceAlertsPage({super.key});

  @override
  State<GeofenceAlertsPage> createState() => _GeofenceAlertsPageState();
}

class _GeofenceAlertsPageState extends State<GeofenceAlertsPage> {
  String _severityFilter = "ALL"; // ALL, HIGH, MEDIUM, LOW
  DateTime? _filterDate; // exact date filter

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          "Geofence Alerts",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(onPressed: ()=>context.pop(), icon: Icon(Icons.arrow_back_ios,color: theme.iconTheme.color,)),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded,color: theme.iconTheme.color,),
            onPressed: () => _openFilterSheet(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: BlocBuilder<GeofenceAlertBloc, GeofenceAlertState>(
            builder: (context, state) {
              final filter = state is GeofenceAlertLoaded
                  ? state.filter
                  : GeofenceFilter.all;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    _statusChip(
                      context,
                      "All",
                      filter == GeofenceFilter.all,
                          () => context.read<GeofenceAlertBloc>().add(
                        ChangeGeofenceFilter(GeofenceFilter.all),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusChip(
                      context,
                      "Open",
                      filter == GeofenceFilter.open,
                          () => context.read<GeofenceAlertBloc>().add(
                        ChangeGeofenceFilter(GeofenceFilter.open),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusChip(
                      context,
                      "Resolved",
                      filter == GeofenceFilter.resolved,
                          () => context.read<GeofenceAlertBloc>().add(
                        ChangeGeofenceFilter(GeofenceFilter.resolved),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: BlocProvider.value(
        value: context.read<GeofenceAlertBloc>()..add(LoadGeofenceAlerts()),
        child: BlocBuilder<GeofenceAlertBloc, GeofenceAlertState>(
          builder: (context, state) {
            if (state is GeofenceAlertInitial || state is GeofenceAlertLoading) {
              return const Center(child: Myloader());
            }

            if (state is GeofenceAlertError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }

            if (state is GeofenceAlertLoaded) {
              var alerts = List<GeofenceAlert>.from(state.filtered)
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              // 🎚 Severity filter
              if (_severityFilter != "ALL") {
                alerts = alerts
                    .where((a) =>
                a.severity.toUpperCase() == _severityFilter)
                    .toList();
              }

              // 📅 Date filter
              if (_filterDate != null) {
                alerts = alerts.where((a) {
                  final d = a.createdAt;
                  return d.year == _filterDate!.year &&
                      d.month == _filterDate!.month &&
                      d.day == _filterDate!.day;
                }).toList();
              }

              return RefreshIndicator(
                color: theme.colorScheme.tertiary,
                onRefresh: () async {
                  context
                      .read<GeofenceAlertBloc>()
                      .add(LoadGeofenceAlerts());
                  await Future.delayed(const Duration(milliseconds: 400));
                },
                child: alerts.isEmpty
                    ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 160),
                    Center(child: Text("No alerts found")),
                  ],
                )
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _GeofenceAlertCard(alert: alert),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ---------------- FILTER UI ----------------

  void _openFilterSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        String tempSeverity = _severityFilter;
        DateTime? tempDate = _filterDate;

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Text(
                        "Filter Alerts",
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            tempSeverity = "ALL";
                            tempDate = null;
                          });
                        },
                        child: Text("Clear",style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color
                        ),),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Severity
                  Text("Severity",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: ["ALL", "HIGH", "MEDIUM", "LOW"].map((s) {
                      final selected = tempSeverity == s;
                      return ChoiceChip(
                        label: Text(s),
                        selected: selected,
                        onSelected: (_) {
                          setModalState(() => tempSeverity = s);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Date
                  Text("Date",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tempDate == null
                              ? "Any date"
                              : "${tempDate!.day}/${tempDate!.month}/${tempDate!.year}",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: tempDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              final theme = Theme.of(context);

                              return Theme(
                                data: theme.copyWith(
                                  colorScheme: theme.colorScheme.copyWith(
                                    primary: theme.colorScheme.tertiary,       // Header & selected date
                                    onPrimary: theme.colorScheme.onTertiary,    // Text on header
                                    surface: theme.colorScheme.surface,         // Dialog background
                                    onSurface: theme.textTheme.bodyLarge?.color ?? Colors.black, // Text color
                                  ),
                                  dialogBackgroundColor: theme.colorScheme.surface,
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: theme.colorScheme.tertiary, // OK / CANCEL buttons
                                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20), // Rounded dialog
                                  child: child!,
                                ),
                              );
                            },
                          );

                          if (picked != null) {
                            setModalState(() => tempDate = picked);
                          }

                        },
                        icon: Icon(Icons.calendar_today_outlined, size: 18,color: theme.iconTheme.color),
                        label: Text("Pick",style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color
                        ),),
                      ),
                      if (tempDate != null)
                        IconButton(
                          icon: Icon(Icons.close,color: theme.iconTheme.color),
                          onPressed: () {
                            setModalState(() => tempDate = null);
                          },
                        ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _severityFilter = tempSeverity;
                          _filterDate = tempDate;
                        });
                        Navigator.pop(context);
                      },
                      child: Text("Apply Filters",style: TextStyle(
                          color: Colors.black
                      ),),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusChip(
      BuildContext context,
      String label,
      bool selected,
      VoidCallback onTap,
      ) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: theme.colorScheme.tertiary,
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: TextStyle(
        color: selected
            ? theme.textTheme.titleLarge?.color
            : theme.textTheme.bodyMedium?.color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ---------------- CARD ----------------

class _GeofenceAlertCard extends StatelessWidget {
  final GeofenceAlert alert;

  const _GeofenceAlertCard({required this.alert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = _severityColor(alert.severity, theme);
    final isResolved = alert.isResolved;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left severity strip
          Container(
            width: 6,
            height: 140,
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: severityColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.placeName ?? "Unknown Place",
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formatDateTime(alert.createdAt),
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      _statusPill(isResolved),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    alert.message,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _detailRow("Alert", alert.alertType, null),
                  _detailRow("Severity", alert.severity, severityColor),
                  _detailRow(
                      "Distance", "${alert.distanceMeters ?? '-'} m", null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(bool isResolved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isResolved ? Colors.green : Colors.red,
        ),
        color: (isResolved ? Colors.green : Colors.red).withOpacity(0.08),
      ),
      child: Text(
        isResolved ? "Resolved" : "Open",
        style: TextStyle(
          color: isResolved ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _severityColor(String severity, ThemeData theme) {
    switch (severity.toUpperCase()) {
      case "HIGH":
        return Colors.redAccent;
      case "MEDIUM":
        return Colors.orangeAccent;
      case "LOW":
        return Colors.blueAccent;
      default:
        return theme.colorScheme.primary;
    }
  }

  Widget _detailRow(String label, String value, Color? valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight:
                valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }
}
