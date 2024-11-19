package com.example.objects_transfer;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.FlutterEngineGroupCache;

public class MainActivity extends FlutterActivity {
    private FlutterEngine flutterEngine;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public FlutterEngine provideFlutterEngine(Context context) {
        if (flutterEngine == null) {
            FlutterEngineGroupCache engineGroupCache = FlutterEngineGroupCache.getInstance();
            FlutterEngineGroup engineGroup = engineGroupCache.get("main");
            if (engineGroup == null) {
                engineGroup = new FlutterEngineGroup(context);
                engineGroupCache.put("main", engineGroup);
            }
            flutterEngine = engineGroup.createAndRunDefaultEngine(this);
        }
        return flutterEngine;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        flutterEngine.destroy();
    }
}
