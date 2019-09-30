package com.example.testapplication.Notification;

import android.app.NotificationManager;
import android.content.Context;

public class NotificationsControl {
// Notification id
    public final  int NOTIFICATION = 7000001;

// Notification cancel function using Notification id
    public  void cancelNotifications(Context ctx, int id) {
        NotificationManager mNotificationManager =
                (NotificationManager) ctx.getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.cancel(id);
    }

}
