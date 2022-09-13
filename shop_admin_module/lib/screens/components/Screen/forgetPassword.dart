import 'package:flutter/material.dart';
import 'package:shop_admin_module/main.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/dialog/customAlterDialog.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ForgetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(LoginBackGroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage(iconImage),
                  width: MediaQuery.of(context).size.width * 0.15),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: Center(
                    child: Text(
                  "忘記密碼",
                  style: TextStyle(fontSize: 36, color: Colors.black),
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: ForgetPasswordForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgetPasswordForm extends StatefulWidget {
  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _userNameTextController = TextEditingController();
  final _identifierTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirm_passwordTextController = TextEditingController();
  final _OTPTextController = TextEditingController();
  bool _isLoading = false;
  bool verify = false;
  bool _passwordVisible = false;
  bool _confirm_passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //identifier
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _identifierTextController,
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                ),
                hintText: '請輸入identifier',
              ),
            ),
          ),
          // account
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _userNameTextController,
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.person_outline,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                ),
                hintText: '請輸入帳戶',
              ),
            ),
          ),
          if (verify)
            // password
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordTextController,
                    obscureText:
                        !_passwordVisible, //This will obscure text dynamically
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_open,
                      ),
                      hintText: '請輸入新密碼',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                      ),
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                // confirm_password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _confirm_passwordTextController,
                    obscureText:
                        !_passwordVisible, //This will obscure text dynamically
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock_open,
                      ),
                      hintText: '確認密碼',
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                      ),
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _confirm_passwordVisible =
                                !_confirm_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                //OTP
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _OTPTextController,
                    decoration: new InputDecoration(
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                      ),
                      hintText: '請輸入OTP',
                    ),
                  ),
                ),
              ],
            ),

          // login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                child: (!verify) ? Text('發送驗證資料') : Text("確認"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String url = forgetPasswordAPI;
                    if (!verify) {
                      _forgetPassword(_userNameTextController.text,
                          _identifierTextController.text, url);
                    } else {
                      url = forgetPasswordVerifyAPI;
                      _verifyPassword(
                          _userNameTextController.text,
                          _passwordTextController.text,
                          _confirm_passwordTextController.text,
                          _identifierTextController.text,
                          _OTPTextController.text,
                          url);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  padding: EdgeInsets.all(8.0),
                )),
          ),
        ],
      ),
    );
  }

  _forgetPassword(String username, String identifier, String url) async {
    setState(() {
      _isLoading = true;
    });
    var data = {'username': username, 'identifier': identifier};
    var res = await Server().forgetPassword(data, url);
    if (res['status'] == "success") {
      setState(() {
        verify = true;
      });
    } else {
      CostomAlterDiaglogState()
          .showDialogBox(context, res['message'], "Error Message");
    }
    setState(() {
      _isLoading = false;
    });
  }

  _verifyPassword(String username, String password, String confirm_password,
      String identifier, String OTP, String url) async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      "username": username,
      "identifier": identifier,
      "password": password,
      "confirm_password": confirm_password,
      "otp": OTP
    };

    var res = await Server().forgetPasswordVerify(data, url);
    print(res);
    if (res['status'] == "success") {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => Main()),
      );
    } else {
      CostomAlterDiaglogState()
          .showDialogBox(context, res['message'], "Error Message");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
