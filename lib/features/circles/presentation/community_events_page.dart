import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/circles_provider.dart';

class CommunityEventsPage extends ConsumerStatefulWidget {
  const CommunityEventsPage({super.key});

  @override
  ConsumerState<CommunityEventsPage> createState() =>
      _CommunityEventsPageState();
}

class _CommunityEventsPageState extends ConsumerState<CommunityEventsPage> {
  late DateTime _visibleMonth;
  DateTime? _selectedDay;
  String _selectedCircleId = 'all';
  String _selectedCategory = 'all';
  String _selectedCity = 'all';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(circlesProvider.notifier);
    final permissions = ref.watch(communityEventCreationPermissionsProvider);
    final monthEvents = ref.watch(circleEventsForMonthProvider(_visibleMonth));
    final pendingEvents = ref.watch(pendingCircleEventsProvider);
    final rejectedEvents = ref.watch(rejectedCircleEventsProvider);
    final eventReportCounts = ref.watch(reportCountByEventProvider);
    final circlesById = {for (final circle in stagedCircles) circle.id: circle};
    final filteredMonthEvents = monthEvents.where((event) {
      final circle = circlesById[event.circleId];
      if (circle == null) return false;
      if (_selectedCircleId != 'all' && circle.id != _selectedCircleId) {
        return false;
      }
      if (_selectedCategory != 'all' && circle.category != _selectedCategory) {
        return false;
      }
      if (_selectedCity != 'all' && circle.city != _selectedCity) {
        return false;
      }
      return true;
    }).toList();
    final selectedDay = _selectedDay ?? _visibleMonth;
    final dayEvents = ref.watch(circleEventsForDayProvider(selectedDay)).where((
      event,
    ) {
      final circle = circlesById[event.circleId];
      if (circle == null) return false;
      if (_selectedCircleId != 'all' && circle.id != _selectedCircleId) {
        return false;
      }
      if (_selectedCategory != 'all' && circle.category != _selectedCategory) {
        return false;
      }
      if (_selectedCity != 'all' && circle.city != _selectedCity) {
        return false;
      }
      return true;
    }).toList();
    final circleOptions = ['all', ...stagedCircles.map((c) => c.id)];
    final categoryOptions = [
      'all',
      ...{for (final circle in stagedCircles) circle.category},
    ];
    final cityOptions = [
      'all',
      ...{for (final circle in stagedCircles) circle.city},
    ];

