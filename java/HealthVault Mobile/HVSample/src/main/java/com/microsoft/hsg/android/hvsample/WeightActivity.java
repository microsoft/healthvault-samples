package com.microsoft.hsg.android.hvsample;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Callable;

import com.jjoe64.graphview.*;
import com.jjoe64.graphview.series.*;
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
import android.graphics.Color;
import android.os.Bundle;
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

public class WeightActivity extends Activity {

	private HealthVaultApp mService;
	private HealthVaultClient mHVClient;
	private Record mCurrentRecord;
	private ListView mWeightList;
	private List<String> mWeights;
	private ArrayAdapter<String> mAdapter;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.weight);
		mService = HealthVaultApp.getInstance();
		mHVClient = new HealthVaultClient();

		mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();

		Button weightsBtn = (Button) findViewById(R.id.add_weight);
		final EditText editText = (EditText) findViewById(R.id.weight_input);

		mWeights = new ArrayList<String>();
		mWeightList = (ListView)findViewById(R.id.weight_list);
		mAdapter = new ArrayAdapter<String>(WeightActivity.this, android.R.layout.simple_list_item_1, mWeights);
		mWeightList.setAdapter(mAdapter);

		weightsBtn.setOnClickListener(new View.OnClickListener() {
			public void onClick(View view) {
				if (mService.isAppConnected()) {
					try {
						putWeight(editText.getText().toString());
						editText.setText("");
					} catch (Exception e) {
						Toast.makeText(WeightActivity.this, "Please enter a weight!", Toast.LENGTH_SHORT).show();
					}
				}
			}
		});

		setTitle("Weight Sample");
	}

	@Override
	protected void onResume() {
		super.onResume();
		mHVClient.start();
		getWeights();
	}

	@Override
	protected void onPause() {
		mHVClient.stop();
		super.onPause();
	}

	@SuppressWarnings("unchecked")
	private void getWeights() {
		mHVClient.asyncRequest(mCurrentRecord.getThingsAsync(ThingRequestGroup2.thingTypeQuery(Weight.ThingType)),
				new WeightCallback(WeightCallback.RenderWeights));
	}

	private void putWeight(String value) {
		final Thing2 thing = new Thing2();
		thing.setData(new Weight(Double.parseDouble(value)));
		mHVClient.asyncRequest(mCurrentRecord.putThingAsync(thing), new WeightCallback(WeightCallback.PutWeights));
	}

	private void renderWeights(List<Thing2> things) {
		if(!things.isEmpty()) {
			int xPoint = things.size() - 1;;
			GraphView graph = (GraphView) findViewById(R.id.graph);
			LineGraphSeries<DataPoint> series = new LineGraphSeries<>();
			int size = things.size();
			DataPoint dataPointArray[] = new DataPoint[size];

			// Populate the last weight view
			Weight lastWeightValue = (Weight) things.get(0).getData();
			TextView lastWeightTextView = (TextView) findViewById(R.id.last_weight);
			lastWeightTextView.setText(String.valueOf(lastWeightValue.getValue().getKg()));

			// Populate the list and last weight
			mAdapter.clear();
			for (Thing2 thing : things) {
				Weight weight = (Weight) thing.getData();
				final int month = weight.getWhen().getDate().getM();
				final int day = weight.getWhen().getDate().getD();
				final int year = weight.getWhen().getDate().getY();
				mAdapter.add(String.valueOf(String.format(month + "/" + day + "/" + year)
						+ "                                            " +
						String.valueOf(weight.getValue().getKg().shortValue())));

				// Populate the weight chart data points
				DataPoint dataPoint = new DataPoint(xPoint, weight.getValue().getKg().intValue());
				dataPointArray[xPoint] = dataPoint;
				xPoint--;
			}

			mAdapter.notifyDataSetChanged();

			series.resetData(dataPointArray);
			series.setColor(Color.WHITE);
			graph.setTitleColor(Color.WHITE);
			series.setDrawDataPoints(true);
			graph.addSeries(series);
		}
	}

	public class WeightCallback<Object> implements RequestCallback {
		public final static int RenderWeights = 0;
		public final static int PutWeights = 1;

		private int mEvent;

		public WeightCallback(int event) {
			WeightActivity.this.setProgressBarIndeterminateVisibility(true);
			mEvent = event;
		}

		@Override
		public void onError(HVException exception) {
			WeightActivity.this.setProgressBarIndeterminateVisibility(false);
			Toast.makeText(WeightActivity.this, String.format("An error occurred.  " + exception.getMessage()), Toast.LENGTH_LONG).show();
		}

		@Override
		public void onSuccess(java.lang.Object obj) {
			WeightActivity.this.setProgressBarIndeterminateVisibility(false);
			switch(mEvent) {
				case PutWeights:
					getWeights();
					break;
				case RenderWeights:
					renderWeights(((ThingResponseGroup2)obj).getThing());
					break;
			}
		}
	}
}
