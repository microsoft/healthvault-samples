package com.microsoft.hsg.android.hvsample;

import java.util.ArrayList;
import java.util.List;
import java.util.Observable;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.microsoft.hsg.Connection;
import com.microsoft.hsg.HVException;
import com.microsoft.hsg.android.simplexml.HealthVaultApp;
import com.microsoft.hsg.android.simplexml.HealthVaultSettings;
import com.microsoft.hsg.android.simplexml.ShellActivity;
import com.microsoft.hsg.android.simplexml.client.HealthVaultClient;
import com.microsoft.hsg.android.simplexml.client.HealthVaultRestClient;
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
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

import healthvault.client.implementation.MicrosoftHealthVaultRestApiImpl;
import healthvault.client.models.ActionPlan;
import healthvault.client.models.ActionPlanInstance;
import healthvault.client.models.ActionPlansResponseActionPlanInstance;

import healthvault.client.models.Objective;
import okhttp3.ResponseBody;
import retrofit2.Response;
import rx.Subscriber;
import rx.Subscription;
import rx.schedulers.Schedulers;

public class ActionPlanActivity  extends Activity {
	private HealthVaultApp mService;
	private HealthVaultClient mClient;
	private Record mCurrentRecord;
	private ArrayAdapter<String> mAdapter;
	private ListView mPlanList;
	private static ActionPlansResponseActionPlanInstance mActionPlanInstance;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_actionplan);
		mService = HealthVaultApp.getInstance();
		mClient = new HealthVaultClient();

		if (mService.isAppConnected()) {
			mCurrentRecord = HealthVaultApp.getInstance().getCurrentRecord();
			getActionPlan();
		}
	}

	@Override
	protected void onStart() {
		super.onStart();
		mClient.start();
	}

	@Override
	protected void onStop() {
		mClient.stop();
		super.onStop();
	}

	@SuppressWarnings("unchecked")
	private void getActionPlan() {
		mService.getSettings().setRestUrl("https://data.ppe.microsofthealth.net/");
		HealthVaultSettings settings = mService.getSettings();
		Connection connection = mService.getConnection();

		final MicrosoftHealthVaultRestApiImpl restClient = new HealthVaultRestClient(settings, connection, mCurrentRecord).getClient();

		restClient.getActionPlansAsync()
				.subscribeOn(Schedulers.io())
				.observeOn(Schedulers.io())
				.subscribe(new Subscriber<Object>() {
					@Override
					public final void onCompleted() {
					}

					@Override
					public final void onError(final Throwable e) {
						Log.e("error", e.getMessage());
					}

					@Override
					public final void onNext(final Object response) {
						mActionPlanInstance = (ActionPlansResponseActionPlanInstance) response;
					}
				});
		renderActionPlans();
	}

	private void renderActionPlans() {
		List<String> actionplans = new ArrayList<String>();
		if (mActionPlanInstance != null) {
			int size = mActionPlanInstance.plans().size();
			for (int index = 0; index < size; ++index) {
				ActionPlanInstance plan = mActionPlanInstance.plans().get(index);
				actionplans.add("Plan: " + plan.name().toString() +
						"     Category: " + plan.category().toString());
			}
			mPlanList = (ListView) findViewById(R.id.actionplan_list);
			mAdapter = new ArrayAdapter<String>(ActionPlanActivity.this, android.R.layout.simple_list_item_1, actionplans);
			mPlanList.setAdapter(mAdapter);
		} else {
			Toast.makeText(ActionPlanActivity.this, "No Action plans!", Toast.LENGTH_SHORT).show();
			finish();
		}
	}
}


