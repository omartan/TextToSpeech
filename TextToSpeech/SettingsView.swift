//
//  SettingsView.swift
//  TextToSpeech
//
//  Created by Omar Tan Johan Tan on 10/06/20.
//  Copyright © 2020 Omar Tan Johan Tan. All rights reserved.
//

import AVFoundation
import UIKit

class SettingsView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var pickerView: UIPickerView!
    
    var voicesArray: [String] = []
    let speechVoices = AVSpeechSynthesisVoice.speechVoices()

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speechVoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speechVoices[row].language
    }
    
    @IBAction func done(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
