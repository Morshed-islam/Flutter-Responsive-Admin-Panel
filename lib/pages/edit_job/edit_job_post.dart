import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/job.dart';
import '../../providers/job_provider.dart';
import '../../responsive.dart';
import '../../shared/constants/defaults.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/sidemenu/sidebar.dart';

class EditJobPage extends StatefulWidget {
  final String? jobId;

  const EditJobPage({Key? key, this.jobId}) : super(key: key);

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime? deadline;
  DateTime? createdDate;

  @override
  void initState() {
    super.initState();
    _loadJobData();
  }

  Future<void> _loadJobData() async {
    await Provider.of<JobProvider>(context, listen: false).fetchJob(widget.jobId ?? "");
    final job = Provider.of<JobProvider>(context, listen: false).selectedJob;
    if (job != null) {
      setState(() {
        titleController.text = job.title;
        salaryController.text = job.salary;
        experienceController.text = job.experience;
        employeeController.text = job.employee;
        locationController.text = job.location;
        detailsController.text = job.details;
        deadline = DateTime.parse(job.deadline);
        createdDate = DateTime.parse(job.createdDate);
      });
    }
  }

  Future<void> _pickDate(BuildContext context, bool isDeadline) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        if (isDeadline) {
          deadline = selectedDate;
        } else {
          createdDate = selectedDate;
        }
      });
    }
  }

  Future<void> _saveJob() async {
    if (_formKey.currentState!.validate()) {
      Job updatedJob = Job(

        title: titleController.text,
        salary: salaryController.text,
        experience: experienceController.text,
        employee: employeeController.text,
        location: locationController.text,
        details: detailsController.text,
        deadline: deadline?.toIso8601String() ?? "",
        createdDate: createdDate?.toIso8601String() ?? "",
      );

      await Provider.of<JobProvider>(context, listen: false).updateJob(widget.jobId ?? "", updatedJob);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Responsive.isDesktop(context) ? const Sidebar() : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              if (Responsive.isDesktop(context)) const Sidebar(),

              Expanded(
                child: Column(
                  children: [
                    Header(drawerKey: _drawerKey),
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1360),
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDefaults.padding * (Responsive.isMobile(context) ? 1 : 1.5),
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: titleController,
                                    decoration: const InputDecoration(labelText: 'Job Title'),
                                    validator: (value) => value!.isEmpty ? 'Please enter a job title' : null,
                                  ),
                                  TextFormField(
                                    controller: salaryController,
                                    decoration: const InputDecoration(labelText: 'Salary'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty ? 'Please enter a salary' : null,
                                  ),
                                  TextFormField(
                                    controller: experienceController,
                                    decoration: const InputDecoration(labelText: 'Experience'),
                                  ),
                                  TextFormField(
                                    controller: employeeController,
                                    decoration: const InputDecoration(labelText: 'Employee'),
                                  ),
                                  TextFormField(
                                    controller: locationController,
                                    decoration: const InputDecoration(labelText: 'Location'),
                                  ),
                                  TextFormField(
                                    controller: detailsController,
                                    decoration: const InputDecoration(labelText: 'Details'),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Deadline',
                                      hintText: deadline != null ? DateFormat('dd/MM/yyyy').format(deadline!) : 'Pick deadline',
                                    ),
                                    onTap: () => _pickDate(context, true),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Created Date',
                                      hintText: createdDate != null ? DateFormat('dd/MM/yyyy').format(createdDate!) : 'Pick created date',
                                    ),
                                    onTap: () => _pickDate(context, false),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _saveJob,
                                    child: const Text('Save Job'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
