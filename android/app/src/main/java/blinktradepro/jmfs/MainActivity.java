package blinktradepro.jmfs;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.plugins.*;
import io.flutter.embedding.engine.FlutterEngine;

import android.app.Activity;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodChannel;
import com.google.android.gms.tasks.Task;
//import com.google.firebase.analytics.FirebaseAnalytics;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;
import org.json.JSONException;
import org.json.JSONObject;
import android.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

//import com.google.android.gms.tasks.Task;
//import com.google.firebase.analytics.FirebaseAnalytics;
//import com.shephertz.app42.paas.sdk.android.App42BadParameterException;
//import com.shephertz.app42.paas.sdk.android.App42CallBack;
//import com.shephertz.app42.paas.sdk.android.App42Exception;
//import com.shephertz.app42.paas.sdk.android.App42Log;
//import com.shephertz.app42.paas.sdk.android.App42NotFoundException;
//import com.shephertz.app42.paas.sdk.android.App42API;
//import com.shephertz.app42.paas.sdk.android.App42Response;
//import com.shephertz.app42.paas.sdk.android.event.EventService;
//import com.shephertz.app42.paas.sdk.android.push.DeviceType;
//import com.shephertz.app42.paas.sdk.android.push.PushNotification;
//import com.shephertz.app42.paas.sdk.android.push.PushNotificationService;
//import com.shephertz.app42.paas.sdk.android.user.UserService;

//import com.adobe.marketing.mobile.AdobeCallback;
//import com.adobe.marketing.mobile.Analytics;
//import com.adobe.marketing.mobile.Assurance;
//import com.adobe.marketing.mobile.Identity;
//import com.adobe.marketing.mobile.InvalidInitException;
//import com.adobe.marketing.mobile.Lifecycle;
//import com.adobe.marketing.mobile.LoggingMode;
//import com.adobe.marketing.mobile.CampaignClassic;
//import com.adobe.marketing.mobile.MobileCore;
//import com.adobe.marketing.mobile.Signal;
//import com.adobe.marketing.mobile.Target;
//import com.adobe.marketing.mobile.UserProfile;
//import com.adobe.marketing.mobile.WrapperType;

public class MainActivity extends FlutterFragmentActivity {
    private static final String CHANNEL = "samples.flutter.dev/tokens";
    private FlutterEngine flutterEngine;
    // PushNotificationService pushNotificationService;
    String InstanceIdToken = "";
    // EventService eventService;
//    PushNotificationService pushNotificationService;
//    EventService eventService;

//    private static String TAG = AESUtils.class.getSimpleName();

    private static final byte[] keyValue = new byte[]{'i', 'd', 'i', 'r', 'e', 'c', 't', 'd', 'o', 't', 'c', 'o', 'm', 'c', 'o', 'm'};

    public static String encrypt(String cleartext) throws Exception {
        byte[] rawKey = getRawKey(keyValue);
        byte[] result = encrypt(rawKey, cleartext.getBytes());
        return toBase64(result);
    }

    public static String decrypt(String encrypted) throws Exception {
        byte[] rawKey = getRawKey(keyValue);
        byte[] enc = fromBase64(encrypted);
        byte[] result = decrypt(rawKey, enc);
        return new String(result);
    }

    private static byte[] getRawKey(byte[] seed) throws Exception {
        SecretKey skey = new SecretKeySpec(seed, "AES");
        byte[] raw = skey.getEncoded();
        return raw;
    }

    private static byte[] encrypt(byte[] raw, byte[] clear) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(raw);

