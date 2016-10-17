package com.NTUtil;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.widget.Toast;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.modules.clipboard.ClipboardModule;
import com.facebook.react.modules.network.ForwardingCookieHandler;

/**
 * Created by taixiang on 16/10/13.
 */
public class NTUtilModule extends ReactContextBaseJavaModule {

	public static ReactApplicationContext context = null;
	private ClipboardModule clip = null;
	private ShakeListener shakeListener;
	private SensorManager sensorManager;
	private ForwardingCookieHandler cookieHandler = null;

	public NTUtilModule(ReactApplicationContext reactContext) {
		super(reactContext);
		context = reactContext;
		clip = new ClipboardModule(reactContext);
		cookieHandler = new ForwardingCookieHandler(reactContext);
	}

	@Override
	public String getName() {
		return "NTUtilModule";
	}

	/**
	 * android toast提示框
	 */
	@ReactMethod
	public void showToast(String message, int duration) {
		Toast.makeText(getReactApplicationContext(), message, duration).show();
	}

	/**
	 * 短信发送
	 */
	@ReactMethod
	public void sendMsg(String phoneNumber,String message){
		NTUtil.sendMsg(context, phoneNumber, message);
	}

	/**
	 * 拨打电话
	 */
	@ReactMethod
	public void call(String mobile){
		NTUtil.call(context, mobile);
	}

	/**
	 * 文字复制
	 */
	@ReactMethod
	public void copyText(String text){
		if(text != null){
			clip.setString(text);
		}
	}

	/**
	 * 网络类型判断
	 */
	@ReactMethod
	public void judgeNetType(Callback callback){
		NTUtil.judgeNetType(context, callback);
	}

	/**
	 * 网络是否可用判断
	 */
	@ReactMethod
	public void isNetworkAvailable(Callback callback){
		if(callback != null){
			callback.invoke(NTUtil.isNetworkAvailable());
		}
	}

	/**
	 * 摇一摇
	 */
	@ReactMethod
	public void registerShake(){
		ShakeListener.isReflesh = true;
		shakeListener = new ShakeListener(context);
		sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
		if(sensorManager != null){
			sensorManager.registerListener(shakeListener, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_NORMAL);
		}
	}

	/**
	 * 摇一摇停止
	 */
	@ReactMethod
	public void unregisterShake(){
		if(sensorManager != null){
			sensorManager.unregisterListener(shakeListener);
			sensorManager = null;
		}
	}

	/**
	 * 摇一摇复位
	 */
	@ReactMethod
	public void shakeReset(){
		ShakeListener.isReflesh = true;
	}

	/**
	 * 判读是否是debug模式
	 */
	@ReactMethod
	public void judgeIsDebug(Callback callback){
		if(null != callback){
			callback.invoke(NTUtil.isApkDebugable(context));
		}
	}

	/**
	 * 添加联系人
	 * @param name
	 * @param phoneList
	 * @param note  备注
	 */
	@ReactMethod
	public void addContact(String name, ReadableArray phoneList,String note) {
		Contact.addContactByCompanyName(name,phoneList,context,note);
	}

	/**
	 * 删除联系人
	 */
	@ReactMethod
	public void deleteContact(String name){
		Contact.deleteContact(name, context);
	}

	/**
	 * 查找联系人
	 * callback true为存在
	 */
	@ReactMethod
	public void selectContact(String name,Callback callback){
		callback.invoke(Contact.selectContactByName(name, context));
	}

	/**
	 * 获取联系人
	 */
	@ReactMethod
	public void getContactList(Callback callback){
		String contacts = Contact.sortContacts(context);
		if(null != contacts){
			callback.invoke(null,contacts);
		}else {
			callback.invoke("1",null);
		}
	}

	/**
	 * 保存网络图片
	 * callback true为成功
	 */
	@ReactMethod
	public void saveImage(ReadableArray url,Callback callback){
		if(url != null && url.size()>0){
			new PhotoAsyncTask(url,context,callback).execute();
		}
	}

	/**
	 * 清除cookie
	 */
	@ReactMethod
	public void clearCookie(){
		cookieHandler.clearCookies(new Callback() {
			@Override
			public void invoke(Object... args) {

			}
		});
	}


}
