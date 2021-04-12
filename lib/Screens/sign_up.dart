import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ntsal_challenge/Screens/MainScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _fname, _lname, _mob, _email, _password;
  String _gender = "male";
  void _submitCommand() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _loginCommand();
    }
  }

  void _loginCommand() {
    final snackbar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularProgressIndicator(),
          Text('Logging in as $_email'),
        ],
      ),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => MainScreen()),
      );    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xff043b48),
        elevation: 0,
        title: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 22,
          ),
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
        bottom: PreferredSize(
          child: Text(
            "Please Login or Register to access the full experience",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          preferredSize: Size.fromHeight(0),
        ),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xff043b48),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First Name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Last Name",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last Name cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Wrong phone number';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      filled: true,
                      fillColor: Colors.white,
                    ),

                    value: _gender,
                    items: ['male', 'female'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return 'Email cannot be empty';
                      }
                      return null;
                    },
                    onSaved: (val) => _email = val,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) =>
                        val.length < 4 ? 'Password too short..' : null,
                    onSaved: (val) => _password = val,
                    obscureText: true,
                    onChanged: (val) => _password = val,
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) =>
                        val != _password ? 'Password dosnt match..' : null,
                    obscureText: true,

                  ),


                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ListTile(
        onTap: _submitCommand,
        leading: Text('Sign in'),
        tileColor: Colors.yellow,
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
