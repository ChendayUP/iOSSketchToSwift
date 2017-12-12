/*
// To load this framework, add the following code in your manifest.json

"commands": [
:
:
{
    "script" : "iOSCodeUI.framework/iOSCodeUI.js",
    "handlers" : {
        "actions" : {
            "Startup" : "onStartup",
            "OpenDocument":"onOpenDocument",
            "SelectionChanged.finish" : "onSelectionChanged"
        }
    }
}
]
*/

var onStartup = function(context) {
  var iOSCodeUI_FrameworkPath = iOSCodeUI_FrameworkPath || COScript.currentCOScript().env().scriptURL.path().stringByDeletingLastPathComponent().stringByDeletingLastPathComponent();
  var iOSCodeUI_Log = iOSCodeUI_Log || log;
  (function() {
    var mocha = Mocha.sharedRuntime();
    var frameworkName = "iOSCodeUI";
    var directory = iOSCodeUI_FrameworkPath;
    if (mocha.valueForKey(frameworkName)) {
      iOSCodeUI_Log("😎 loadFramework: `" + frameworkName + "` already loaded.");
      return true;
    } else if ([mocha loadFrameworkWithName:frameworkName inDirectory:directory]) {
      iOSCodeUI_Log("✅ loadFramework: `" + frameworkName + "` success!");
      mocha.setValue_forKey_(true, frameworkName);
      return true;
    } else {
      iOSCodeUI_Log("❌ loadFramework: `" + frameworkName + "` failed!: " + directory + ". Please define iOSCodeUI_FrameworkPath if you're trying to @import in a custom plugin");
      return false;
    }
  })();
};

var onSelectionChanged = function(context) {
  iOSCodeUI.onSelectionChanged(context);
};
