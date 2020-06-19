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
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var texts: UITextView!
    @IBOutlet var actionButtons: [UIButton]!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for button in actionButtons {
            button.layer.cornerRadius = 10
            button.layer.cornerCurve = .continuous
        }

        if !loadSettings() {
            registerDefaultSettings()
        }
        
        texts.addDoneButtonOnKeyboard()
    }
    
    func animateActionButtonAppearance(_ shouldHideSpeakButton: Bool) {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            () -> Void in
            self.speakButton.alpha = speakButtonAlphaValue
            self.pauseButton.alpha = pauseStopButtonsAlphaValue
            self.stopButton.alpha = pauseStopButtonsAlphaValue
        })
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
        if !speechSynthesizer.isSpeaking {
            let textParagraphs = texts.text.components(separatedBy: "\n")
            
            for pieceOfText in textParagraphs {
                let speechUtterence = AVSpeechUtterance(string: pieceOfText)
                speechUtterence.rate = rate // 0.0 - 1.0
                speechUtterence.pitchMultiplier = pitch // 0.5 - 2.0 (Default: 1.0)
                speechUtterence.volume = volume // 0.0 - 1.0 (Default: 1.0)
                speechUtterence.postUtteranceDelay = 3
//                speechUtterence.preUtteranceDelay = 1
                
                speechSynthesizer.speak(speechUtterence)
            }
            
//            texts.isUserInteractionEnabled = false
        } else {
            // Continue speaking after pause
            speechSynthesizer.continueSpeaking()
//            texts.isUserInteractionEnabled = false
        }
        animateActionButtonAppearance(true)
        texts.isUserInteractionEnabled = false

    }
    
    @IBAction func pauseSpeech(_ sender: UIButton) {
        speechSynthesizer.pauseSpeaking(at: .word)

        animateActionButtonAppearance(false)
        texts.isUserInteractionEnabled = true

    }
    
    @IBAction func stopSpeech(_ sender: UIButton) {
        speechSynthesizer.stopSpeaking(at: .immediate)

        animateActionButtonAppearance(false)
        texts.isUserInteractionEnabled = true

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
          doneToolbar.tintColor = UIColor.init(red: 0.96, green: 0.40, blue: 0.26, alpha: 1.00)
            
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
