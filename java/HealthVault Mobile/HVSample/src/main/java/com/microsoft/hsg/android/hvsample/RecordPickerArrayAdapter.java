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
	
    private List<Record> records;
    private HashMap<String, String> recordImages;
    private LayoutInflater layoutInflater;
    
    private PersonalImageLoader imageLoader;

    public RecordPickerArrayAdapter(Activity context, 
    		List<Record> records,
    		HealthVaultClient hvClient) 
    {
        this.records = records;
        layoutInflater = LayoutInflater.from(context);
        imageLoader = new PersonalImageLoader(context, hvClient);
    }
    
    @Override
    public int getCount() {
        return records == null ? 0 : records.size();
    }

    @Override
    public Record getItem(int position) {
        return records.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View view, ViewGroup parent) {
        View rowView= layoutInflater.inflate(R.layout.record_picker_item, null, true);
        TextView txtTitle = (TextView) rowView.findViewById(R.id.txtrecordName);
        ImageView imageView = (ImageView) rowView.findViewById(R.id.recordIcon);
        txtTitle.setText(records.get(position).getName());
        
        imageLoader.load(records.get(position).getId(), imageView, R.drawable.ic_launcher);
        
        return rowView;
    }
}
