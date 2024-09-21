import 'package:core_dashboard/pages/all_jobs/widgets/jobs_items.dart';
import 'package:core_dashboard/shared/constants/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/job.dart';
import '../../../providers/job_provider.dart';
import '../../../shared/constants/constants.dart';

class JobsList extends StatelessWidget {
  const JobsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        List<Job> jobs = jobProvider.jobs;

        if (jobs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jobs Title'),
                    Text('Deadline'),
                    Text('Created date'),
                  ],
                ),
              ),
              const Divider(),
              ListView.builder(
                itemCount: jobs.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  Job job = jobs[index];
                  return JobsItems(
                    title: job.title,
                    createdDate: job.createdDate,
                    deadline: job.deadline,
                    onPressed: (){
                      Navigator.pushNamed(context, RouteNames.editPageRoute, arguments: job.id);
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },


    );
  }
}
