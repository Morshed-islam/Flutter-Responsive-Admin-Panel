import 'package:core_dashboard/pages/all_jobs/widgets/jobs_list.dart';
import 'package:flutter/material.dart';
import '../../responsive.dart';
import '../../shared/constants/ghaps.dart';
class AllJobsPage extends StatelessWidget {
  const AllJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!Responsive.isMobile(context)) gapH24,
        Text(
          "All Jobs",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!Responsive.isMobile(context))
              const Expanded(
                flex: 2,
                child: Column(
                  children: [
                    JobsList(),
                    gapH16,
                  ],
                ),
              ),
          ],
        )
      ],
    );
  }
}
