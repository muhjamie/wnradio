
import 'dart:convert';
import 'dart:io';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter/material.dart';
import 'package:linkable/constants.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Images.dart';
import 'package:wnradio/Utils/Validations.dart';
import 'package:wnradio/theme/style.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonateScreen extends StatefulWidget {
  const DonateScreen({Key key}) : super(key: key);

  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  TextEditingController amountController = TextEditingController();
  Validations validations = new Validations();
  bool autovalidate = false;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  var publicKey = 'pk_test_9aaa53746b2ed5f828515a7ed602a48c4df64bc2';
  var secretKey = 'sk_test_5630a255822bb0cf0fd4deaf026515edc77e16df';
  String balance;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: app_Background,
        child: Column(
          children: [
            Container(
              child: Stack(
                children: <Widget>[
                  ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        height: context.height() * 0.30,
                        color: primaryColor,
                      )),
                  50.height,
                  Image.asset(WNR_logo,height: context.height() * 0.25, width: context.width(),)
                ],
              ),
            ).paddingOnly(top: 35),

            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      Text('Make a donation', style: textGreyBig,),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        validator: validations.validateAmount,
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Enter amount to donate",
                            hintStyle: TextStyle(fontSize: 13)
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      new ButtonTheme(
                        height: 40.0,
                        minWidth:
                        MediaQuery.of(context).size.width - 50,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          elevation: 0.0,
                          color: primaryColor,
                          icon: new Text(''),
                          label: new Text('Continue', style: TextStyle(fontSize: 15, color: Colors.white)),
                          onPressed: () {
                            processTopUp(context);
                          },
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> clearForm() {
    amountController.clear();
    Navigator.pop(context);
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return '7RUSHChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String>createAccessCode(skTest, _getReference) async {
    // skTest -> Secret key
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $skTest'};
    Map data = {"amount": 600, "email": "johnsonoye34@gmail.com", "reference": _getReference};
    String payload = json.encode(data);
    http.Response response = await http.post('https://api.paystack.co/transaction/initialize', headers: headers, body: payload);
    final Map res = json.decode(response.body);
    String accessCode = res['data']['access_code'];
    return accessCode;
  }

  void _verifyOnServer(String reference, amount) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+ secretKey
      };

      http.Response response = await http.get('https://api.paystack.co/transaction/verify/' + reference, headers: headers);
      final Map body = json.decode(response.body);
      print(body);
      toast('Donation received');
    } catch (e) {
      //walletState.showInfoFlushbar(context, e.toString());
    }
  }

  chargeCard(String email, double amount) async {
    Charge charge = Charge()..amount = amount.toInt()..reference = _getReference()..email = email;
    CheckoutResponse response = await PaystackPlugin.checkout(context, method: CheckoutMethod.card, charge: charge);
    if (response.status == true) {
      _verifyOnServer(response.reference, amount);
      print(response);
    }
    else {
      //show error
    }
  }

  @override
  void initState() {
    PaystackPlugin.initialize(publicKey: publicKey);
    super.initState();
  }


  processTopUp(context) async {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
    } else {
      form.save();
      SharedPreferences sp = await SharedPreferences.getInstance();
      var email = sp.getString("USER_EMAIL");
      print(email);
      var amount = double.parse(amountController.text) * 100;
      try{
        final result = await InternetAddress.lookup('google.com');
        initTopupAPI(amount, email);
      } catch(e) {
        //var pickupState = Provider.of<PickupState>(context, listen: false);
        //pickupState.showInfoFlushbar(context, 'Unable to connect to internet. Please, turn on your internet connection');
      }
    }
  }

  initTopupAPI(amount, email) async {
    SharedPreferences pref =  await SharedPreferences.getInstance();
    chargeCard(email, amount);
  }
}