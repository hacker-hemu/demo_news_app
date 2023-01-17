import 'package:demo_news_app/screens/news_create_screen.dart';
import 'package:demo_news_app/screens/profile.dart';
import 'package:demo_news_app/screens/terms_and_conditions.dart';
import 'package:demo_news_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../components/customListTile.dart';
import '../constants/constants.dart';
import '../notification/all_notifications_screen.dart';
import '../screens/about.dart';
import '../screens/login.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // vertical space
              const SizedBox(
                height: 20.0,
              ),

              // app short Logo
              Image.asset(
                shortLogoBlackURL,
                width: 200.0,
                height: 50.0,
              ),

              // vertical space
              const SizedBox(
                height: 30.0,
              ),

              // title name => setting
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Settings',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // vertical space
              const SizedBox(
                height: 20.0,
              ),

              // profile
              customListTile(
                icon: Icons.account_circle_rounded,
                label: 'Profile',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // my post
              customListTile(
                icon: Icons.add_chart_rounded,
                label: 'Create News',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NewsCreateScreen(),
                    ),
                  );
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // notification
              customListTile(
                icon: Icons.notifications_rounded,
                label: 'Notification',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // terms and condition
              customListTile(
                icon: Icons.event_note_rounded,
                label: 'Terms and Conditions',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ),
                  );
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // share app
              customListTile(
                icon: Icons.share,
                label: 'Share With Friend',
                onTap: () {
                  Share.share(
                      'न्यूज़ के लिए आज ही ऐप इंस्टॉल करें।\n\n$playStoreAppLink\n\n\nसंपर्क करें: $clientMobileNumber\nEmail: $clientEmail\n\n\n',
                      subject: 'Look what I made!');
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // about
              customListTile(
                icon: Icons.info_rounded,
                label: 'About',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const About(),
                    ),
                  );
                },
                iconColor: Theme.of(context).primaryColor,
              ),

              // logout
              customListTile(
                icon: Icons.logout_rounded,
                label: 'Logout',
                onTap: () {
                  logout().then((value) => {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (route) => false)
                      });
                  debugPrint('Logout Success');
                  // redirecting to home screen
                },
                iconColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
