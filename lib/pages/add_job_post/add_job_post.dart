import 'dart:developer';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import '../../providers/add_job_post_provider.dart';
import '../../responsive.dart';
import '../../shared/constants/defaults.dart';
import '../../shared/widgets/header.dart';
import '../../shared/widgets/sidemenu/sidebar.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();



  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: Colors.black),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.maxFinite,
        // color: _toolbarColor,
        padding: const EdgeInsets.all(8),
        child: Consumer<AddJobProvider>(
          builder: (context, provider1, child) {
            return Wrap(
              children: [
                textButton(
                    text: 'Set Text',
                    onPressed: () {
                      // setHtmlText('This text is set by you 🫵');
                    }),
                textButton(
                    text: 'Get Text',
                    onPressed: () {
                      // getHtmlText();
                    }),
                textButton(
                    text: 'Insert Video',
                    onPressed: () {
                      ////insert
                      provider1.insertVideoURL(
                          'https://www.youtube.com/watch?v=4AoFA19gbLo');
                      provider1.insertVideoURL('https://vimeo.com/440421754');
                      provider1.insertVideoURL(
                          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4');
                    }),
                textButton(
                    text: 'Insert Image',
                    onPressed: () {
                      provider1.insertNetworkImage('https://i.imgur.com/0DVAOec.gif');
                    }),
                textButton(
                    text: 'Insert Index',
                    onPressed: () {
                      provider1.insertHtmlText("This text is set by the insertText method",
                          index: 10);
                    }),
                textButton(
                    text: 'Undo',
                    onPressed: () {
                      provider1.quillController.undo();
                    }),
                textButton(
                    text: 'Redo',
                    onPressed: () {
                      provider1.quillController.redo();
                    }),
                textButton(
                    text: 'Clear History',
                    onPressed: () async {
                      provider1..quillController.clearHistory();
                    }),
                textButton(
                    text: 'Clear Editor',
                    onPressed: () {
                      provider1.quillController.clear();
                    }),
                textButton(
                    text: 'Get Delta',
                    onPressed: () async {
                      var delta = await provider1.quillController.getDelta();
                      debugPrint('delta');
                      // debugPrint(jsonEncode(delta));
                    }),
                textButton(
                    text: 'Set Delta',
                    onPressed: () {
                      final Map<dynamic, dynamic> deltaMap = {
                        "ops": [
                          {
                            "insert": {
                              "video":
                              "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
                            }
                          },
                          {
                            "insert": {
                              "video": "https://www.youtube.com/embed/4AoFA19gbLo"
                            }
                          },
                          {"insert": "Hello"},
                          {
                            "attributes": {"header": 1},
                            "insert": "\n"
                          },
                          {"insert": "You just set the Delta text 😊\n"}
                        ]
                      };
                      provider1.quillController.setDelta(deltaMap);
                    }),

                provider1.isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: () {

                    provider1.submitJob(context);
                  },
                  child: const Text('Submit Job'),
                ),
              ],
            );
          }
        ),
      ),
      resizeToAvoidBottomInset: true,
      key: _drawerKey,
      drawer: Responsive.isDesktop(context) ? const Sidebar() : null,
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) const Sidebar(),
          // if (Responsive.isTablet(context)) const TabSidebar(),
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
                          child: SafeArea(
                            child: Consumer<AddJobProvider>(
                              builder: (context, provider, child) {
                                return Form(
                                  child: SizedBox(
                                    child: Column(
                                      children: [

                                        Container(
                                          margin: const EdgeInsets.only(top: 15,left: 12,right: 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey),
                                            color: Colors.white
                                          ),
                                          child: TextFormField(
                                            controller: provider.titleController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: const InputDecoration(
                                              label: Text('Job Title'),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                borderSide: BorderSide(color: Colors.grey),

                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20,),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0,right: 16),
                                          child: ToolBar(
                                            // toolBarColor: _toolbarColor,
                                            padding: const EdgeInsets.all(8),
                                            iconSize: 25,
                                            // iconColor: _toolbarIconColor,
                                            activeIconColor: Colors.greenAccent.shade400,
                                            controller: provider.quillController,
                                            crossAxisAlignment: WrapCrossAlignment.start,
                                            direction: Axis.horizontal,
                                            customButtons: [
                                              Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    // color: _hasFocus ? Colors.green : Colors.grey,
                                                    borderRadius: BorderRadius.circular(15)),
                                              ),
                                              // const InkWell(
                                              //     // onTap: () => unFocusEditor(),
                                              //     child: Icon(
                                              //       Icons.favorite,
                                              //       color: Colors.black,
                                              //     )),
                                              // InkWell(
                                              //     onTap: () async {
                                              //       // var selectedText = await controller.getSelectedText();
                                              //       // debugPrint('selectedText $selectedText');
                                              //       // var selectedHtmlText =
                                              //       // await controller.getSelectedHtmlText();
                                              //       // debugPrint('selectedHtmlText $selectedHtmlText');
                                              //     },
                                              //     child: const Icon(
                                              //       Icons.add_circle,
                                              //       color: Colors.black,
                                              //     )),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 12.0,right: 16),
                                          child: QuillHtmlEditor(
                                            text: "<h1>Hello</h1>This is jobPost editor example 😊",
                                            hintText: 'Hint text goes here',
                                            controller: provider.quillController,
                                            isEnabled: true,
                                            ensureVisible: false,
                                            minHeight: 500,
                                            autoFocus: false,
                                            // textStyle: _editorTextStyle,
                                            // hintTextStyle: _hintTextStyle,
                                            hintTextAlign: TextAlign.start,
                                            padding: const EdgeInsets.only(left: 10, top: 10),
                                            hintTextPadding: const EdgeInsets.only(left: 20),
                                            // backgroundColor: _backgroundColor,
                                            inputAction: InputAction.newline,
                                            onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                            loadingBuilder: (context) {
                                              return const Center(
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.red,
                                                  ));
                                            },
                                            onFocusChanged: (focus) {
                                              debugPrint('has focus $focus');
                                              setState(() {
                                                // _hasFocus = focus;
                                              });
                                            },
                                            onTextChanged: (text) => debugPrint('widget text change $text'),
                                            onEditorCreated: () {
                                              debugPrint('Editor has been loaded');
                                              // setHtmlText('Testing text on load');
                                            },
                                            onEditorResized: (height) =>
                                                debugPrint('Editor resized $height'),
                                            onSelectionChanged: (sel) =>
                                                debugPrint('index ${sel.index}, range ${sel.length}'),
                                          ),
                                        ),


                                      /*  ToolBar(
                                          toolBarColor: Colors.cyan.shade50,
                                          activeIconColor: Colors.green,
                                          padding: const EdgeInsets.all(8),
                                          iconSize: 20,
                                          controller: provider.quillController,
                                          // customButtons: [
                                          //   InkWell(onTap: () {}, child: const Icon(Icons.favorite)),
                                          //   InkWell(onTap: () {}, child: const Icon(Icons.add_circle)),
                                          // ],
                                        ),

                                        QuillHtmlEditor(
                                          text: "<h1>Hello</h1>This is a quill html editor example 😊",
                                          hintText: 'Hint text goes here',
                                          controller: provider.quillController,
                                          isEnabled: true,
                                          minHeight: 300,
                                          // textStyle: _editorTextStyle,
                                          // hintTextStyle: _hintTextStyle,
                                          hintTextAlign: TextAlign.start,
                                          padding: const EdgeInsets.only(left: 10, top: 5),
                                          hintTextPadding: EdgeInsets.zero,
                                          // backgroundColor: _backgroundColor,
                                          onFocusChanged: (hasFocus) => debugPrint('has focus $hasFocus'),
                                          onTextChanged: (text) => debugPrint('widget text change $text'),
                                          onEditorCreated: () => debugPrint('Editor has been loaded'),
                                          onEditingComplete: (s) => debugPrint('Editing completed $s'),
                                          onEditorResized: (height) =>
                                              debugPrint('Editor resized $height'),
                                          onSelectionChanged: (sel) =>
                                              debugPrint('${sel.index},${sel.length}'),
                                          loadingBuilder: (context) {
                                            return const Center(
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 0.4,
                                                ));},
                                        ),*/

                                       /* TextFormField(
                                          controller: provider.salaryController,
                                          decoration: const InputDecoration(labelText: 'Salary'),
                                          keyboardType: TextInputType.number,
                                        ),
                                        TextFormField(
                                          controller: provider.experienceController,
                                          decoration: const InputDecoration(labelText: 'Experience'),
                                        ),
                                        TextFormField(
                                          controller: provider.employeeController,
                                          decoration: const InputDecoration(labelText: 'Employee'),
                                        ),
                                        TextFormField(
                                          controller: provider.locationController,
                                          decoration: const InputDecoration(labelText: 'Location'),
                                        ),
                                        TextFormField(
                                          controller: provider.detailsController,
                                          decoration: const InputDecoration(labelText: 'Details'),
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            labelText: 'Deadline',
                                            hintText: provider.deadline != null ? DateFormat('dd/MM/yyyy').format(provider.deadline!) : 'Pick deadline',
                                          ),
                                          onTap: () => provider.pickDate(context),
                                        ),*/
                                        const SizedBox(height: 16),
                                        GestureDetector(
                                          onTap: provider.pickImage,
                                          child: Container(
                                            height: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: provider.imageFile == null ? const Center(child: Text('Tap to select an image')) : Image.file(provider.imageFile!, fit: BoxFit.cover),
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
