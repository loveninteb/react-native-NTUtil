package com.NTUtil;

import android.os.AsyncTask;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;

/**
 * Created by tx36326 on 2016/8/1.
 */
public class PhotoAsyncTask extends AsyncTask<Void,Void,Void>{

	private ReadableArray url;
	private ReactApplicationContext context;
	private Callback callback;

	public PhotoAsyncTask(ReadableArray url, ReactApplicationContext context, Callback callback) {
		this.url = url;
		this.context = context;
		this.callback = callback;
	}

	@Override
	protected Void doInBackground(Void... params) {
		PhotoUtil.saveToGallery(url,context,callback);
		return null;
	}
}
