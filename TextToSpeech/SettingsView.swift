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
    let speechVoices = AVSpeechSynthesisVoice.speechVoices().sorted(by: {    Locale.current.localizedString(forLanguageCode: $0.language)! < Locale.current.localizedString(forLanguageCode: $1.language)!
})

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
        let language = Locale.current.localizedString(forLanguageCode: speechVoices[row].language)!
        let languageCode = speechVoices[row].language
        
//        var regionCodeArray = languageCode.split(separator: "-") // FIXME: buggy may break
//        let regionCode = regionCodeArray.removeLast()
        
        var regionCode:String = ""
        for region in Locale.isoRegionCodes {
            // Test if provided region codes has voices or not
            if languageCode.contains(region) {
                regionCode = region
            }
        }
        
        let country = Locale.current.localizedString(forRegionCode: String(regionCode))
        
        return "\(language) (\(country ?? ""))"
    }
    
    @IBAction func done(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
