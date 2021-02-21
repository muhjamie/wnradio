import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wnradio/Network/rest_apis.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Extensions.dart';
import 'package:wnradio/Utils/Strings.dart';
import 'package:wnradio/Utils/Widgets.dart';
import 'package:wnradio/Utils/constant.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var isLoading = false;
  var token = '';
  var username = '';
  int id;

  var confirmPasswordCont = TextEditingController();
  var oldPasswordCont = TextEditingController();
  var newPasswordCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(white_color);
  }

  init() async {
    changeStatusColor(white_color);
    token = await getBool(IS_LOGGED_IN) ? await getString(TOKEN) : '';
    username = await getBool(IS_LOGGED_IN) ? await getString(USERNAME) : '';
    id = await getInt(USER_ID);
    print(token);
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(white_color);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: app_Background,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: whiteColor,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: blackColor,
                ),
                onPressed: () {
                  finish(context);
                }),
            title: Text(
              Change_Password,
              style: boldTextStyle(color: textColorPrimary, size: 18),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(Old_Password, style: secondaryTextStyle(color: textColorSecondary, size: textSizeSMedium)),
                  EditText(
                    iconName: Icons.lock_outline,
                    isPassword: true,
                    isSecure: true,
                    mController: oldPasswordCont,
                  ),
                  16.height,
                  Text(New_Password, style: secondaryTextStyle(color: textColorSecondary, size: textSizeSMedium)),
                  EditText(
                    iconName: Icons.lock_outline,
                    isPassword: true,
                    isSecure: true,
                    mController: newPasswordCont,
                  ),
                  16.height,
                  Text(Confirm_Password, style: secondaryTextStyle(color: textColorSecondary, size: textSizeSMedium)),
                  EditText(
                    iconName: Icons.lock_outline,
                    isPassword: true,
                    isSecure: true,
                    mController: confirmPasswordCont,
                  ),
                  24.height,
                  NewsButton(
                    textContent: Save,
                    height: 50,
                    onPressed: () {
                      if (oldPasswordCont.text.isEmpty)
                        toast(Old_Password + Field_Required);
                      else if (newPasswordCont.text.isEmpty)
                        toast(New_Password + Field_Required);
                      else if (confirmPasswordCont.text.isEmpty)
                        toast(Confirm_Password + Field_Required);
                      else {
                        isLoading = true;
                        var request = {'password': oldPasswordCont.text, 'new_password': confirmPasswordCont.text, 'username': username};
                        print(request);
                        setState(() {
                          isLoading = true;
                        });
                        hideKeyboard(context);
                        changePassword(request).then((res) {
                          setState(() {
                            isLoading = false;
                          });
                          toast('SuccessFully Change Your Password');
                          finish(context);
                        }).catchError((error) {
                          setState(() {
                            isLoading = false;
                          });
                          toast(error.toString());
                        });
                      }
                    },
                  )
                ],
              ).paddingAll(16.0),
            ),
          ),
        ),
        CircularProgressIndicator().center().visible(isLoading),
      ],
    );
  }
}
