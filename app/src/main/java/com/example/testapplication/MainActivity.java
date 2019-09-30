package com.example.testapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    MyService service;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView firsttext = findViewById(R.id.firsttext);

        // Here we check build variant type and set text on text field according to build flavor
        // Build flavour defile in gradle file
        if (BuildConfig.FLAVOR.equals("qa")) {
            firsttext.setText(getResources().getString(R.string.qa));
        }else if(BuildConfig.FLAVOR.equals("prod")){
            firsttext.setText(getResources().getString(R.string.production));
        }

        service = new MyService();
        if(!isMyServiceRunning(service.getClass()))
        {
        // checking version before calling service if device have version oreo or above then we call service in forground
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            {
                Intent serviceIntent = new Intent(this, MyService.class);
                serviceIntent.setPackage("com.example.testapplication.MyService");
                startForegroundService(serviceIntent);

            }
            else
            {

                Intent serviceIntent = new Intent(this, MyService.class);
                serviceIntent.setPackage("com.example.testapplication.MyService");
                startService(serviceIntent);
            }
        }


    }
// Checking service is already running or not
    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {

            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }

        return false;
    }

}
