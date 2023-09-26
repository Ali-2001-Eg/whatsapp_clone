// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/controllers/group_controller.dart';
import 'package:whatsapp_clone/generated/l10n.dart';
import 'package:whatsapp_clone/screens/chat/chat_screen.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';
import 'package:whatsapp_clone/shared/utils/base/error_screen.dart';
import 'package:whatsapp_clone/shared/widgets/custom_button.dart';
import 'package:whatsapp_clone/shared/widgets/custom_indicator.dart';

import '../../models/user_model.dart';
import '../../shared/notifiers/theme_notifier.dart';
import '../../shared/utils/colors.dart';
import '../../shared/utils/functions.dart';

class DescriptionScreen extends ConsumerWidget {
  final bool isGroupChat;
  final String name;
  final String phoneNumber;
  final String pic;
  final String description;
  final String id;
  const DescriptionScreen({
    super.key,
    required this.isGroupChat,
    required this.name,
    required this.phoneNumber,
    required this.pic,
    required this.description,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: getTextTheme(context)!.copyWith(
              color: appTheme.selectedTheme == 'light'
                  ? lightScaffold
                  : Colors.white),
        ),
        actions: [
          isGroupChat
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: IconButton(
                      onPressed: () {
                        _leaveGroup(ref, context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      )),
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _descreptionbody(context, ref, appTheme),
      ),
    );
  }

  Widget _descreptionbody(
      BuildContext context, WidgetRef ref, ThemeNotifier appTheme) {
    //_isUserJoined(id, ref);
    return SizedBox(
      child: Column(
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(pic),
              radius: 70,
            ),
          ),
          _buildDescriptionTile(
              context,
              isGroupChat ? S.of(context).group_name : S.of(context).username,
              name),
          !isGroupChat
              ? _buildDescriptionTile(
                  context, S.of(context).description, description)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        S.of(context).group_members,
                        style: getTextTheme(context),
                      ),
                    ),
                    const Divider(
                      //color: greyColor,
                      endIndent: 50,
                      thickness: 5,
                    ),
                    _groupMembers(ref, appTheme),
                  ],
                ),
          !isGroupChat
              ? GestureDetector(
                  onTap: () => Clipboard.setData(
                          ClipboardData(text: phoneNumber))
                      .then((value) =>
                          customSnackBar(S.of(context).copy_snackbar, context)),
                  child: _buildDescriptionTile(
                      context, S.of(context).phone_nember, phoneNumber,
                      isPhoneNumber: true),
                )
              : StreamBuilder(
                  stream: _isUserJoined(id, ref),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: CustomButton(
                            onPress: () {
                              snap.data
                                  ? _leaveGroup(ref, context)
                                  : _joinGroup(ref, context);
                            },
                            text: snap.data
                                ? S.of(context).leave_group
                                : S.of(context).join_group),
                      );
                    } else {
                      return const CustomIndicator();
                    }
                  }),
        ],
      ),
    );
  }

  void _leaveGroup(WidgetRef ref, BuildContext context) {
    ref
        .read(groupControllerProvider)
        .leaveGroup(id)
        .then((value) => Navigator.pushNamed(context, HomeScreen.routeName))
        .then(
            (value) => customSnackBar('You left $name successfully!', context));
  }

  void _joinGroup(WidgetRef ref, BuildContext context) {
    ref
        .read(groupControllerProvider)
        .joinGroup(id)
        .then((value) => Navigator.pop(context));
  }

  FutureBuilder<List<UserModel>> _groupMembers(
      WidgetRef ref, ThemeNotifier appTheme) {
    return FutureBuilder<List<UserModel>>(
        future: ref.read(groupControllerProvider).getGroupMembers(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomIndicator();
          } else if (snapshot.hasError) {
            return ErrorScreen(
              error: snapshot.error.toString(),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            const Text('there is no members in this group');
          }

          return ListView.builder(
              itemCount: snapshot.data!.length,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                var member = snapshot.data![i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListTile(
                    title: Text(member.name),
                    subtitle: Text(
                      member.isOnline
                          ? S.of(context).online
                          : S.of(context).offline,
                      style: TextStyle(
                        color: appTheme.selectedTheme == 'light'
                            ? getTheme(context).appBarTheme.backgroundColor
                            : getTheme(context).cardColor,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          CachedNetworkImageProvider(member.profilePic),
                    ),
                    trailing:
                        member.uid != FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                          name: member.name,
                                          uid: member.uid,
                                          description: member.description,
                                          phoneNumber: member.phoneNumber,
                                          isGroupChat: false,
                                          profilePic: member.profilePic,
                                          token: member.token,
                                          isOnline: member.isOnline),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: appTheme.selectedTheme == 'light'
                                      ? getTheme(context)
                                          .appBarTheme
                                          .backgroundColor
                                      : getTheme(context).cardColor,
                                ))
                            : null,
                  ),
                );
              });
        });
  }

  _buildDescriptionTile(BuildContext context, String label, String description,
      {bool isPhoneNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            label,
            style: getTextTheme(context),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                color: getTheme(context).appBarTheme.backgroundColor!),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(description, style: getTextTheme(context)),
                const SizedBox(
                  width: 15,
                ),
                isPhoneNumber
                    ? Icon(
                        Icons.copy,
                        color: getTheme(context).appBarTheme.backgroundColor,
                      )
                    : Container()
              ],
            ),
          ),
        )
      ],
    );
  }

  Stream _isUserJoined(String groupId, ref) {
    return ref.read(groupControllerProvider).isUserJoined(groupId);
  }
}