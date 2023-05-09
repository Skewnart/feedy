import 'package:feedy/models/lang.dart';
import 'package:feedy/models/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:feedy/services/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              FutureBuilder<Image>(
                future: Services.storageService.getImageFromPngName(
                  "icon",
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const SizedBox(
                    height: 150,
                    width: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "v ",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  FutureBuilder(
                      future: Services.appService.getVersion(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data! as String,
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        } else {
                          return Text(
                            "...",
                            style: Theme.of(context).textTheme.bodyText1,
                          );
                        }
                      }))
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "Paramètres",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Langue ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              FutureBuilder<Lang>(
                  future: Services.langService.getLang(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton<Lang>(
                        value: snapshot.data!,
                        onChanged: (newlang) {
                          setState(() {
                            Services.langService.setLang(newlang);
                          });
                        },
                        items: Services.langService.langs
                            .map((lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      lang.label,
                                    ),
                                  ),
                                ))
                            .toList(),
                        selectedItemBuilder: (BuildContext context) =>
                            Services.langService.langs
                                .map((lang) => Center(
                                      child: Text(
                                        lang.label,
                                      ),
                                    ))
                                .toList(),
                        hint: const Center(
                          child: Text(
                            'langue',
                          ),
                        ),
                        underline: Container(),
                      );
                    } else {
                      return Text(
                        "...",
                        style: Theme.of(context).textTheme.bodyText1,
                      );
                    }
                  }))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Activer les alertes",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              FutureBuilder<Settings?>(
                future: Services.settingsService.getSettings(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final settings = snapshot.data;
                    if (settings != null) {
                      return Switch(
                        value: settings.wantsNotification,
                        onChanged: (value) {
                          Services.settingsService
                              .setSettings(value)
                              .then((value) {
                            setState(() {});
                          });
                        },
                      );
                    } else {
                      return Text(
                        "...",
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Text("...");
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(""),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          child: ElevatedButton(
            child: const Text("Se déconnecter"),
            onPressed: _signOut,
          ),
        ),
      ],
    );
  }
}
