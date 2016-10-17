package com.NTUtil;

import android.app.Service;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.os.Vibrator;

/**
 * Created by taixiang on 16/9/23.
 */
public class ShakeListener implements SensorEventListener {

	private int ACCELERATE_VALUE =19;
	private Context context;
	private Vibrator vibrator;
	public static boolean isReflesh = true;

	public ShakeListener(Context context) {
		this.context = context;
		vibrator = (Vibrator) context.getSystemService(Service.VIBRATOR_SERVICE);
	}

	@Override
	public void onSensorChanged(SensorEvent event){
		if(!isReflesh){
			return;
		}

		float[] values = event.values;
		float x = Math.abs(values[0]);
		float y = Math.abs(values[1]);
		float z = Math.abs(values[2]);
		if(x>ACCELERATE_VALUE || y>ACCELERATE_VALUE ){
			vibrator.vibrate(500);
			isReflesh = false;
			NotifyReactNative.notifyShake();
		}

	}

	@Override
	public void onAccuracyChanged(Sensor sensor, int accuracy) {

	}
}
