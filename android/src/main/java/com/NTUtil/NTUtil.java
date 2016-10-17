package com.NTUtil;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;

import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by taixiang on 16/10/13.
 */
public class NTUtil {

	/** Network type is unknown */
	public static final int NETWORK_TYPE_UNKNOWN = 0;
	/** Current network is GPRS */
	public static final int NETWORK_TYPE_GPRS = 1;
	/** Current network is EDGE */
	public static final int NETWORK_TYPE_EDGE = 2;
	/** Current network is UMTS */
	public static final int NETWORK_TYPE_UMTS = 3;
	/** Current network is CDMA: Either IS95A or IS95B*/
	public static final int NETWORK_TYPE_CDMA = 4;
	/** Current network is EVDO revision 0*/
	public static final int NETWORK_TYPE_EVDO_0 = 5;
	/** Current network is EVDO revision A*/
	public static final int NETWORK_TYPE_EVDO_A = 6;
	/** Current network is 1xRTT*/
	public static final int NETWORK_TYPE_1xRTT = 7;
	/** Current network is HSDPA */
	public static final int NETWORK_TYPE_HSDPA = 8;
	/** Current network is HSUPA */
	public static final int NETWORK_TYPE_HSUPA = 9;
	/** Current network is HSPA */
	public static final int NETWORK_TYPE_HSPA = 10;
	/** Current network is iDen */
	public static final int NETWORK_TYPE_IDEN = 11;
	/** Current network is EVDO revision B*/
	public static final int NETWORK_TYPE_EVDO_B = 12;
	/** Current network is LTE */
	public static final int NETWORK_TYPE_LTE = 13;
	/** Current network is eHRPD */
	public static final int NETWORK_TYPE_EHRPD = 14;
	/** Current network is HSPA+ */
	public static final int NETWORK_TYPE_HSPAP = 15;
	/** Current network is GSM {@hide} */
	public static final int NETWORK_TYPE_GSM = 16;
	/** Current network is TD_SCDMA {@hide} */
	public static final int NETWORK_TYPE_TD_SCDMA = 17;
	/** Current network is IWLAN {@hide} */
	public static final int NETWORK_TYPE_IWLAN = 18;

	/** Unknown network class. {@hide} */
	public static final int NETWORK_CLASS_UNKNOWN = 0;
	/** Class of broadly defined "2G" networks. {@hide} */
	public static final int NETWORK_CLASS_2_G = 1;
	/** Class of broadly defined "3G" networks. {@hide} */
	public static final int NETWORK_CLASS_3_G = 2;
	/** Class of broadly defined "4G" networks. {@hide} */
	public static final int NETWORK_CLASS_4_G = 3;



	/**
	 * 短信发送
	 */
	public static void sendMsg(Context context, String phoneNumber, String message) {
		Intent intent = new Intent(Intent.ACTION_SENDTO, Uri.parse("smsto:" + phoneNumber));
		intent.putExtra("sms_body", message);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		context.startActivity(intent);
	}

	/**
	 * 拨打电话
	 */
	public static void call(Context context,String mobile) {
		Intent i = new Intent(Intent.ACTION_CALL);
		i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		Uri data = Uri.parse("tel:" + mobile);
		i.setData(data);
		context.startActivity(i);
	}

	/**
	 * 网络类型判断
	 */
	public static void judgeNetType(ReactContext context,Callback callback){
		ConnectivityManager connManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = connManager.getActiveNetworkInfo();
		if(networkInfo == null){
			return;
		}
		int type = networkInfo.getType();
		if(type == ConnectivityManager.TYPE_WIFI){
			callback.invoke("wifi");
		}else if(type == ConnectivityManager.TYPE_MOBILE){
			TelephonyManager telephonyManager = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
			switch (getNetworkClass(telephonyManager.getNetworkType())){
				case NETWORK_CLASS_2_G:
					callback.invoke("2g");
					break;
				case NETWORK_CLASS_3_G:
					callback.invoke("3g");
					break;
				case NETWORK_CLASS_4_G:
					callback.invoke("4g");
					break;
				case NETWORK_CLASS_UNKNOWN:
					callback.invoke("unknown");
					break;
			}
		}
	}

	/**
	 * 网络是否可用,true 可用
	 */
	public static boolean isNetworkAvailable(){
		HttpURLConnection conn = null;
		boolean bRet = false;
		try {
			// 创建一个URL对象
			URL mURL = new URL("http://www.ly.com");
			// 调用URL的openConnection()方法,获取HttpURLConnection对象
			conn = (HttpURLConnection) mURL.openConnection();
			conn.setRequestMethod("HEAD");// 设置请求方法为post
			conn.setReadTimeout(500);// 设置读取超时为50毫秒
			conn.setConnectTimeout(1000);// 设置连接网络超时为1秒
			int responseCode = conn.getResponseCode();// 调用此方法就不必再使用conn.connect()方法
			if (responseCode > 0) {
				bRet = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null) {
				conn.disconnect();// 关闭连接
			}
		}
		return bRet;
	}

	/**
	 * 判断是否是debug
	 */
	public static boolean isApkDebugable(Context context) {
		ApplicationInfo info= context.getApplicationInfo();
		return (info.flags&ApplicationInfo.FLAG_DEBUGGABLE)!=0;
	}


	public static int getNetworkClass(int networkType) {
		switch (networkType) {
			case NETWORK_TYPE_GPRS:
			case NETWORK_TYPE_GSM:
			case NETWORK_TYPE_EDGE:
			case NETWORK_TYPE_CDMA:
			case NETWORK_TYPE_1xRTT:
			case NETWORK_TYPE_IDEN:
				return NETWORK_CLASS_2_G;
			case NETWORK_TYPE_UMTS:
			case NETWORK_TYPE_EVDO_0:
			case NETWORK_TYPE_EVDO_A:
			case NETWORK_TYPE_HSDPA:
			case NETWORK_TYPE_HSUPA:
			case NETWORK_TYPE_HSPA:
			case NETWORK_TYPE_EVDO_B:
			case NETWORK_TYPE_EHRPD:
			case NETWORK_TYPE_HSPAP:
			case NETWORK_TYPE_TD_SCDMA:
				return NETWORK_CLASS_3_G;
			case NETWORK_TYPE_LTE:
			case NETWORK_TYPE_IWLAN:
				return NETWORK_CLASS_4_G;
			default:
				return NETWORK_CLASS_UNKNOWN;
		}
	}


}
