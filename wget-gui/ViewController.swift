//
//  ViewController.swift
//  wget-gui
//
//  Created by Zac G on 23/06/2017.
//  Copyright © 2017 Zac G. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  @IBInspectable var normalColour: NSColor = .black
  @IBInspectable var errorColour: NSColor = .red
  @IBInspectable var fontSize: Int = 13
  @IBInspectable var errorFontSize: Int = 16
  
  @IBOutlet weak var textField: NSTextField!
  @IBOutlet weak var output: NSTextView!
  @IBOutlet weak var infoLabel: NSTextField!
  @IBOutlet weak var finalURLDisplay: NSTextField!
  
  override func viewDidAppear() {
    self.view.window?.titlebarAppearsTransparent = true
    self.view.window?.isMovableByWindowBackground = true
    self.view.window?.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    output.font = NSFont.userFixedPitchFont(ofSize: 13)
    infoLabel.stringValue = ""
    finalURLDisplay.stringValue = ""
    
    URLChanged(textField)
  }
  
  @IBAction func URLChanged(_ sender: NSTextField) {
    if textField.stringValue.characters.underestimatedCount < 5 {
      set(text: "", isError: false)
      infoLabel.stringValue = ""
      return
    }
    
    let url = URL(string: textField.stringValue)
    let request = URLRequest(url: url!)
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) {
      (data: Data?, response: URLResponse?, error: Error?) -> Void in
      
      DispatchQueue.main.async {
        self.onGetData(data: data, response: response, error: error)
      }
    }
    
    task.resume()
  }
  
  func set(text: String?, isError: Bool) {
    if text == nil {
      set(text: "An unknown error occured (1)", isError: true)
      return
    }
    
    output.textColor = isError ? errorColour : normalColour
    output.font = NSFont(name: (output.font?.fontName)!, size: CGFloat(isError ? errorFontSize : fontSize))
    output.string = text
    output.alignment = isError ? .center : .left
    
    if isError {
      infoLabel.stringValue = ""
      finalURLDisplay.stringValue = ""
    }
  }
  
  func onGetData(data: Data?, response: URLResponse?, error: Error?) -> Void {
    var code = 0
    
    if error != nil {
      infoLabel.stringValue = ""
      set(text: error?.localizedDescription as String?, isError: true)
      return
    }

    var serverName: String? = nil
    
    if let httpResponse = response as? HTTPURLResponse {
      code = httpResponse.statusCode
      
      if let server = httpResponse.allHeaderFields["Server"] {
        serverName = server as? String
      }
    } else {
      set(text: "An unknown error occured (2)", isError: true)
      return
    }
    
    var encoding = String.Encoding.utf8
    
    if response?.textEncodingName != nil {
      encoding = guessEncoding((response?.textEncodingName)!)
    }
    
    var info = "\(data?.count ?? 0) bytes"
    info += ", \(response?.mimeType ?? "")"
    info += ", status \(code)"
    info += ", \(encoding.description)"
    
    if serverName != nil {
      info += ", \(serverName!) server"
    }
    
    infoLabel.stringValue = info
    
    finalURLDisplay.stringValue = (response?.url?.absoluteString)!
    
    let string = String(data: data!, encoding: encoding)
    
    set(text: string, isError: false)
  }
  
  func guessEncoding(_ encodingString: String) -> String.Encoding {
    let cfe = CFStringConvertIANACharSetNameToEncoding(encodingString as CFString)
    let se = CFStringConvertEncodingToNSStringEncoding(cfe)
    
    return String.Encoding(rawValue: se)
  }
  
  @IBAction func downloadButtonClicked(_ sender: NSButton) {
    saveAs()
  }
  
  public func saveAs() {
    let panel = NSSavePanel()
    panel.allowsOtherFileTypes = true
    panel.showsHiddenFiles = true
    panel.canCreateDirectories = true
    
    panel.begin(completionHandler: { button in
      if button == NSFileHandlingPanelOKButton, let url = panel.url {
        do {
          if let str = self.output.string {
            try str.write(to: url, atomically: false, encoding: .utf8)
          }
        } catch {}
      }
    })
  }
  
  @IBAction func openInBrowser(_ sender: NSButton) {
    if let url = URL(string: textField.stringValue) {
      NSWorkspace.shared().open(url)
    }
  }
}

