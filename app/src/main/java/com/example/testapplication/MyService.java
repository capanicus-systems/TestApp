package com.example.testapplication;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.CountDownTimer;
import android.os.IBinder;

import androidx.core.app.NotificationCompat;

import com.example.testapplication.Notification.NotificationsControl;
import com.example.testapplication.Notification.Notificationshow;

import java.time.Duration;
import java.util.Calendar;
import java.util.concurrent.TimeUnit;

public class MyService extends Service {
    boolean starrforgroind;
    long time;
    int notifyid =0;
    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onCreate() {
        super.onCreate();
        final Notificationshow notif = new Notificationshow();
        final NotificationsControl control =  new NotificationsControl();

       // createStickyNotification();
        notifyid  = control.NOTIFICATION;
       time =  Calendar.getInstance().getTimeInMillis();
       starrforgroind = false;
        final String subject = "Your are on break";

        new CountDownTimer(300000, 1000) {

            public void onTick(long millisUntilFinished) {

                Notification notification =   notif.displayCustomNotification(MyService.this,subject,"Time left: "+String.format("%02d:%02d",
                         TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished) -
                                TimeUnit.HOURS.toMinutes(TimeUnit.MILLISECONDS.toHours(millisUntilFinished)), // The change is in this line
                        TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) -
                                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished))),time,notifyid);

                if(!starrforgroind)
                {
                    starrforgroind = true;
                    startForeground(notifyid, notification);
                }
            }

            public void onFinish() {
                control.cancelNotifications(MyService.this,notifyid);
                stopService(new Intent(MyService.this, MyService.class));
            }

        }.start();
    }


}
