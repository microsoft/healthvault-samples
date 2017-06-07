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
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class AddMedicationActivity extends Activity {
	private HealthVaultApp mService;
	private HealthVaultClient mHVClient;
	private Record mCurrentRecord;
	private int mIndex = 0;

	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.add_medication);
		mService = HealthVaultApp.getInstance();
		mHVClient = new HealthVaultClient();
		mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();

		Intent mIntent = getIntent();
		mIndex = mIntent.getIntExtra(Constants.IndexParameter, 0);

		setTitle("Medication details sample");
	}


	@Override
	protected void onResume() {
		super.onResume();
		mHVClient.start();
		displayMedication();
	}


	@Override
	protected void onPause() {
		mHVClient.stop();
		super.onPause();
	}

	private void displayMedication() {
		mHVClient.asyncRequest(mCurrentRecord.getThingsAsync(ThingRequestGroup2.thingTypeQuery(Medication.ThingType)),
				new medicationRecordCallback());
	}

	private void renderMedicationRecord(List<Thing2> things) {
		if(!things.isEmpty()) {
			Medication meds = (Medication) things.get(mIndex).getDataXml().getAny().getThing().getData();

			TextView medsName = (TextView) findViewById(R.id.name_text);
			TextView strength = (TextView) findViewById(R.id.strength_text);
			TextView dosage = (TextView) findViewById(R.id.dosagetype_text);
			TextView often = (TextView) findViewById(R.id.howoften_text);
			TextView taken = (TextView) findViewById(R.id.howtaken_text);
			TextView reason = (TextView) findViewById(R.id.reason_text);
			TextView dateStarted = (TextView) findViewById(R.id.datestarted_text);

			medsName.setText(meds.getName().getText());
			strength.setText(meds.getStrength().getDisplay());
			dosage.setText(meds.getDose().getDisplay());

			if(meds.getFrequency() != null) {
				often.setText(meds.getFrequency().getDisplay().toString());
			}

			if (meds.getRoute() != null) {
				taken.setText(meds.getRoute().getText());
			}

			if (meds.getIndication() != null) {
				reason.setText(meds.getIndication().getText());
			}

			if (meds.getDateStarted() != null) {
				final String monthStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getM());
				final String dayStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getD());
				final String yearStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getY());
				final String prescribed = String.format(monthStart + "/" + dayStart + "/" + yearStart);
				dateStarted.setText(prescribed);
			}
		} else {
			Toast.makeText(AddMedicationActivity.this, "Unable to get medication with this index!", Toast.LENGTH_SHORT).show();
		}
	}

	public class medicationRecordCallback<Object> implements RequestCallback {

		public medicationRecordCallback() {
		}

		@Override
		public void onError(HVException exception) {
			Toast.makeText(AddMedicationActivity.this, String.format("An error occurred.  " + exception.getMessage()), Toast.LENGTH_SHORT).show();
		}

		@Override
		public void onSuccess(java.lang.Object obj) {
			renderMedicationRecord(((ThingResponseGroup2)obj).getThing());
		}
	}
}
