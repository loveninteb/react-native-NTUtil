package com.NTUtil;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Environment;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReadableArray;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by tx36326 on 2016/7/28.
 */
public class PhotoUtil {

	//获取网络图片
	public static boolean getHttpPhoto(String url, String filePath){
		Bitmap bitmap = null;
		InputStream is = null;
		FileOutputStream fos = null;
		boolean result = false;
		try {
			URL photoUrl = new URL(url);
			is = photoUrl.openStream();
			fos = new FileOutputStream(filePath, true);
			byte[] buffer = new byte[50*1024];
			int nRead = 0;
			while((nRead = is.read(buffer)) > 0) {
				fos.write(buffer, 0, nRead);
			}
			result = true;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		}catch (IOException e) {
			e.printStackTrace();
		}finally {
			try {
				if(is != null){
					is.close();
				}
				if (fos != null) {
					fos.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	//保存单张图片到图库
	public static boolean saveOnePhoto(String url, ReactApplicationContext context){

		File photoDir = new File(Environment.getExternalStorageDirectory(), "ntutil_image");
		if (!photoDir.exists()) {
			photoDir.mkdir();
		}
		if(url.length() > 0){
			int n1 = url.lastIndexOf('.');
			String fileName = System.currentTimeMillis() + ((n1>0) ? url.substring(n1):".jpg");
			File file = new File(photoDir, fileName);
			String filePath = file.getAbsolutePath();
			getHttpPhoto(url, filePath);
			Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file));
			context.sendBroadcast(intent);
			return true;
		}
		return false;
	}

	//保存多张图片
	public static void saveToGallery(ReadableArray urlList,ReactApplicationContext context, Callback callback){
		try {
			if(urlList != null && urlList.size() > 0){
				for (int i=0;i<urlList.size();i++){
					if(!saveOnePhoto(urlList.getString(i),context)){
						callback.invoke(false);
						return;
					}
				}
				callback.invoke(true);
			}
		} catch (Exception e) {
			e.printStackTrace();
			callback.invoke(false);
		}
	}

}
