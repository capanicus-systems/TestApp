package com.example.testapplication.Notification;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.media.RingtoneManager;
import android.os.Build;


import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.example.testapplication.MainActivity;
import com.example.testapplication.R;


public class Notificationshow {
    // Notification manager
    NotificationManager notifManager = null;

    // Notification show function
    public  Notification displayCustomNotification( Context context,String subject,String message,Long time,int notifyid) {



        String chatName = subject;
        String text = message;
        PendingIntent pendingIntent = preparePendingIntent( context);



        if (notifManager == null) {

            notifManager = (NotificationManager) context.getSystemService
                    (Context.NOTIFICATION_SERVICE);
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationCompat.Builder builder;

            int importance = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel mChannel = null;
            if (mChannel == null) {
                mChannel = new NotificationChannel
                        ("0", chatName, importance);
                mChannel.setDescription(text);
                mChannel.enableVibration(false);
                notifManager.createNotificationChannel(mChannel);
            }
            builder = new NotificationCompat.Builder(context, "0");

            builder.setContentTitle(chatName)
                    .setSmallIcon(getNotificationIcon()) // required
                    .setContentText(text)  // required
                    .setDefaults(Notification.DEFAULT_ALL)
                    .setWhen(time)
                    .setAutoCancel(false)
                    .setColor(ContextCompat.getColor(context, R.color.colorPrimary))
                    .setLargeIcon(BitmapFactory.decodeResource
                            (context.getResources(), R.mipmap.ic_launcher))
                    .setContentIntent(pendingIntent)
                    .setSound(RingtoneManager.getDefaultUri
                            (RingtoneManager.TYPE_NOTIFICATION))
                    .setStyle(new NotificationCompat.BigTextStyle().setBigContentTitle(chatName).bigText(text));
            Notification notification = builder.build();
            notifManager.notify(notifyid, notification);

            return notification;

        } else {


            //Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(context)
                    .setContentTitle(chatName)
                    .setContentText(text)
                    .setAutoCancel(false)
                    .setWhen(time)
                    .setColor(ContextCompat.getColor(context, R.color.colorPrimary))
                    .setSmallIcon(getNotificationIcon())
                    .setContentIntent(pendingIntent)
                    .setStyle(new NotificationCompat.BigTextStyle().setBigContentTitle(chatName).bigText(text));

            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.notify(notifyid, notificationBuilder.build());

            return notificationBuilder.build();
        }
    }
    // get icon function which show in notification
    private static int getNotificationIcon() {
        boolean useWhiteIcon = (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP);
        return useWhiteIcon ? R.drawable.notify : R.mipmap.ic_launcher;
    }

    // Making pending intent for when we click on notification app open
    private static PendingIntent preparePendingIntent(Context context) {
        Intent intent = new Intent(context, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);

        return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }



}
