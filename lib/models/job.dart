class Job {
  final String? id;
  final String title;
  final String createdDate;
  final String deadline;
  final String salary;
  final String experience;
  final String employee;
  final String location;
  final String details;

  Job({
    this.id,
    required this.title,
    required this.createdDate,
    required this.deadline,
    required this.salary,
    required this.experience,
    required this.employee,
    required this.location,
    required this.details,
  });

  factory Job.fromFirestore(Map<String, dynamic> data) {
    return Job(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      createdDate: data['createdDate'] ?? '',
      deadline: data['deadline'] ?? '',
      salary: data['salary'] ?? '',
      experience: data['experience'] ?? '',
      employee: data['employee'] ?? '',
      location: data['location'] ?? '',
      details: data['job_details'] ?? '',
    );
  }
}
