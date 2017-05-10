package com.microsoft.hsg.android.hvsample;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.microsoft.hsg.android.simplexml.client.HealthVaultClient;
import com.microsoft.hsg.android.simplexml.things.types.types.Record;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class RecordPickerArrayAdapter extends BaseAdapter {

	private List<Record> mRecords;
	private HashMap<String, String> mRecordImages;
	private LayoutInflater mLayoutInflater;

	private PersonalImageLoader mImageLoader;

	public RecordPickerArrayAdapter(Activity context, List<Record> records, HealthVaultClient hvClient) {
		mRecords = records;
		mLayoutInflater = LayoutInflater.from(context);
		mImageLoader = new PersonalImageLoader(context, hvClient);
	}

	@Override
	public int getCount() {
		return mRecords == null ? 0 : mRecords.size();
	}

	@Override
	public Record getItem(int position) {
		return mRecords.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolderItem viewHolder;
		if(convertView == null) {
			viewHolder = new ViewHolderItem();
			convertView = mLayoutInflater.inflate(R.layout.record_picker_item, parent, true);

			viewHolder.textViewItem = (TextView) convertView.findViewById(R.id.txt_recordname);
			viewHolder.imageViewItem = (ImageView) convertView.findViewById(R.id.record_icon);

			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolderItem) convertView.getTag();
		}

		viewHolder.textViewItem.setText(mRecords.get(position).getName());

		mImageLoader.load(mRecords.get(position).getId(), viewHolder.imageViewItem, R.drawable.ic_launcher);

		return convertView;
	}

	static class ViewHolderItem {
		TextView textViewItem;
		ImageView imageViewItem;
	}
}
