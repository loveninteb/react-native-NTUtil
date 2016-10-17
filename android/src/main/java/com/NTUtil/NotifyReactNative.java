package com.NTUtil;

import android.support.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class NotifyReactNative {
	// send event for notify react-native

	public static void sendEvent(@Nullable WritableMap params) {
		sendNativeEvent(NTUtilModule.context, "NTUtil", params);
	}

	/*
	 * 基础函数，发送通知
	 */
	public static void sendNativeEvent(ReactContext reactContext, String eventName,
									   @Nullable WritableMap params) {
		reactContext.getJSModule(
				DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(
				eventName, params);
	}

	/**
	 * 摇一摇
	 */
	public static void notifyShake(){
		WritableMap params = Arguments.createMap();
		params.putInt("type", 4001);
		sendEvent(params);
	}

}
