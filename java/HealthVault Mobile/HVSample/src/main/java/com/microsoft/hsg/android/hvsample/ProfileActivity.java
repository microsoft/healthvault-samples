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
import com.microsoft.hsg.android.simplexml.things.types.medication.Medication;
import com.microsoft.hsg.android.simplexml.things.types.personal.PersonalDemographics;
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
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class ProfileActivity extends Activity {
	private HealthVaultApp mService;
	private HealthVaultClient mHVClient;
	private Record mCurrentRecord;
	private PersonalImageLoader mImageLoader;

	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.profile);
		mService = HealthVaultApp.getInstance();
		mHVClient = new HealthVaultClient();
		mImageLoader = new PersonalImageLoader(this, mHVClient);

		setTitle("Profile Sample");
	}

	private void populateProfile(List<Thing2> things) {
		PersonalDemographics personalDemographics = (PersonalDemographics) things.get(0).getDataXml().getAny().getThing().getData();
		final EditText firstNameEditText = (EditText) findViewById(R.id.first_name_text);
		final EditText secondtNameEditText = (EditText) findViewById(R.id.last_name_text);
		final EditText countryEditText = (EditText) findViewById(R.id.country_text);
		final EditText monthEditText = (EditText) findViewById(R.id.birth_month_text);
		final EditText yearEditText = (EditText) findViewById(R.id.birth_year_text);
		final EditText genderEditText = (EditText) findViewById(R.id.gender_text);
		ImageView imageView = (ImageView) findViewById(R.id.profileImage);

		mImageLoader.load(mCurrentRecord.getId(), imageView, R.drawable.record_image_placeholder);

		firstNameEditText.setText(personalDemographics.getName().getFirst());
		secondtNameEditText.setText(personalDemographics.getName().getLast());
		countryEditText.setText(mCurrentRecord.getLocationCountry());
		String birthMonth = String.valueOf(personalDemographics.getBirthdate().getDate().getM());
		String birthYear = String.valueOf(personalDemographics.getBirthdate().getDate().getY());

		monthEditText.setText(birthMonth);
		yearEditText.setText(birthYear);
		genderEditText.setText("male");
	}

	@Override
	protected void onResume() {
		super.onResume();
		mHVClient.start();

		mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();
		mHVClient.asyncRequest(mCurrentRecord.getThingsAsync(ThingRequestGroup2.thingTypeQuery(PersonalDemographics.ThingType)),
				new ProfileActivity.ProfileCallback());
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
			populateProfile(((ThingResponseGroup2)obj).getThing());
		}
	}
}
