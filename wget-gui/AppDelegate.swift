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
  var mainViewController: ViewController? = nil
  
  func applicationDidFinishLaunching(_ n: Notification) {
    let app = n.object as? NSApplication
    
    if let viewController = app?.mainWindow?.contentViewController as! ViewController? {
      mainViewController = viewController
    }
  }

  func applicationWillTerminate(_ n: Notification) {
    
  }
  
  @IBAction func saveClicked(_ sender: NSMenuItem) {
    mainViewController?.save()
  }
  
  @IBAction func saveAsClicked(_ sender: NSMenuItem) {
    mainViewController?.saveAs()
  }
}

