import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/Utils.dart';

class ShareFeedback extends StatefulWidget {
  @override
  State<ShareFeedback> createState() => _ShareFeedbackState();
}

class _ShareFeedbackState extends State<ShareFeedback> {
  TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _feedbackController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_feedbackController.text.isEmpty)
            Container(
                width: size.width - 100,
                margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
                child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Utils.greyColor,
                      shape: StadiumBorder(),
                    ),
                    child: Text('Submit Feedback', style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500, color: Utils.whiteColor)),
                    onPressed: () {},
                  ),
                )),
          if (_feedbackController.text.isNotEmpty)
            Container(
              width: size.width - 100,
              margin: Platform.isIOS ? const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 70) : const EdgeInsets.all(10),
              child: ButtonTheme(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Utils.primaryColor,
                    shape: StadiumBorder(),
                  ),
                  child: Text('Submit Feedback', style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500, color: Utils.whiteColor)),
                  onPressed: () {},
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Help us to serve you Better',
                        style: Utils.fonts(
                          size: 20.0,
                          // fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      maxLines: 8,
                      maxLength: 200,
                      cursorColor: Utils.blackColor,
                      controller: _feedbackController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Feedback',
                        labelStyle: Utils.fonts(
                          fontWeight: FontWeight.w400,
                          color: Utils.greyColor,
                        ),
                        alignLabelWithHint: true,
                        hintText: 'Please share your problem or request for new features. Upload attachment if possible to serve you better',
                        hintStyle: Utils.fonts(
                          fontWeight: FontWeight.w400,
                          size: 14.0,
                          color: Utils.lightGreyColor.withOpacity(0.5),
                        ),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Utils.lightGreyColor.withOpacity(0.5))),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Utils.lightGreyColor.withOpacity(0.5))),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text('Upload Attachment',
                        style: Utils.fonts(
                          size: 16.0,
                          // fontWeight: FontWeight.w400,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Utils.lightGreyColor.withOpacity(0.5))),
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/appImages/image.svg'),
                                Text('Image',
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Utils.lightGreyColor.withOpacity(0.5))),
                            child: Column(
                              children: [
                                SvgPicture.asset('assets/appImages/document.svg'),
                                Text('Document',
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
