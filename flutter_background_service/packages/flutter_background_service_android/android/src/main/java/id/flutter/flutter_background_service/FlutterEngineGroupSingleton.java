package id.flutter.flutter_background_service;

import android.content.Context;
import io.flutter.embedding.engine.FlutterEngineGroup;

public class FlutterEngineGroupSingleton {
    private static FlutterEngineGroup flutterEngineGroup;

    private FlutterEngineGroupSingleton() {}

    public static void initialize(Context context) {
        if (flutterEngineGroup == null) {
            flutterEngineGroup = new FlutterEngineGroup(context);
        }
    }

    public static FlutterEngineGroup getInstance() {
        if (flutterEngineGroup == null) {
            throw new IllegalStateException("FlutterEngineGroup not initialized. Call initialize() first.");
        }
        return flutterEngineGroup;
    }
}