    return AppPageScaffold(
      headerIcon: Icons.event,
      title: l10n.circlesEventsCalendarTitle,
      subtitle: l10n.circlesEventsCalendarSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesEventFiltersTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _FilterDropdown(
                    label: l10n.circlesFilterCircle,
                    value: _selectedCircleId,
                    options: circleOptions,
                    display: (value) {
                      if (value == 'all') return l10n.circlesFilterAll;
                      final circle = circlesById[value];
                      return circle?.title ?? value;
                    },
                    onChanged: (value) =>
                        setState(() => _selectedCircleId = value),
                  ),
                  _FilterDropdown(
                    label: l10n.circlesFilterCategory,
                    value: _selectedCategory,
                    options: categoryOptions,
                    display: (value) =>
                        value == 'all' ? l10n.circlesFilterAll : value,
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
                  ),
                  _FilterDropdown(
                    label: l10n.circlesFilterCity,
                    value: _selectedCity,
                    options: cityOptions,
                    display: (value) =>
                        value == 'all' ? l10n.circlesFilterAll : value,
                    onChanged: (value) => setState(() => _selectedCity = value),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        _openCreateEventDialog(context, l10n, notifier),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.circlesCreateEvent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _visibleMonth = DateTime(
                          _visibleMonth.year,
                          _visibleMonth.month - 1,
                          1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Expanded(
                    child: Text(
                      '${_monthLabel(_visibleMonth.month)} ${_visibleMonth.year}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _visibleMonth = DateTime(
                          _visibleMonth.year,
                          _visibleMonth.month + 1,
                          1,
                        );
                      });
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _MonthGrid(
                visibleMonth: _visibleMonth,
                events: filteredMonthEvents,
                selectedDay: _selectedDay,
                onSelectDay: (day) => setState(() => _selectedDay = day),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.circlesCreatedEventsStatusTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.circlesCreatedEventsStatusBody(
                  pendingEvents.length,
                  rejectedEvents.length,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                permissions.canSubmitModeratorEvent
                    ? l10n.circlesModeratorCreateReady
                    : l10n.circlesModeratorCreatePending,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (dayEvents.isEmpty)
          PremiumCard(child: Text(l10n.circlesNoEvents))
        else
          ...dayEvents.map((event) {
            final attendance = ref.watch(
              circleEventAttendanceProvider(event.id),
            );
            final roster = ref.watch(
              circleEventRosterPreviewProvider(event.id),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (event.createdByRole ==
                            CircleEventCreatorRole.mosqueModerator &&
                        event.status == CircleEventStatus.approved)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7F2EA),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.circlesMosqueVerifiedBadge,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E6B43),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(event.description),
                    const SizedBox(height: 8),
                    Text('${_dateLabel(event.date)} • ${event.location}'),
                    const SizedBox(height: 8),
                    Text(
                      l10n.circlesEventCapacity(
                        attendance.goingCount,
                        attendance.capacity,
                        attendance.interestedCount,
                      ),
                    ),
                    if (attendance.waitlistActive)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l10n.circlesWaitlistActive,
                          style: const TextStyle(color: Color(0xFF8A5E1A)),
                        ),
                      ),
                    if ((eventReportCounts[event.id] ?? 0) > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l10n.circlesEventReportCount(
                            eventReportCounts[event.id] ?? 0,
                          ),
                          style: const TextStyle(color: Color(0xFF8A5E1A)),
                        ),
                      ),
                    if (event.approvedByLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          l10n.circlesEventApprovedAudit(
                            event.approvedByLabel!,
                            (event.approvedAtIso ?? '').split('T').first,
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.circlesRosterPreviewTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.circlesRosterGoingPreview(
                        roster.goingNames.join(', '),
                      ),
                    ),
                    Text(
                      l10n.circlesRosterInterestedPreview(
                        roster.interestedNames.join(', '),
                      ),
                    ),
                    if (roster.waitlistCount > 0)
                      Text(
                        l10n.circlesRosterWaitlistCount(roster.waitlistCount),
                        style: const TextStyle(color: Color(0xFF8A5E1A)),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _RsvpChip(
                          label: l10n.circlesRsvpGoing,
                          selected: ref.watch(
                            circlesProvider.select(
                              (state) =>
                                  state.eventRsvpById[event.id] ==
                                  CircleEventRsvpStatus.going,
                            ),
                          ),
                          onTap: () => notifier.setEventRsvp(
                            event.id,
                            CircleEventRsvpStatus.going,
                          ),
                        ),
                        _RsvpChip(
                          label: l10n.circlesRsvpInterested,
                          selected: ref.watch(
                            circlesProvider.select(
                              (state) =>
                                  state.eventRsvpById[event.id] ==
                                  CircleEventRsvpStatus.interested,
                            ),
                          ),
                          onTap: () => notifier.setEventRsvp(
                            event.id,
                            CircleEventRsvpStatus.interested,
                          ),
                        ),
                        _RsvpChip(
                          label: l10n.circlesRsvpNotGoing,
                          selected: ref.watch(
                            circlesProvider.select(
                              (state) =>
                                  state.eventRsvpById[event.id] ==
                                  CircleEventRsvpStatus.notGoing,
                            ),
                          ),
                          onTap: () => notifier.setEventRsvp(
                            event.id,
                            CircleEventRsvpStatus.notGoing,
                          ),
                        ),
                        _RsvpChip(
                          label: l10n.circlesReport,
                          selected: false,
                          onTap: () {
                            notifier.addReport(
                              targetType: 'event',
                              targetId: event.id,
                              reason: 'policy',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.circlesReportSubmitted),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  String _monthLabel(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _dateLabel(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = (date.hour % 12 == 0 ? 12 : date.hour % 12).toString().padLeft(
      2,
      '0',
    );
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.year}-$month-$day $hour:$minute $suffix';
  }

  Future<void> _openCreateEventDialog(
    BuildContext context,
    AppLocalizations l10n,
    CirclesNotifier notifier,
  ) async {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    final creatorController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    int capacity = 20;
    String selectedCircle = stagedCircles.first.id;
    CircleEventCreatorRole selectedRole = CircleEventCreatorRole.user;
    final permissions = ref.read(communityEventCreationPermissionsProvider);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(l10n.circlesCreateEvent),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.circlesCreateEventModerationHint),
                    const SizedBox(height: 10),
                    _DialogField(
                      controller: titleController,
                      label: l10n.circlesCreateEventTitleLabel,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCircle,
                      decoration: InputDecoration(
                        labelText: l10n.circlesFilterCircle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: stagedCircles
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text(item.title),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => selectedCircle = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _DialogField(
                      controller: locationController,
                      label: l10n.circlesCreateEventLocationLabel,
                    ),
                    const SizedBox(height: 8),
                    _DialogField(
                      controller: descriptionController,
                      label: l10n.circlesCreateEventDescriptionLabel,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 8),
                    _DialogField(
                      controller: creatorController,
                      label: l10n.circlesCreateEventCreatorLabel,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<CircleEventCreatorRole>(
                      initialValue: selectedRole,
                      decoration: InputDecoration(
                        labelText: l10n.circlesCreateEventRoleLabel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: CircleEventCreatorRole.user,
                          child: Text(l10n.circlesCreateEventRoleUser),
                        ),
                        DropdownMenuItem(
                          value: CircleEventCreatorRole.mosqueModerator,
                          child: Text(l10n.circlesCreateEventRoleModerator),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => selectedRole = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (pickedDate == null || !context.mounted) return;
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (pickedTime == null || !context.mounted) return;
                        setModalState(() {
                          selectedDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      },
                      icon: const Icon(Icons.event_available_outlined),
                      label: Text(
                        l10n.circlesCreateEventDateValue(
                          _dateLabel(selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.circlesCreateEventCapacityLabel(capacity),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Slider(
                      value: capacity.toDouble(),
                      min: 5,
                      max: 200,
                      divisions: 39,
                      label: '$capacity',
                      onChanged: (value) =>
                          setModalState(() => capacity = value.round()),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.quranCancel),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final location = locationController.text.trim();
                    final description = descriptionController.text.trim();
                    if (title.isEmpty ||
                        location.isEmpty ||
                        description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.circlesCreateEventValidation),
                        ),
                      );
                      return;
                    }
                    notifier.createEvent(
                      circleId: selectedCircle,
                      title: title,
                      date: selectedDate,
                      location: location,
                      capacity: capacity,
                      description: description,
                      role: selectedRole,
                      creatorLabel: creatorController.text.trim().isEmpty
                          ? null
                          : creatorController.text.trim(),
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          selectedRole == CircleEventCreatorRole.user ||
                                  !permissions.canSubmitModeratorEvent
                              ? l10n.circlesCreateEventPendingReview
                              : l10n.circlesCreateEventSuccess,
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.circlesCreateEventSubmit),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.visibleMonth,
    required this.events,
    required this.selectedDay,
    required this.onSelectDay,
  });

  final DateTime visibleMonth;
  final List<CircleCalendarEvent> events;
  final DateTime? selectedDay;
  final ValueChanged<DateTime> onSelectDay;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final leadingEmpty = (firstDay.weekday + 6) % 7;

    final eventCountByDay = <int, int>{};
    for (final event in events) {
      eventCountByDay[event.date.day] =
          (eventCountByDay[event.date.day] ?? 0) + 1;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: leadingEmpty + daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index < leadingEmpty) {
          return const SizedBox.shrink();
        }
        final day = index - leadingEmpty + 1;
        final date = DateTime(visibleMonth.year, visibleMonth.month, day);
        final selected =
            selectedDay != null &&
            selectedDay!.year == date.year &&
            selectedDay!.month == date.month &&
            selectedDay!.day == date.day;
        final count = eventCountByDay[day] ?? 0;

        return InkWell(
          onTap: () => onSelectDay(date),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFE9DFC8)
                  : const Color(0xFFF8F3EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCCBA8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RsvpChip extends StatelessWidget {
  const _RsvpChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final String Function(String) display;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<String>(
        initialValue: options.contains(value) ? value : options.first,
        decoration: InputDecoration(
          isDense: true,
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: options
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(display(item), overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
