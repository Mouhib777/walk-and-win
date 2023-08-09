
import 'package:animate_do/animate_do.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walk_and_win/constant/constant.dart';
import 'package:walk_and_win/screens/register-login/register.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String? email;
  String? f_name;
  String? password;
  String? p_confirm;
  bool _obscureText = true;  
  bool _isLoading = false;

  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(assetName)
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: FadeIn(
            child: Text(
              "Walk and win",
              style: GoogleFonts.montserratAlternates(
                  color: primarycolor,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                  fontSize: 24),
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false
          
        ),
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                  child:
                      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
              children: [
               
                FadeInLeft(
                  child: Text(
                    "Connexion",
                    style: GoogleFonts.montserratAlternates(
                        fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
                    ),
                    SizedBox(
              height: 30,
                    ),
                    SizedBox(
              width: 20,
                    ),
                    FadeInLeft(
              child: Text(
                "Nous vous attendons pour vous          reconnecter",
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400, fontSize: 14 ,color: Colors.black),
              ),
                    ),
                    SizedBox(
              height: 40,
                    ),
                    FadeInUp(
              child: SizedBox(
                  child: Column(children: [
                SizedBox(
                  width: 330,
                  child: TextField(
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.montserrat(),
                      labelStyle: GoogleFonts.montserrat(),
                      counterStyle: GoogleFonts.montserrat(),
                      hintText: 'address@mail.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: '  E-mail',
                    ),
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    
                    onChanged: (value) {
                      email = value;
                    },
                    // ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 333,
                  child: TextFormField(
                    style:GoogleFonts.montserrat() ,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                         
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                     
                      hintText: 'Mot de passe',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: '  Mot de passe',
                    ),
                    autofocus: false,
            
                   
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'SVP entrez votre mot de passe';
                      } else {
                        setState(() {
                          password = value;
                        });
                        return null;
                      }
                    },
            
                    obscureText: _obscureText,
            
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     transitionDuration: Duration.zero,
                        //     pageBuilder: (context, animation, secondaryAnimation) =>
                        //         ResetPassword()));
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: GoogleFonts.montserrat(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 350,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email!.trim(), password: password!.trim());
            
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => navBar(),
                        //     ));
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'user-not-found') {
                          AnimatedSnackBar.material(
                            "No user found with this email",
                            type: AnimatedSnackBarType.error,
                            duration: Duration(seconds: 4),
                            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                          ).show(context);
                        } else if (ex.code == 'wrong-password') {
                          AnimatedSnackBar.material(
                            'Incorrect password',
                            type: AnimatedSnackBarType.error,
                            duration: Duration(seconds: 6),
                            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                          ).show(context);
                        } else if (ex.code == 'invalid-email') {
                          AnimatedSnackBar.material(
                            'Invalid email address',
                            type: AnimatedSnackBarType.error,
                            duration: Duration(seconds: 4),
                            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                          ).show(context);
                        }
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Text(
                      "Connectez-vous",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarycolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(child: _isLoading ? CircularProgressIndicator() : null),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte?',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      child: Text(
                        "Créer un compte",
                        style: GoogleFonts.montserrat(
                            color: primarycolor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            transitionDuration: Duration.zero,
                            pageBuilder: (context, animation, secondary) =>
                                registerScreen()));
                      },
                    )
                  ],
                ),
              ])),
                    ),
                    SizedBox(
              height: 30,
                    ),
                    // FadeIn(
                    //   delay: Duration(milliseconds: 1500),
                    //   child: SizedBox(
                    //     child: Column(
                    //       children: [
                    //         Text(
                    //           'Or continue with',
                    //           style: GoogleFonts.montserrat(
                    //               fontSize: 15, fontWeight: FontWeight.w400),
                    //         ),
                    //         SizedBox(
                    //           height: 30,
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             InkWell(
                    //               child: Image.asset(
                    //                 "assets/images/facebook.png",
                    //                 height: 40,
                    //               ),
                    //               onTap: () {
                    //                 // _signInWithFacebook();
                    //               },
                    //             ),
                    //             SizedBox(
                    //               width: 40,
                    //             ),
                    //             InkWell(
                    //               child: Image.asset(
                    //                 "assets/images/google.png",
                    //                 height: 40,
                    //               ),
                    //               onTap: () {},
                    //             )
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ])),
            )),
      ),
    );
  }

 
}