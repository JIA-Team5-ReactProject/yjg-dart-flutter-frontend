package yeungjin.global_app;

import android.appwidget.AppWidgetProvider;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;
import android.content.SharedPreferences;
import androidx.security.crypto.EncryptedSharedPreferences;
import androidx.security.crypto.MasterKey;
import android.widget.RemoteViews;
import com.auth0.android.jwt.JWT;
import com.example.yjg.MainActivity;
import java.io.IOException;
import java.security.GeneralSecurityException;

public class MySecondAppWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        final int N = appWidgetIds.length;
        for (int i = 0; i < N; i++) {
            int appWidgetId = appWidgetIds[i];
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.bus_widget_layout);

            // 토큰 불러오기
            String token = null;
            try {
                MasterKey masterKey = new MasterKey.Builder(context)
                        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                        .build();

                SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
                        context,
                        "secret_shared_prefs",
                        masterKey,
                        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
                );

                token = sharedPreferences.getString("auth_token", null);

            } catch (GeneralSecurityException | IOException e) {
                e.printStackTrace();
            }

            // Intent 초기화
            Intent intent;
            if (token != null && !isTokenExpired(token)) {
                intent = new Intent(context, MainActivity.class);
                intent.setAction("ACTION_BUS_QR_" + appWidgetId);
                intent.putExtra("openPage", "/bus_qr");
            } else {
                intent = new Intent(context, MainActivity.class);
                intent.setAction("ACTION_LOGIN_" + appWidgetId);
                intent.putExtra("openPage", "/login");
            }

            PendingIntent pendingIntent = PendingIntent.getActivity(context, appWidgetId, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
            views.setOnClickPendingIntent(R.id.appwidget_image, pendingIntent);
            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }

    private boolean isTokenExpired(String token) {
        try {
            JWT jwt = new JWT(token);
            return jwt.isExpired(10); // 토큰이 만료되었는지 확인 (10초 유예)
        } catch (Exception e) {
            return true; // 토큰 디코딩 실패 시 만료된 것으로 간주
        }
    }
}