        cipher.init(Cipher.ENCRYPT_MODE, skeySpec, ivParameterSpec);
        byte[] encrypted = cipher.doFinal(clear);
        return encrypted;
    }

    private static byte[] decrypt(byte[] raw, byte[] encrypted) throws Exception {
        SecretKeySpec skeySpec = new SecretKeySpec(raw, "AES");
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        IvParameterSpec ivParameterSpec = new IvParameterSpec(raw);

        cipher.init(Cipher.DECRYPT_MODE, skeySpec, ivParameterSpec);
        byte[] decrypted = cipher.doFinal(encrypted);
        return decrypted;
    }

    public static String toBase64(byte[] buf) {
        return Base64.encodeToString(buf, Base64.DEFAULT);
//        return Base64.encodeBytes(buf);
    }

    public static byte[] fromBase64(String str) throws Exception {
        return Base64.decode(str, Base64.DEFAULT);
    }

    String GOOGLE_PAY_PACKAGE_NAME = "com.google.android.apps.nbu.paisa.user";
    int GOOGLE_PAY_REQUEST_CODE = 999;
    private MethodChannel.Result myResult;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        this.flutterEngine = flutterEngine;
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getAppInstanceId")) {
                                if (!InstanceIdToken.equals("")) {
                                    result.success(InstanceIdToken);
                                } else {
                                    result.error("UNAVAILABLE", "Instance Id Not Available", null);
                                }
                            } else if (call.method.equals("EncryptText")) {
//                                Log.d("mobile_no", call.argument("mobile_no"));
                                String EncryptedText = "";
                                try {
                                    EncryptedText = encrypt(call.argument("mobile_no").toString());
                                    result.success(EncryptedText);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    result.error("UNAVAILABLE", "Error In Encrypting", null);
                                }
                            } else if (call.method.equals("openGpay")) {
                                Log.d("pa", call.argument("pa"));
                                Log.d("pn", call.argument("pn"));
                                Log.d("tr", call.argument("tr"));
                                Log.d("am", call.argument("am"));
                                Log.d("cu", call.argument("cu"));
                                Log.d("mc", call.argument("mc"));
                                Log.d("flow", call.argument("flow"));
                                Intent intent = new Intent(Intent.ACTION_VIEW);
                                if (call.argument("flow").toString().toLowerCase().equals("gpay")) {
                                    Uri uri =
                                            new Uri.Builder()
                                                    .scheme("upi")
                                                    .authority("pay")
                                                    .appendQueryParameter("pa", call.argument("pa"))
                                                    .appendQueryParameter("pn", call.argument("pa"))
                                                    .appendQueryParameter("mc", call.argument("mc"))
                                                    .appendQueryParameter("tr", call.argument("tr"))
                                                    .appendQueryParameter("tn", "")
                                                    .appendQueryParameter("am", call.argument("am"))
                                                    .appendQueryParameter("cu", "INR")
                                                    .appendQueryParameter("url", "")
                                                    .build();

                                    intent.setData(uri);
                                    intent.setPackage(GOOGLE_PAY_PACKAGE_NAME);
                                    ((Activity) this).startActivityForResult(intent, GOOGLE_PAY_REQUEST_CODE);
                                } else {
                                    intent.setData(Uri.parse(getUPIString(call.argument("pa"), call.argument("pa"), call.argument("mc"), "", call.argument("tr"), "", call.argument("am"), call.argument("cu"), "")));
                                    Intent chooser = Intent.createChooser(intent, "Pay with...");
                                    ((Activity) this).startActivityForResult(chooser, 999, null);
                                }
                            }  else if (call.method.equals("getUrl")) {
                                Intent intent = new Intent(Intent.ACTION_VIEW);
                                intent.setData(Uri.parse(call.argument("url").toString()));
                                intent.setPackage("com.android.chrome");
                                startActivity(intent);
                            } else {
                                result.notImplemented();
                            }

                        }
                );
    }

    private String getUPIString(String payeeAddress, String payeeName, String payeeMCC, String trxnID, String trxnRefId,
                                String trxnNote, String payeeAmount, String currencyCode, String refUrl) {
        String UPI = "upi://pay?pa=" + payeeAddress + "&pn=" + payeeName
                + "&tr=" + trxnRefId
                + "&am=" + payeeAmount + "&cu=" + currencyCode
                + "&mc=" + payeeMCC;
        return UPI;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        try {
            super.onActivityResult(requestCode, resultCode, data);

            if (requestCode == GOOGLE_PAY_REQUEST_CODE && resultCode == RESULT_OK) {
                Bundle bundle = data.getExtras();
                if (bundle != null) {
                    for (String key : bundle.keySet()) {
                        String Result = "UPI Data " + key + " : " + (bundle.get(key) != null ? bundle.get(key) : "NULL");
                        if (Result.contains("FAILURE"))
                            myResult.error("Payment Failed", "Payment Failed, Please Try Again Later", null);
                        else
                            myResult.success("Success");
//                        Log.d("UPI Data ", Result);
                    }
                }

                String requiredValue = data.getStringExtra("key");
            }
        } catch (Exception ex) {
//            Toast.makeText(getContext(), ex.toString(),
//                    Toast.LENGTH_SHORT).show();
        }

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.activity_main);

//        FirebaseAnalytics.getInstance(this).getAppInstanceId().addOnCompleteListener(this, instanceIdResult -> {
//            InstanceIdToken = instanceIdResult.getResult();
////            Log.e("newToken", InstanceIdToken);
//        });

//        MobileCore.setApplication(getApplication());
//        MobileCore.setLogLevel(LoggingMode.DEBUG);
//        MobileCore.setWrapperType(WrapperType.FLUTTER);
//
//        try {
//            Assurance.registerExtension();
//            Target.registerExtension();
//            Analytics.registerExtension();
//            CampaignClassic.registerExtension();
//            UserProfile.registerExtension();
//            Identity.registerExtension();
//            Lifecycle.registerExtension();
//            Signal.registerExtension();
//            MobileCore.start(new AdobeCallback() {
//                @Override
//                public void call(Object o) {
////                    MobileCore.configureWithAppID("64c36731dbac/416bd4714706/launch-a217127a6165-development");
//                    MobileCore.configureWithAppID("64c36731dbac/416bd4714706/launch-1eeaf9604bd1");
//                }
//            });
//        } catch (InvalidInitException e) {
//            Log.d("error", e.toString());
//        }
    }

    @Override
    protected void onResume() {
        super.onResume();
//        MobileCore.setApplication(getApplication());
//        MobileCore.lifecycleStart(null);
    }

    @Override
    public void onPause() {
        super.onPause();
//        MobileCore.lifecyclePause();
    }

}
