package com.microsoft.hsg.android.hvsample;


import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;

import com.microsoft.hsg.HVException;
import com.microsoft.hsg.android.simplexml.HealthVaultApp;
import com.microsoft.hsg.android.simplexml.ShellActivity;
import com.microsoft.hsg.android.simplexml.client.HealthVaultClient;
import com.microsoft.hsg.android.simplexml.client.RequestCallback;
import com.microsoft.hsg.android.simplexml.methods.getthings3.request.ThingRequestGroup2;
import com.microsoft.hsg.android.simplexml.methods.getthings3.response.ThingResponseGroup2;
import com.microsoft.hsg.android.simplexml.things.thing.Thing2;
import com.microsoft.hsg.android.simplexml.things.types.types.PersonInfo;
import com.microsoft.hsg.android.simplexml.things.types.types.Record;
import com.microsoft.hsg.android.simplexml.things.types.weight.Weight;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class ProfileActivity extends Activity {
	private HealthVaultApp mService;
	private HealthVaultClient mHVClient;
	private Record mCurrentRecord;

	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.profile);
		mService = HealthVaultApp.getInstance();
		mHVClient = new HealthVaultClient();

		setTitle("Profile Sample");
	}

	private void populateProfile() {
		final EditText firstNameEditText = (EditText) findViewById(R.id.firstNameText);
		final EditText secondtNameEditText = (EditText) findViewById(R.id.lastNameText);

		String name = mCurrentRecord.getName();
		String[] firstLastName = name.split(" ");
		String fisrtName = firstLastName[0];
		String lasttName = firstLastName[1];
		firstNameEditText.setText(fisrtName);
		secondtNameEditText.setText(lasttName);

	}

	@Override
	protected void onResume() {
		super.onResume();
		mHVClient.start();
		mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();
		populateProfile();
	}

	@Override
	protected void onPause() {
		mHVClient.stop();
		super.onPause();
	}

	public class ProfileCallback<Object> implements RequestCallback {
		public ProfileCallback() {
		}

		@Override
		public void onError(HVException exception) {
			Toast.makeText(ProfileActivity.this, String.format("An error occurred.  " + exception.getMessage()), Toast.LENGTH_LONG).show();
		}

		@Override
		public void onSuccess(java.lang.Object obj) {
			populateProfile();
		}
	}
}
