import 'package:flutter/material.dart';
import 'package:pingo/services/auth/auth_services.dart';
import 'package:pingo/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() async {
    AuthServices authServices = AuthServices();
    authServices.signout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header icon/image
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //home tile
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.home),
                  title: const Text(
                    "HOME",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              //settings tile
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text(
                    "SETTINGS",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SettingsPage();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          //logout tile
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "LOGOUT",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
