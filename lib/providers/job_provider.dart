import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/job.dart';

class JobProvider extends ChangeNotifier {
  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;
  Job? _selectedJob;
  Job? get selectedJob => _selectedJob;

  int? _totalJobCount;
  int? get totalJobCount => _totalJobCount;
  JobProvider() {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      // Firestore reference to the jobs collection
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .get();

      // Convert Firestore data to Job objects
      _jobs = snapshot.docs.map((doc) => Job.fromFirestore(doc.data() as Map<String, dynamic>)).toList();

      notifyListeners(); // Notify listeners after fetching data
    } catch (e) {
      print('Error fetching jobs: $e');
    }
  }


  Future<void> getTotalJobsCount() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('jobs').get();
    _totalJobCount = snapshot.size;
  }

  // Update the job in Firestore
  Future<void> updateJob(String jobId, Job updatedJob) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
        'title': updatedJob.title,
        'salary': updatedJob.salary,
        'experience': updatedJob.experience,
        'employee': updatedJob.employee,
        'location': updatedJob.location,
        'job_details': updatedJob.details,
        'deadline': updatedJob.deadline.isNotEmpty ? Timestamp.fromDate(DateTime.parse(updatedJob.deadline)) : '',
        'createdDate': updatedJob.createdDate.isNotEmpty ? Timestamp.fromDate(DateTime.parse(updatedJob.createdDate)) : '',
      });
      notifyListeners();
    } catch (e) {
      print('Error updating job: $e');
    }
  }


  // Fetch a single job for editing
  Future<void> fetchJob(String jobId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('jobs').doc(jobId).get();
      _selectedJob = Job.fromFirestore(doc.data() as Map<String, dynamic>);
      notifyListeners();
    } catch (e) {
      print('Error fetching job: $e');
    }
  }

}
