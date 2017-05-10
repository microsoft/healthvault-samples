package com.microsoft.hsg.android.hvsample;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.Callable;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentCallbacks2;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v4.util.LruCache;
import android.widget.ImageView;
import android.widget.Toast;

import com.microsoft.hsg.HVException;
import com.microsoft.hsg.android.simplexml.HealthVaultApp;
import com.microsoft.hsg.android.simplexml.client.HealthVaultClient;
import com.microsoft.hsg.android.simplexml.client.RequestCallback;
import com.microsoft.hsg.android.simplexml.methods.getthings3.request.ThingRequestGroup2;
import com.microsoft.hsg.android.simplexml.methods.getthings3.response.ThingResponseGroup2;
import com.microsoft.hsg.android.simplexml.things.thing.Thing2;
import com.microsoft.hsg.android.simplexml.things.types.personalimage.PersonalImage;
import com.microsoft.hsg.android.simplexml.things.types.types.Record;

public class PersonalImageLoader implements ComponentCallbacks2 {

	private ImageLruCache mCache;
	private HealthVaultClient mHVClient;
	private Activity mContext;
	
	public PersonalImageLoader(Activity context,
		HealthVaultClient client) {
		ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        int memSize = activityManager.getMemoryClass() * 1024 * 1024;

		mCache = new ImageLruCache(memSize);
		mHVClient = client;
		mContext = context;
	}

	public void load(String id, ImageView imageView, int defaultResource) {
		imageView.setImageResource(defaultResource);
		Bitmap image = mCache.get(id);
		if (image != null) {
			imageView.setImageBitmap(image);
		} else {
			List<Record> records = HealthVaultApp.getInstance().getRecordList();
			Record record = null;

			for(Record rcd : records) {
				if(Objects.equals(id, rcd.getId())) {
					record = rcd;
					break;
				}
			}

			mHVClient.asyncRequest(getImageAsync(record), new PersonalImageCallback(id, imageView));
		}
	}

	private Callable<Bitmap> getImageAsync(final Record record) {
		return new Callable<Bitmap>() {
			public Bitmap call() throws URISyntaxException, IOException {
				// check if it exist in file
				File cacheDir = mContext.getCacheDir();

				if(!cacheDir.exists()) {
					cacheDir.mkdirs();
				}

				File file = new File(cacheDir, "personalimage" + record.getId());

				if(file.exists()) {
					try(FileInputStream in = new FileInputStream(file)) {
						return BitmapFactory.decodeStream(in);
					}
				}

				// try to get from web
				ThingResponseGroup2 response = record.getThings(ThingRequestGroup2.thingTypeQuery(PersonalImage.ThingType));
				List<Thing2> things = response.getThing();

				if(things != null && !things.isEmpty()) {
					Thing2 thing = things.get(0);
					PersonalImage image = (PersonalImage)thing.getData();
					FileOutputStream destination = null;
					FileInputStream inputStream = null;
					Bitmap bitmap;

					try {
						destination = new FileOutputStream(file);
						image.download(record, destination);

						inputStream = new FileInputStream(file);
						bitmap = BitmapFactory.decodeStream(inputStream);
						return bitmap;

					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						if (destination != null) {
							destination.close();
						}
						if (inputStream != null) {
							inputStream.close();
						}
					}
				}

				return null;
			}
		};
	}

	@Override
	public void onConfigurationChanged(Configuration arg0) {
		// TODO Auto-generated method stub
	}

	@Override
	public void onLowMemory() {
		// TODO Auto-generated method stub
	}

	@Override
	public void onTrimMemory(int level) {
		 if (level >= TRIM_MEMORY_MODERATE) {
			 mCache.evictAll();
		 } else if (level >= TRIM_MEMORY_BACKGROUND) {
			 mCache.trimToSize(mCache.size() / 2);
		}
	}
	
	private class ImageLruCache extends LruCache<String, Bitmap> {
		public ImageLruCache(int maxSize) {
			super(maxSize);
		}
	}

	private class PersonalImageCallback implements RequestCallback<Bitmap> {
		private ImageView mImageView;
		private String mId;
		
    	public PersonalImageCallback(String id, ImageView imageView) {
			mId = id;
			mImageView = imageView;
		}

		@Override
		public void onError(HVException exception) {
			Toast.makeText(
					mContext, "An error occurred.  " + exception.getMessage(), Toast.LENGTH_LONG).show();
		}

		@Override
		public void onSuccess(Bitmap image) {
			if(image != null) {
				mCache.put(mId, image);
				mImageView.setImageBitmap(image);
			}
		}
	}
}
