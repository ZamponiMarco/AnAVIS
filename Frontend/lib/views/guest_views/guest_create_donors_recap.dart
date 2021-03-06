import 'package:anavis/models/authcredentials.dart';
import 'package:anavis/models/donor.dart';
import 'package:anavis/services/authcredentials_service.dart';
import 'package:anavis/views/widgets/confirmation_flushbar.dart';
import 'package:anavis/views/widgets/painter.dart';
import 'package:flutter/services.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class GuestCreateDonorRecap extends StatefulWidget {
  final AuthCredentials credentials;
  final Donor donor;
  final String officeName;
  GuestCreateDonorRecap({
    @required this.credentials,
    @required this.donor,
    @required this.officeName,
  });

  @override
  _GuestCreateDonorRecapState createState() => _GuestCreateDonorRecapState();
}

class _GuestCreateDonorRecapState extends State<GuestCreateDonorRecap> {
  String _officeName;
  Future<bool> postRequest() async {
    bool confirmation = await AuthCredentialsService(context)
        .addDonorCredentials(widget.donor, widget.credentials);
    return confirmation;
  }

  String getCategoryName(DonorCategory cat) {
    switch (cat) {
      case DonorCategory.MAN:
        return "Uomo";
      case DonorCategory.FERTILEWOMAN:
        return "Donna fertile";
      case DonorCategory.NONFERTILEWOMAN:
        return "Donna non fertile";
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        child: CustomPaint(
          painter: Painter(
            background: Colors.white,
            first: Colors.deepOrange,
            second: Colors.redAccent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 76.0,
                    right: 12.0,
                    left: 12.0,
                  ),
                  child: Card(
                    elevation: 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(26.0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Conferma della registrazione',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                                left: 16.0,
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Il nuovo utente, ',
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontFamily: 'Rubik',
                                    fontSize: 24,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "${widget.donor.getSurname()} ${widget.donor.getName()} (${getCategoryName(widget.donor.getCategory())})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ', nato a ',
                                    ),
                                    TextSpan(
                                      text: "${widget.donor.getBirthPlace()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' il ',
                                    ),
                                    TextSpan(
                                      text:
                                          "${widget.donor.getBirthday().substring(0, 10)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ', desidera iscriversi con la mail ',
                                    ),
                                    TextSpan(
                                      text: "${widget.credentials.getMail()}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' e la password ',
                                    ),
                                    TextSpan(
                                      text:
                                          "${widget.credentials.getPassword()}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' presso l\'ufficio di ',
                                    ),
                                    TextSpan(
                                      text: "${widget.officeName}",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.',
                                    ),
                                    TextSpan(
                                      text:
                                          '\n\nSi desidera proseguire con la registrazione o annullare?',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        ButtonBarTheme(
                          data: ButtonBarThemeData(
                            alignment: MainAxisAlignment.spaceAround,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10.0,
                            ),
                            child: ButtonBar(
                              children: <Widget>[
                                AvatarGlow(
                                  startDelay: Duration(milliseconds: 1000),
                                  glowColor: Colors.redAccent,
                                  endRadius: 60.0,
                                  duration: Duration(milliseconds: 2000),
                                  repeat: true,
                                  showTwoGlows: true,
                                  repeatPauseDuration:
                                      Duration(milliseconds: 100),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: FloatingActionButton(
                                      heroTag: "fab_cancel",
                                      backgroundColor: Colors.red,
                                      elevation: 22,
                                      child: Icon(
                                        Icons.clear,
                                        size: 42,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/',
                                        );
                                        new ConfirmationFlushbar(
                                          "Registrazione annullata",
                                          "La richiesta è stata annullata, la preghiamo di contattare i nostri uffici se lo ritiene opportuno",
                                          false,
                                        ).show(context);
                                      },
                                    ),
                                  ),
                                ),
                                AvatarGlow(
                                  startDelay: Duration(milliseconds: 1000),
                                  glowColor: Colors.greenAccent,
                                  endRadius: 60.0,
                                  duration: Duration(milliseconds: 2000),
                                  repeat: true,
                                  showTwoGlows: true,
                                  repeatPauseDuration:
                                      Duration(milliseconds: 100),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: FloatingActionButton(
                                      heroTag: "fab_check",
                                      backgroundColor: Colors.green,
                                      elevation: 22,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 42,
                                      ),
                                      onPressed: () {
                                        this.postRequest().then((status) {
                                          if (status) {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/',
                                            );
                                            new ConfirmationFlushbar(
                                                    "Registrazione effettuata",
                                                    "L'utente può ora autenticarsi al servizio",
                                                    true)
                                                .show(context);
                                          } else {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/',
                                            );
                                            new ConfirmationFlushbar(
                                                    "Errore nella registrazione",
                                                    "Non è stato possibile registrare l'utente",
                                                    false)
                                                .show(context);
                                          }
                                        });
                                      },
                                    ),
                                  ),
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
              WaveWidget(
                config: CustomConfig(
                  colors: [
                    Colors.red[900],
                    Colors.red[600],
                    Colors.red[400],
                    Colors.red[300],
                  ],
                  durations: [
                    35000,
                    19440,
                    10800,
                    6000,
                  ],
                  heightPercentages: [0.20, 0.23, 0.25, 0.50],
                  blur: MaskFilter.blur(
                    BlurStyle.solid,
                    12,
                  ),
                ),
                waveAmplitude: 0,
                size: Size(double.infinity, 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
