//
//  SwitchViewController.swift
//  CustomSwitch
//
//  Created by Hanyu Koji on 2018/02/09.
//  Copyright © 2018年 gaussbeam. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    
    @IBOutlet weak var switchStackView: UIStackView!
    @IBOutlet weak var topSwitch: CustomSwitch!
    @IBOutlet weak var bottoSwitch: CustomSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        self.switchStackView.transform = CGAffineTransform(rotationAngle: -0.5 * CGFloat.pi)
        
        self.topSwitch.borderColor = .white
        self.topSwitch.borderWidth = 8.0
        self.topSwitch.onTintColor = .red
        self.topSwitch.offTintColor = .red
        self.topSwitch.thumPadding = 16.0
        self.topSwitch.thumShadowColor = .clear
        self.topSwitch.labelDisplayMode = .none
        self.topSwitch.configure()
        
        self.bottoSwitch.borderColor = .white
        self.bottoSwitch.borderWidth = 8.0
        self.bottoSwitch.onTintColor = .white
        self.bottoSwitch.offTintColor = .white
        self.bottoSwitch.thumOnColor = .red
        self.bottoSwitch.thumOffColor = .red
        self.bottoSwitch.thumPadding = 16.0
        self.bottoSwitch.thumShadowColor = .clear
        self.bottoSwitch.labelDisplayMode = .none
        self.bottoSwitch.isOn = false
        self.bottoSwitch.configure()
    }
}
