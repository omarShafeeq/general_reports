import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/filter/report_filter_bloc.dart';
import '../blocs/filter/report_filter_state.dart';
import '../models/report_definition.dart';

/// DevExpress-style report document header with title, contact info, and metadata box.
class ReportDocumentHeader extends StatelessWidget {
  final ReportDefinition report;

  const ReportDocumentHeader({super.key, required this.report});

  static const _teal = Color(0xFF00897B);
  static const _borderColor = Color(0xFFB0BEC5);

  @override
  Widget build(BuildContext context) {
    final header = report.exportOptions.header;
    final meta = report.metadata;
    final companyName = header?.companyName ??
        meta['companyName'] as String? ??
        'IX Corporation';
    final address = meta['address'] as String? ?? '123 Main Street';
    final city = meta['city'] as String? ?? 'Anytown, ST 12345';
    final phone = meta['phone'] as String? ?? '(555) 123-4567';
    final email = meta['email'] as String? ?? 'info@ix.com';
    final website = meta['website'] as String? ?? 'www.ix.com';

    return BlocBuilder<ReportFilterBloc, ReportFilterState>(
      builder: (context, filterState) {
        final dateRange = _formatDateRange(filterState);
        final printedOn = DateFormat('M/d/yyyy h:mm:ss a').format(DateTime.now());

        return Padding(
          padding: const EdgeInsets.fromLTRB(48, 40, 48, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                report.exportOptions.title ?? report.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF212121),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (header?.showCompanyName != false)
                          Text(
                            companyName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF424242),
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          address,
                          style: _contactStyle,
                        ),
                        Text(city, style: _contactStyle),
                        const SizedBox(height: 4),
                        Text('Phone: $phone', style: _contactStyle),
                        Text('Email: $email', style: _contactStyle),
                        Text('Website: $website', style: _contactStyle),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  _MetadataBox(
                    dateRange: dateRange,
                    printedOn: printedOn,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 3,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_teal, Color(0xFF4DB6AC)],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const _contactStyle = TextStyle(
    fontSize: 12,
    height: 1.5,
    color: Color(0xFF616161),
  );

  String _formatDateRange(ReportFilterState filterState) {
    for (final entry in filterState.values.entries) {
      final value = entry.value;
      if (value is Map && value.containsKey('start') && value.containsKey('end')) {
        final start = value['start'];
        final end = value['end'];
        if (start != null && end != null) {
          return '${_formatDate(start)} - ${_formatDate(end)}';
        }
      }
    }
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return '${DateFormat('M/d/yyyy').format(start)} - ${DateFormat('M/d/yyyy').format(now)}';
  }

  String _formatDate(dynamic value) {
    if (value is DateTime) {
      return DateFormat('M/d/yyyy').format(value);
    }
    if (value is String) {
      try {
        return DateFormat('M/d/yyyy').format(DateTime.parse(value));
      } catch (_) {
        return value;
      }
    }
    return value.toString();
  }
}

class _MetadataBox extends StatelessWidget {
  final String dateRange;
  final String printedOn;

  const _MetadataBox({
    required this.dateRange,
    required this.printedOn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: ReportDocumentHeader._borderColor),
        borderRadius: BorderRadius.circular(2),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaRow(label: 'Date Range:', value: dateRange),
          const SizedBox(height: 6),
          _MetaRow(label: 'Printed on:', value: printedOn),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 11, height: 1.4, color: Color(0xFF424242)),
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
