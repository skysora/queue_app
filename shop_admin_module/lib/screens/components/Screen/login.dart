import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/dialog/customAlterDialog.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/mainScreen.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

import 'forgetPassword.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: LogInForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class LogInForm extends StatefulWidget {
  @override
  _LogInFormState createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _identifierTextController = TextEditingController();
  bool _isLoading = false;
  bool _isLogin = false;
  bool _passwordVisible = false;
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

          // password
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
                hintText: '請輸入密碼',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                ),
                // Here is key idea
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
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

          // remeber and forget
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    child: Checkbox(
                        value: _isLogin,
                        onChanged: (isMan) {
                          setState(() {
                            if (isMan!) {
                              _isLogin = true;
                            } else {
                              _isLogin = false;
                            }
                          });
                        }),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  SizedBox(child: Text("保持登入狀態")),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width * 0.20),
                  ),
                  SizedBox(
                      child: TextButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => ForgetPasswordScreen());
                      Navigator.push(context, route);
                    },
                    child: Text("忘記密碼"),
                  ))
                ],
              )
              //   trailing: TextButton(
              //     onPressed: () {},
              //     child: Text("Forgot password"),
              //   ),
              // )
              ),
          // login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Sign In'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String url = loginAPI;
                    _login(
                        _userNameTextController.text,
                        _passwordTextController.text,
                        _identifierTextController.text,
                        url);
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

  _login(
      String username, String password, String identifier, String url) async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'username': username,
      'password': password,
      'identifier': identifier
    };

    var res = await Server().authData(data, url, _isLogin);
    if (res['status'] == "success") {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      CostomAlterDiaglogState()
          .showDialogBox(context, res['errors'].toString(), "Error Message");
    }
    setState(() {
      _isLoading = false;
    });
  }
}
