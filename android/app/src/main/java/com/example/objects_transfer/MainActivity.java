package com.example.objects_transfer;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineGroup;
import id.flutter.flutter_background_service.FlutterEngineGroupSingleton;

public class MainActivity extends FlutterActivity {
    private FlutterEngine flutterEngine;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public FlutterEngine provideFlutterEngine(Context context) {
        if (flutterEngine == null) {
            FlutterEngineGroupSingleton.initialize(this);
            FlutterEngineGroup flutterEngineGroup = FlutterEngineGroupSingleton.getInstance();
            flutterEngine = flutterEngineGroup.createAndRunDefaultEngine(this);
        }
        return flutterEngine;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        flutterEngine.destroy();
    }
}
