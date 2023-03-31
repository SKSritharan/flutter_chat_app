import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = "/profile";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? _auth = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  late String? _name;
  late String? _email;
  late String? _profileImage;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void initState() {
    _name = _auth?.displayName ?? '';
    _email = _auth?.email ?? '';
    _profileImage = _auth?.photoURL ?? '';

    _usernameController.text = _name!;
    _emailController.text = _email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.deepPurple),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.deepPurple,
            ),
            onPressed: () {},
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ColorFiltered(
                    colorFilter:
                        const ColorFilter.mode(Colors.purple, BlendMode.color),
                    child: CachedNetworkImage(
                      imageUrl: _profileImage!,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: CachedNetworkImageProvider(
                            _profileImage!,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _name!,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _email!,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 32.0,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                focusNode: _usernameFocusNode,
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                ),
                                controller: _usernameController,
                                keyboardType: TextInputType.name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                                textInputAction: TextInputAction.next,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'The Username is required.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailFocusNode);
                                },
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                focusNode: _emailFocusNode,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                ),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'The Email Address is required';
                                  } else if (!EmailValidator.validate(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  onTapUpdate(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 32.0,
                            ),
                            ElevatedButton(
                              onPressed: () => onTapUpdate(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 32.0,
                                ),
                              ),
                              child: const Text(
                                "Update Profile",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 32.0,
                                ),
                              ),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 32.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapUpdate(context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        await _auth!.updateDisplayName(_usernameController.text.trim());
        await _auth!.updateEmail(_emailController.text.trim());

        setState(() {
          _name = _usernameController.text.trim();
          _email = _emailController.text.trim();
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile Update successful!')));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('The email address is malformed or otherwise invalid')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email is already taken')));
        } else if (e.code == 'network-request-failed') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'An error occurred. Please check your internet connection and try again'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile update failed. Please try again later.'),
          ),
        );
      }
    }
  }
}
