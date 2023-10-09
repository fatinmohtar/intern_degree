import 'package:flutter/material.dart';
import '../screens/login_page.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF2c538b),
        child: ListTileTheme(
          iconColor: Colors.white,
          textColor: Colors.white,
          child: ListView(
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text('admin'),
                accountEmail: Text('admin@example.com'),
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF2c538b),
                ),
              ),
              const Divider(
                thickness: 3,
                color: Colors.white,
              ),
              ListTile(
                leading:const  Icon(Icons.home),
                title: const Text('Line'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading:const Icon(Icons.settings),
                title:const  Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading:const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content:const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
                child:const Text('Log out'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }),
          ],
        );
      },
    );
  }
}
