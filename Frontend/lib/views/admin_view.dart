import 'package:anavis/providers/app_state.dart';
import 'package:anavis/views/widgets/button_card_bottom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  List<Container> returnPages(BuildContext context) {
    return [
      Container(
        color: Colors.red[600],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  'assets/images/user.svg',
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            "Aggiungi utente",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "Inserisci le credenziali relative a un nuovo utente",
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(
                            Icons.supervised_user_circle,
                            size: 40,
                          ),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            ButtonForCardBottom(
                              icon: Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              color: Colors.grey,
                              onTap: () {
                                AppState().logout();
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              title: 'Logout',
                            ),
                            ButtonForCardBottom(
                              icon: Icon(
                                Icons.add_circle,
                              ),
                              color: Colors.deepOrangeAccent,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/admin/createuser',
                                );
                              },
                              title: 'Aggiungi',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 42,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    "Effettua uno swipe laterale per accedere all'amministrazione degli utenti",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[100],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        color: Colors.grey[350],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 42),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                child: SvgPicture.asset(
                  'assets/images/data.svg',
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(16),
                          title: Text(
                            "Amministra utenti",
                            style: TextStyle(fontSize: 18),
                          ),
                          subtitle: Text(
                            "Effettua delle operazioni di amministrazione sugli utenti",
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(
                            Icons.tune,
                            size: 40,
                          ),
                        ),
                        ButtonBar(
                          children: <Widget>[
                            ButtonForCardBottom(
                              icon: Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                              color: Colors.grey,
                              onTap: () {
                                AppState().logout();
                                Navigator.pushReplacementNamed(context, '/');
                              },
                              title: 'Logout',
                            ),
                            ButtonForCardBottom(
                              icon: Icon(
                                Icons.remove_red_eye,
                              ),
                              color: Colors.indigoAccent,
                              onTap: () {
                                Navigator.pushNamed(context, '/admin/users');
                              },
                              title: 'Visualizza',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 42,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    "Effettua uno swipe laterale per accedere alla creazione di nuovi utenti",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        child: LiquidSwipe(
          pages: returnPages(context),
          fullTransitionValue: 500,
          enableSlideIcon: false,
          enableLoop: true,
          waveType: WaveType.liquidReveal,
        ),
      ),
    );
  }
}
