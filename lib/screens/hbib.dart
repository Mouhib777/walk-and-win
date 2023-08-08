import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  static String routeName = "ieee_app/pages/login.dart";

  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passWordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    showPassword = false;
  }

  late bool showPassword = false;
  void togglevisibility() {
    setState(
      () {
        showPassword = !showPassword;
      },
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passWordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  // child: Image.asset(
                  //   "assets/images/sb_logo_arc_blue.png",
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontFamily: "IBMPlexSans",
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      const Row(
                        children: [
                          Text(
                            "Login to continue using the app",
                            style: TextStyle(
                              fontFamily: "IBMPlexSansCondensed",
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        child: Column(
                          children: [
                            //email form field --------------------------
                            const Row(
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontFamily: "IBMPlexSans",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  // errorText: "Wrong email",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  prefixIconColor:
                                      MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return const Color(0xFF00679a);
                                      }
                                      if (states
                                          .contains(MaterialState.error)) {
                                        return Colors.red;
                                      }
                                      return Colors.grey;
                                    },
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                focusNode: _emailFocusNode,
                                onFieldSubmitted: (_) {
                                  _emailFocusNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_passWordFocusNode);
                                },
                              ),
                            ),
                            //password form field -----------------------
                            const Row(
                              children: [
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    fontFamily: "IBMPlexSans",
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  // errorText: "Wrong password",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  icon: const Icon(Icons.lock_outline_rounded),
                                  prefixIconColor:
                                      MaterialStateColor.resolveWith(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.focused)) {
                                        return const Color(0xFF00679a);
                                      }
                                      if (states
                                          .contains(MaterialState.error)) {
                                        return Colors.red;
                                      }
                                      return Colors.grey;
                                    },
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      print("test");
                                    },
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xff00679a),
                                    ),
                                  ),
                                ),
                                focusNode: _passWordFocusNode,
                                onFieldSubmitted: (_) {
                                  _passWordFocusNode.unfocus();
                                },
                                obscureText: !showPassword,
                              ),
                            ),
                            //password confirmation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Forget password ?"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: FilledButton(
                          style: const ButtonStyle(
                            elevation: MaterialStatePropertyAll(5),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Don't have an account ?",
                            style: TextStyle(
                              fontFamily: "IBMPlexSansCondensed",
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              elevation: MaterialStatePropertyAll(
                                5,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  fontFamily: "IBMPlexSansCondensed",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              // child: Image.asset(
              //   "assets/images/waves_blue.png",
              //   opacity: const AlwaysStoppedAnimation(.5),
              // ),
            )
          ],
        ),
      ),
    );
  }
}
