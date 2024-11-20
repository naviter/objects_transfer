import Flutter
import UIKit
import background_locator_2

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var engineGroup: FlutterEngineGroup?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize and cache the FlutterEngineGroup
        engineGroup = SwizzlableFlutterEngineGroupCache.sharedInstance().get("main")
        if engineGroup == nil {
            let newEngineGroup = FlutterEngineGroup(name: "main", project: nil)
            SwizzlableFlutterEngineGroupCache.sharedInstance().put("main", engineGroup: newEngineGroup)
            engineGroup = newEngineGroup
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Ensure no default engine is created during Scene connection
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        guard let engine = appDelegate.engineGroup?.makeEngine(
            withEntrypoint: "main",
            libraryURI: "package:objects_transfer/main.dart"
        ) else { return }
        let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        GeneratedPluginRegistrant.register(with: engine)
        BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)

        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = flutterViewController
        self.window?.makeKeyAndVisible()
    }
}
