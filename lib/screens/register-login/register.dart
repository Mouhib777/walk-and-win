import 'dart:io';
import 'dart:math';


import 'package:animate_do/animate_do.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tunisie_autoroutes/constant/constant.dart';
import 'package:tunisie_autoroutes/screens/login-register/login.dart';
import 'package:tunisie_autoroutes/screens/login-register/terms.dart';
import 'package:walk_and_win/constant/constant.dart';
import 'package:walk_and_win/screens/register-login/login.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  bool _acceptedTerms = false;
  String? email;
  String? f_name;
  String? password;
  String? p_confirm;
  var _fNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isLoading = false;

  File? _pickedImage;
  String? imageUrl;

  final Random _random = Random();

  String generateRandomName(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }

  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(

          body: SingleChildScrollView(
              child: FadeInLeft(
                delay: Duration(milliseconds: 200),
                child: Padding(
                  padding:  EdgeInsets.all(15.0),
                  child: Center(
                      child: Column(
                      
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        
                        Text(
                          "S'inscrire",
                          style: GoogleFonts.montserratAlternates(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                   
                    Text(
                      "Bienvenue à bord, nous espérons que vous apprécierez votre temps avec nous",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                   
                  
                    SizedBox(
                      width: 330,
                      child: TextFormField(
                        style: GoogleFonts.montserrat() ,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _fNameController,
                        decoration: InputDecoration(
                          hintText: "Nom d'utilisateur",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: "  Nom d'utilisateur",
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'SVP entrez vote nom';
                          } else {
                            setState(() {
                              f_name = value;
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {
                          f_name = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextFormField(
                        style: GoogleFonts.montserrat(),
                        controller: _emailController,
                        decoration: InputDecoration(
                         
                          hintText: 'address@mail.com',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: '  E-mail',
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'SVP entrez votre e-mail';
                          } else {
                            setState(() {
                              email = value;
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextFormField(
                        style: GoogleFonts.montserrat(),
                        controller: _passwordController,
                        decoration: InputDecoration(
                        
                          hintText: 'Mot de passe',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: '  Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        autofocus: false,
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
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: _obscureText,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 330,
                      child: TextFormField(
                        style: GoogleFonts.montserrat(),
                        controller: _confirmController,
                        decoration: InputDecoration(
                     
                          hintText: 'Confirmer le mot de passe',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: '  Confirmer le mot de passe',
                        ),
                        autofocus: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Mot de passe n'est pas confirmé";
                          } else if (value != _passwordController.text) {
                            return "n'est pas identique";
                          } else {
                            setState(() {
                              p_confirm = value;
                            });
                            return null;
                          }
                        },
                        onChanged: (value) {
                          p_confirm = value;
                        },
                        obscureText: true,
                      ),
                    ),
                    CheckboxListTile(
                      title: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "J'accepte ",
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                ),
                              ),
                              InkWell(
                                child: Text(
                                  "the terms and conditions",
                                  style: GoogleFonts.montserratAlternates(
                                      fontSize: 12, color: primarycolor),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      transitionDuration: Duration.zero,
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          TermsScreen()));
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'de Tunisie Autoroutes',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      value: _acceptedTerms,
                      onChanged: (newValue) {
                        setState(() {
                          _acceptedTerms = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 350,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _acceptedTerms
                            ? () async {
                                // var _token = await _firebaseMessaging.getToken();
                                if (_formKey.currentState!.validate()) {
                                  try {
                                   
                                 
                                      setState(() {
                                        _isLoading = true;
                                      });
                                     
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: email!.trim(),
                                              password: password!.trim());
                
                                      final User? userr =
                                          FirebaseAuth.instance.currentUser;
                                      final _uid = userr!.uid;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_uid)
                                          .set({
                                        "full name": "$f_name",
                                        "email": "$email",
                                        "premium": "false",
                                        "plan": "Basic plan",
                                        // "image": imageUrl.toString(),
                                        // "deviceToken": _token,
                                        "id": _uid,
                                        "isAdmin": "false",
                                        "enabled": "true",
                                        "management": "enabled"
                                      });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => navBar(),
                                      //     ));
                
                                      EasyLoading.showSuccess(
                                          'user with name $f_name was created');
                                    
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      AnimatedSnackBar.material(
                                        "Invalid password",
                                        type: AnimatedSnackBarType.error,
                                        duration: Duration(seconds: 4),
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.bottom,
                                      ).show(context);
                                    } else if (e.code == 'invalid-email') {
                                      AnimatedSnackBar.material(
                                        "Invalid email address",
                                        type: AnimatedSnackBarType.error,
                                        duration: Duration(seconds: 4),
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.bottom,
                                      ).show(context);
                                    } else if (e.code == 'email-already-in-use') {
                                      AnimatedSnackBar.material(
                                        "This email address is already in use",
                                        type: AnimatedSnackBarType.error,
                                        duration: Duration(seconds: 4),
                                        mobileSnackBarPosition:
                                            MobileSnackBarPosition.bottom,
                                      ).show(context);
                                    }
                                  } catch (ex) {
                                    print(ex);
                                  }
                                  FocusScopeNode currentFocus =
                                      FocusScope.of(context);
                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            : null,
                        child: Text(
                          "S'inscrire",
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
                    SizedBox(
                        child: _isLoading ? CircularProgressIndicator() : null),
                    SizedBox(
                      height: 10,
                    ),
                    Text("____________________ OU ____________________" , 
                    style: GoogleFonts.montserrat(),
                    ),
                    SizedBox(height: 10,) , 
                    Text("S'inscrire en utilisant", 
                    style: GoogleFonts.montserrat(),
                    ),
                    SizedBox(height: 15,) , 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                               color: Color.fromARGB(20, 158, 158, 158) ,
                                borderRadius: BorderRadius.circular(15) , 
                                
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/fb.png" , 
                                  height: 30,
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Facebook" , 
                                  style: GoogleFonts.montserrat(),
                                  
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              
                            },
                          ) , 
                          SizedBox(width: 20,),
                           InkWell(
                             child: Container(
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                              color: Color.fromARGB(20, 158, 158, 158) ,
                                borderRadius: BorderRadius.circular(15) , 
                                
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/google.png" , height: 25,),
                                  SizedBox(width: 10,),
                                  Text("Google" , 
                                  style: GoogleFonts.montserrat(),
                                  
                                  )
                                ],
                              ),
                                                     ),
                                                     onTap: () {
                                                       
                                                     },
                           )


                    ],),
                      SizedBox(
                      height: 20,
                    ),
                    FadeIn(
                      delay: Duration(seconds: 1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Vous avez déjà un compte ? ",
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 13,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              "Connectez-vous ici",
                              style: GoogleFonts.montserratAlternates(
                                  fontSize: 12,
                                  color: primarycolor,
                                  fontWeight: FontWeight.w500),
                            ),
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  transitionDuration: Duration.zero,
                                  pageBuilder: (context, animation, secondary) =>
                                      LoginScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ])),
                ),
              ))),
    );
  }


}