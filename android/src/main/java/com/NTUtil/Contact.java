package com.NTUtil;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.ContactsContract;
import android.util.Log;

import com.facebook.react.bridge.ReadableArray;
import com.github.promeg.pinyinhelper.Pinyin;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by tx36326 on 2016/7/18.
 * 联系人相关
 */
public class Contact {

	/**
	 * 通讯录新增一条记录
	 * @param name
	 * @param phoneList
	 * @param context
	 */
	public static void addContactByCompanyName(String name , ReadableArray phoneList, Context context, String note){

		try {
			Uri uri = Uri.parse("content://com.android.contacts/raw_contacts");
			ContentResolver resolver = context.getContentResolver();
			ContentValues values = new ContentValues();
			Uri contentUri = resolver.insert(uri, values);
			if(contentUri != null ){
				long contactid = ContentUris.parseId(contentUri);
				uri = Uri.parse("content://com.android.contacts/data");

				//添加姓名
				values.put("raw_contact_id", contactid);
				values.put(ContactsContract.Data.MIMETYPE, "vnd.android.cursor.item/name");
				values.put("data1", name);
				resolver.insert(uri, values);
				values.clear();

				//添加电话
				for(int i=0;i<phoneList.size();i++){
					values.put("raw_contact_id", contactid);
					values.put(ContactsContract.Data.MIMETYPE, "vnd.android.cursor.item/phone_v2");
					values.put("data1", phoneList.getString(i));
					values.put(ContactsContract.CommonDataKinds.Phone.TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_CUSTOM);
					values.put(ContactsContract.CommonDataKinds.Phone.LABEL,"商务电话");
					resolver.insert(uri, values);
					values.clear();
				}

				if(note != null && note.length() > 0){
					//添加备注
					values.put("raw_contact_id", contactid);
					values.put(ContactsContract.Data.MIMETYPE,ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE);
					values.put(ContactsContract.CommonDataKinds.Note.NOTE,note);
					resolver.insert(uri, values);
					values.clear();
				}

				Bitmap sourceBitmap = BitmapFactory.decodeResource(context.getResources(), R.drawable.ic_launcher);
				final ByteArrayOutputStream os = new ByteArrayOutputStream();
				// 将Bitmap压缩成PNG编码，质量为100%存储
				sourceBitmap.compress(Bitmap.CompressFormat.PNG, 100, os);
				byte[] avatar =os.toByteArray();

				values.put(ContactsContract.Data.RAW_CONTACT_ID, contactid);
				values.put(ContactsContract.Data.MIMETYPE, ContactsContract.CommonDataKinds.Photo.CONTENT_ITEM_TYPE);
				values.put(ContactsContract.CommonDataKinds.Photo.PHOTO, avatar);
				resolver.insert(uri, values);
				values.clear();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}


	}

	/**
	 * 根据姓名查找联系人,是否存在
	 * @param name
	 */
	public static boolean selectContactByName(String name,Context context){

		try{
			Uri uri = Uri.parse("content://com.android.contacts/contacts");
			//获得一个ContentResolver数据共享的对象
			ContentResolver reslover = context.getContentResolver();
			String[] mContactsProjection = new String[]{ContactsContract.Contacts.DISPLAY_NAME};
			Cursor cursor = reslover.query(uri, mContactsProjection, null, null, null);
			if(cursor != null){
				while(cursor.moveToNext()){
					String n = cursor.getString(0);
					if(n.equals(name)){
						return true;
					}
				}
				cursor.close();
			}
		}catch (Exception ex){
			String s = (ex.getMessage() ==null) ? "ex is null ":ex.getMessage();
			Log.e("Error", s);
		}
		return false;

	}

	/**
	 * 删除联系人
	 * @param name
	 * @param context
	 */
	public static void deleteContact(String name,Context context){
		try {
			if(selectContactByName(name,context)){
				Uri uri = Uri.parse("content://com.android.contacts/raw_contacts");
				ContentResolver resolver = context.getContentResolver();
				Cursor cursor = resolver.query(uri, new String[]{ContactsContract.Data._ID},"display_name=?", new String[]{name}, null);
				if(cursor != null && cursor.moveToFirst()){
					int id = cursor.getInt(0);
					//根据id删除data中的相应数据
					resolver.delete(uri, "display_name=?", new String[]{name});
					uri = Uri.parse("content://com.android.contacts/data");
					resolver.delete(uri, "raw_contact_id=?", new String[]{id+""});
					cursor.close();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 * 读取联系人列表
	 *
	 * @param context
	 * @return
	 */
	public static ArrayList<ContactItem> readContact(Context context) {
		ArrayList<ContactItem> contacts = new ArrayList<>();
		ContentResolver reslover = context.getContentResolver();
		String[] mContactsProjection = new String[]{ContactsContract.Contacts.SORT_KEY_PRIMARY, ContactsContract.CommonDataKinds.Phone.NUMBER, ContactsContract.Contacts.DISPLAY_NAME};

		String phoneNum;
		String name;
		String s;
		Cursor cursor = reslover.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, mContactsProjection, null, null, ContactsContract.Contacts.SORT_KEY_PRIMARY);
		if (null != cursor) {
			while (cursor.moveToNext()) {
				try {
					phoneNum = cursor.getString(1).trim();
					name = cursor.getString(2).trim();
					ContactItem mContact = new ContactItem();
					if(name.length()>0 && phoneNum.length()>0){
						s = Pinyin.toPinyin(name.charAt(0)).trim();
						if(s.length() > 0){
							mContact.name = name.trim();
							mContact.sort_key_primary = s.charAt(0);
							mContact.phone = phoneNum.trim();
							if(mContact.phone.startsWith("1")|| mContact.phone.startsWith("+86")){
								contacts.add(mContact);
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			cursor.close();
		}
		return contacts;
	}

	/**
	 * 联系人列表分组
	 *
	 * @param context
	 * @return
	 */
	public static String sortContacts(Context context) {
		ArrayList<ContactItem> contacts = readContact(context);
		if(contacts.size() == 0){
			return null;
		}
		ArrayList<ArrayList<ContactItem>> allContactLists = new ArrayList<>();
		Gson gson = new GsonBuilder().create();
		Map<String, ArrayList<ContactItem>> map = new LinkedHashMap<>();
		for (int i = 0; i < 27; i++) {
			allContactLists.add(new ArrayList<ContactItem>());
		}
		for (int i = 0; i < contacts.size(); i++) {
			char index = contacts.get(i).sort_key_primary;
			if (index >= 'A' && index <= 'Z') {
				allContactLists.get(index - 65).add(contacts.get(i));
			} else {
				allContactLists.get(26).add(contacts.get(i));
			}
		}
		for (int i = 0; i < 27; i++) {
			if (i < 26) {
				map.put("" + (char) (i + 'A'), allContactLists.get(i));
			} else {
				map.put("#", allContactLists.get(i));
			}
		}
		return gson.toJson(map);
	}

	private static class ContactItem {
		public String name;
		public String phone;
		public char sort_key_primary;
	}
}
