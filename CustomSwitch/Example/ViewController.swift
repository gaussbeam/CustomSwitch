//
//  ViewController.swift
//  CustomSwitch
//
//  Created by Hanyu Koji on 2018/02/07.
//  Copyright © 2018年 gaussbeam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var customSwitches: [CustomSwitch]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure appearance
        
        self.customSwitches[0].borderColor = .clear
        self.customSwitches[0].borderWidth = 0.0
        self.customSwitches[0].onTintColor = UIColor(red: 159/255, green: 168/255, blue: 218/255, alpha: 1.0)
        self.customSwitches[0].thumOnColor = UIColor(red: 48/255, green: 63/255, blue: 159/255, alpha: 1.0)
        self.customSwitches[0].thumOffColor = UIColor(white: 0.8, alpha: 1.0)
        self.customSwitches[0].thumPadding = -4.0
        self.customSwitches[0].labelDisplayMode = .none
        
        self.customSwitches[1].borderColor = .black
        self.customSwitches[1].borderWidth = 0.5
        self.customSwitches[1].onTintColor = .black
        self.customSwitches[1].offTintColor = .clear
        self.customSwitches[1].animationDuration = 2.0
        self.customSwitches[1].labelDisplayMode = .none

        self.customSwitches[3].labelDisplayMode = .required(needsAnimating: false)
        self.customSwitches[3].onLabelText = "オン"
        self.customSwitches[3].offLabelText = "オフ"
        self.customSwitches[3].onLabelFont = .boldSystemFont(ofSize: 36.0)
        self.customSwitches[3].offLabelFont = .boldSystemFont(ofSize: 36.0)
        self.customSwitches[3].onTintColor = UIColor(red: 0.0, green: 192/255, blue: 32/255, alpha: 1.0)
        self.customSwitches[3].labelPaddingX = 16.0
        self.customSwitches[3].cornerRadiusScale = 0.2
        self.customSwitches[3].thumPadding = 8.0

        self.customSwitches[4].onLabelFont = .systemFont(ofSize: 24.0)
        self.customSwitches[4].offLabelFont = .systemFont(ofSize: 24.0)
        self.customSwitches[4].labelPaddingX = 20.0

        for customSwitch in self.customSwitches {
            customSwitch.configure()
        }

        // handling event
        self.customSwitches[0].addTarget(self, action: #selector(self.valueDidChange(_:)), for: .valueChanged)
    }
    
    @objc func valueDidChange(_ sender: CustomSwitch) {
        let state = sender.isOn ? "On" : "Off"
        print("State changed to `\(state)` | Selector")
    }
    
    @IBAction func switchVauleDidChange(_ sender: CustomSwitch) {
        let state = sender.isOn ? "On" : "Off"
        print("State changed to `\(state)` | IBAction")
    }
}
