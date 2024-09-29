import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class AddJobProvider extends ChangeNotifier {
  // TextEditingController for form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController employeeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final QuillEditorController quillController = QuillEditorController();


  DateTime? deadline;
  File? _imageFile;
  bool _isUploading = false;

  String? _quillText;
  String? get quillText => _quillText;

  File? get imageFile => _imageFile;
  bool get isUploading => _isUploading;

  // Pick image from gallery
  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _imageFile = File(pickedImage.path);
      notifyListeners();
    }
  }

  // Pick date for deadline
  Future<void> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      deadline = selectedDate;
      notifyListeners();
    }
  }

  // Upload image to Firebase Storage
  // Future<String?> uploadImage() async {
  //   if (_imageFile == null) return null;
  //   final storageRef = FirebaseStorage.instance
  //       .ref()
  //       .child('job_images/${DateTime.now().millisecondsSinceEpoch}.png');
  //   final uploadTask = storageRef.putFile(_imageFile!);
  //   final snapshot = await uploadTask.whenComplete(() => null);
  //   return await snapshot.ref.getDownloadURL();
  // }

  // Submit job post to Firestore
  Future<void> submitJob(BuildContext context) async {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    getHtmlText();
    _isUploading = true;
    notifyListeners();


    try {
      String? imageUrl =  '';
      // String? imageUrl = await uploadImage();

      // Get a reference to a new document in the jobs collection
      DocumentReference docRef = FirebaseFirestore.instance.collection('jobs').doc();

      // Use the generated document ID
      String documentId = docRef.id;

      // Save the job data to Firestore with the generated document ID
      await docRef.set({
        'id': documentId,  // Store the document ID in the Firestore document
        'title': titleController.text,
        // 'salary': salaryController.text,
        // 'experience': experienceController.text,
        // 'employee': employeeController.text,
        // 'location': locationController.text,
        'details': quillText,
        // 'deadline': deadline != null ? DateTime(deadline?.year ?? DateTime.now().year, deadline?.month ?? DateTime.now().month+2, deadline?.day ?? DateTime.now().day +20).toLocal().toString() : null,
        'createdDate': DateTime.now().toLocal().toString(),
        'imageUrl': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job added successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));

    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void getHtmlText() async {
    String? htmlText = await quillController.getText();
    _quillText = htmlText;
    debugPrint(htmlText);
  }

  // Dispose controllers
  @override
  void dispose() {
    titleController.dispose();
    salaryController.dispose();
    experienceController.dispose();
    employeeController.dispose();
    locationController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText1() async {
    String? htmlText = await quillController.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await quillController.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await quillController.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await quillController.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await quillController.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => quillController.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => quillController.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => quillController.unFocus();


}
