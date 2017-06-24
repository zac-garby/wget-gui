//
//  AppDelegate.swift
//  wget-gui
//
//  Created by Zac G on 23/06/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var app: NSApplication? = nil
  
  func applicationDidFinishLaunching(_ n: Notification) {
    app = n.object as? NSApplication
  }

  func applicationWillTerminate(_ n: Notification) {
    // Insert code here to tear down your application
  }
  
  @IBAction func saveAsClicked(_ sender: NSMenuItem) {
    if let vc = app?.mainWindow?.contentViewController as! ViewController? {
      vc.saveAs()
    }
  }
}

