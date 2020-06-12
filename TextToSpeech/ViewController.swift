//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Omar Tan Johan Tan on 09/06/20.
//  Copyright © 2020 Omar Tan Johan Tan. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var speakButton: UIButton!
    @IBOutlet weak var texts: UITextView!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        speakButton.layer.cornerRadius = 10
        speakButton.layer.cornerCurve = .continuous
        
        if !loadSettings() {
            registerDefaultSettings()
        }
    }
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings = ["rate": rate, "pitch": pitch, "volume": volume]
        UserDefaults.standard.register(defaults: defaultSpeechSettings as [String : Any])
    }
    
    func loadSettings() -> Bool {
        let userDefaults = UserDefaults.standard
        
        if let theRate: Float = userDefaults.value(forKey: "rate") as? Float {
            rate = theRate
            pitch = userDefaults.value(forKey: "pitch") as? Float
            volume = userDefaults.value(forKey: "volume") as? Float
            return true
        }
        return false
    }
    
    @IBAction func speak(_ sender: UIButton) {
        let speechUtterence = AVSpeechUtterance(string: texts.text)
        speechUtterence.rate = rate // 0.0 - 1.0
        speechUtterence.pitchMultiplier = pitch // 0.5 - 2.0 (Default: 1.0)
        speechUtterence.volume = volume // 0.0 - 1.0 (Default: 1.0)
        
        speechSynthesizer.speak(speechUtterence)
    }
}

extension UITextView{

      @IBInspectable var doneAccessory: Bool{
          get{
              return self.doneAccessory
          }
          set (hasDone) {
              if hasDone{
                  addDoneButtonOnKeyboard()
              }
          }
      }

      func addDoneButtonOnKeyboard()
      {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default

          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()

          self.inputAccessoryView = doneToolbar
      }

      @objc func doneButtonAction() {
          self.resignFirstResponder()
      }

  }
