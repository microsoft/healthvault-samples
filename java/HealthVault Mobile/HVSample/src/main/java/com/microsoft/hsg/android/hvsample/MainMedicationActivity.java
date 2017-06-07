package com.microsoft.hsg.android.hvsample;

import android.app.Activity;
import android.os.Bundle;
import android.support.annotation.Nullable;

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
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class MainMedicationActivity extends Activity {
	private HealthVaultApp mService;
	private HealthVaultClient mHVClient;
	private Record mCurrentRecord;
	private static final String mCurrentMeds = "Current medications";
	private static final String mPastMeds = "Past medications";
	private static final int mIndex = 0;

	@Override
	protected void onCreate(@Nullable Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.medication_main);
		mService = HealthVaultApp.getInstance();
		mHVClient = new HealthVaultClient();

		mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();

		LinearLayout addMeddicationTile = (LinearLayout) findViewById(R.id.medication_layout);
		addMeddicationTile.setOnClickListener(new View.OnClickListener(){
			@Override
			public void onClick(View view) {
				if (mService.isAppConnected()) {
					Intent myIntent = new Intent(MainMedicationActivity.this, AddMedicationActivity.class);
					myIntent.putExtra(Constants.IndexParameter, mIndex);
					startActivity(myIntent);
				} else {
					Toast.makeText(MainMedicationActivity.this, "Please connect to HV from Setting menu!", Toast.LENGTH_SHORT).show();
				}
			}
		});

		setTitle("Medication sample");
	}

	@Override
	protected void onResume() {
		super.onResume();
		mHVClient.start();
		getMedications();
	}

	@Override
	protected void onPause() {
		mHVClient.stop();
		super.onPause();
	}

	private void getMedications() {
		mHVClient.asyncRequest(mCurrentRecord.getThingsAsync(ThingRequestGroup2.thingTypeQuery(Medication.ThingType)),
				new MedicationCallback());
	}

	private void renderMedications(List<Thing2> things) {
		if(!things.isEmpty()) {
			Medication meds = (Medication) things.get(mIndex).getDataXml().getAny().getThing().getData();

			TextView medicationTitle = (TextView) findViewById(R.id.medication_title);
			TextView medsName = (TextView) findViewById(R.id.medication_name);
			TextView dosage = (TextView) findViewById(R.id.dosage_strength);
			TextView prescribe = (TextView) findViewById(R.id.prescribed_date);

			final String dose = meds.getDose().getDisplay().toString();
			final String strength = meds.getStrength().getDisplay();
			final String name = meds.getName().getText();

			medsName.setText(name);
			dosage.setText(dose + ", " + strength);
			if (meds.getDateDiscontinued() == null) {
				medicationTitle.setText(mCurrentMeds);
			} else {
				medicationTitle.setText(mPastMeds);
				final String monthStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getM());
				final String dayStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getD());
				final String yearStart = String.valueOf(meds.getDateStarted().getStructured().getDate().getY());
				final String prescribed = String.format("prescribed: " + monthStart + "/" + dayStart + "/" + yearStart);

				String expired = "";
				if (meds.getDateDiscontinued() != null) {
					final String monthEnd = String.valueOf(meds.getDateStarted().getStructured().getDate().getM());
					final String dayEnd = String.valueOf(meds.getDateStarted().getStructured().getDate().getD());
					final String yearEnd = String.valueOf(meds.getDateStarted().getStructured().getDate().getY());
					expired = String.format("Expired: " + monthEnd + "/" + dayEnd + "/" + yearEnd);
				}

				prescribe.setText(prescribed + "  " + expired);
			}
		} else {
			Toast.makeText(MainMedicationActivity.this, "Currently there are no medications entered for user!", Toast.LENGTH_SHORT).show();
		}
	}

	public class MedicationCallback<Object> implements RequestCallback {

		public MedicationCallback() {
		}

		@Override
		public void onError(HVException exception) {
			Toast.makeText(MainMedicationActivity.this, String.format("An error occurred.  " + exception.getMessage()), Toast.LENGTH_SHORT).show();
		}

		@Override
		public void onSuccess(java.lang.Object obj) {
			renderMedications(((ThingResponseGroup2)obj).getThing());
		}
	}
}
