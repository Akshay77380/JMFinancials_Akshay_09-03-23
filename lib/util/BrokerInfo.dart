import '../util/CommonFunctions.dart';

import 'Dataconstants.dart';

enum Broker {
  icici,
}

class BrokerInfo {
  static Broker client;
  static String brokerName, appName;
  static List<String> servers;
  static String forgotPasswordLink = '';
  static String loadBalancerLink = '';
  static String _fundsPayInLink = '';
  static String _fundsPayOutLink = '';
  static String hotKeyLink = '';
  static String homeLink = '';
  static String ipoLink = '';
  static String pledgeLink = '';
  static String unPledgeLink = '';
  static String successLink = '';
  static String helpUs = '';
  static String createAccountLink = '';
  static String createAccountLink2 = '';
  static String userguideLink = '';
  static String videoguideLink = '';
  static String backOfficeLink = '';
  static String privacyPolicyLink = '';
  static String disclaimerLink = '';
  static String faqLink = '';
  static String nseLink = '';
  static String bseLink = '';
  static String unlockAccountLink = '';
  static String mcxLink = '';
  static String sebiLink = '';
  static String address = '';
  static String address1 = '';
  static String address2 = '';
  static String address3 = '';
  static String phone = '';
  static String email = '';
  static String forgotLoginLink = '';
  static String linkLabel1 = '';
  static String website = '';
  static String linkLabel2 = '';
  static String productName = '';
  static String productName1 = '';
  static String productName2 = '';
  static String productName3 = '';
  static String smsLINK = '';
  static String encryption = '';
  static String edisLink = '';
  static String onBoardingFrom = "";
  static String moneyUrlScheme = 'https://icicimoney.page.link/dashboard';
  static String iLearnApp = 'https://icicieducation.page.link/zRx8';
  static String edisWebViewLink = "https://tradeapiuat.jmfonline.in/eDISCDSL/Live/Live?UID=SPD222";
  static String commoditiesLink = '';
  static String notificationLink = "";
  static String moneyAppPlaystoreLink =
      'https://play.google.com/store/apps/details?id=com.icici.direct&hl=en_IN&gl=US';
  static String moneyAppAppstoreLink =
      'https://apps.apple.com/in/app/icicidirect-money/id1544266409';
  static String contactUsEscalationLink =
      'https://www.icicidirect.com/mailimages/Escalation_Matrix.pdf';
  static String home = 'https://www.icicidirect.com/fno-execution';
  static String tWAPOrderSlicing =
      'https://www.icicidirect.com/twap-order-slicing';
  static String tWAPriceBand = 'https://www.icicidirect.com/twap-price-band';
  static String averaging =
      'https://www.icicidirect.com/fno-execution-averaging';
  static String mutualFundsLink = '', referEarnLink = '';
  static bool isManuallyLogout = false;
  static String LIVEURL = "https://tradeapi.jmfonline.in/middleware/";
  static String CUGURL = "https://tradeapi.jmfonline.in/cug_middleware/";
  static String UATURL = "https://tradeapiuat.jmfonline.in:9190/";
  // static String UATURL = "http://jmfs-alb-prod-1481051334.ap-south-1.elb.amazonaws.com/middleware/";


  static String ApiVersion = "api/v2/"; // UAT
  // static String ApiVersion = "api/"; // LIVE
  static String openAnAccount = "https://signup.jmfonline.in/open-demat-account/";
  static String mainUrl = UATURL;
  static int itsPORT = 18002;

  //TODO: AlgoBrockerinfo
  static String algoUrl = "https://tradeapiuat.jmfonline.in/algo";
  // static String algoUrl = "https://bigulint.bigul.app/algo";
  static int algoVersion = 2;
  static const timeoutDuration = const Duration(seconds: 20);
  //TODO: AlgoBrockerinfo

  static bool allowPin = false,
      yearOfBirth = true,
      isEncryptionRequired = false,
      news = true;

  static void setClientInfo(Broker selectedClient) async {
    client = selectedClient;
    switch (client) {
      case Broker.icici:
        brokerName = 'JM Financials';
        appName = 'JM Financials';
        servers = [
          '13.233.10.105',
          '3.6.161.135',
          '3.7.7.63',
          // '172.11.11.87'
        ]; //
        // servers = ['180.149.242.215'];
        unlockAccountLink =
            "https://secure.icicidirect.com/mobile/unlockaccount";
        loadBalancerLink =
            // 'https://marketstreams.icicidirect.com/api/loadbalance/GetServerInfo';
            'https://mobilestreams.icicidirect.com/api/loadbalance/GetServerInfo';
        createAccountLink =
            // 'https://isecuat.icicidirect.com/idirect/accountopening';
            'https://secure.icicidirect.com/accountopening';
        // createAccountLink2 =
        // 'https://isecuat1.icicidirect.com/open-account/mobile';
        // createAccountLink = 'https://secure.icicidirect.com/accountopening';
        createAccountLink2 = 'https://www.icicidirect.com/open-account/mobile';
        // forgotLoginLink = 'https://203.189.92.210/idirect/mobile/forgotlogin';
        // forgotPasswordLink = 'https://203.189.92.210/idirect/mobile/unlock';
        forgotLoginLink = 'https://secure.icicidirect.com/mobile/forgotlogin';
        forgotPasswordLink = 'https://secure.icicidirect.com/mobile/unlock';
        referEarnLink = 'https://secure.icicidirect.com/content/referafriendlanding';
        faqLink = 'https://www.icicidirect.com/indexfaq.asp';
        break;
    }
    // Dataconstants.eodIP = servers[0];
    // Dataconstants.iqsIP = servers[0];
    Dataconstants.newsIP = servers[0];
    // Dataconstants.itsIP = servers[0];
    // DataConstants.itsIP = "192.168.1.123";
    Dataconstants.eodIP = servers[0];
    // Dataconstants.iqsIP = '180.149.242.215';
    // Dataconstants.iqsIP = "3.6.161.135";
     Dataconstants.iqsIP = "tradeapi.jmfonline.in";
    // Dataconstants.iqsIP = "tradeapiuat.jmfonline.in";
  }

  static String get primaryLogo => 'assets/images/logo/icicidirect markets-primary.png';
}