//
//  SettingsViewController.swift
//  BrunoFlix
//
//  Created by Bruno Garcia on 24/11/18.
//  Copyright © 2018 Bruno Garcia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var scColors: UISegmentedControl!
    //@IBOutlet weak var vColor: UIView!
    @IBOutlet weak var swAutoPlay: UISwitch!
    @IBOutlet weak var lbSystemColor: UILabel!
    @IBOutlet weak var lbAutoPlay: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Localization.settingsTitle
        lbSystemColor.text = Localization.lblSystemColor
        lbAutoPlay.text = Localization.lblAutoPlay
        
        scColors.removeAllSegments()
        scColors.insertSegment(withTitle: Localization.lblBlue, at: 0, animated: false)
        scColors.insertSegment(withTitle: Localization.lblGreen, at: 1, animated: false)
        scColors.insertSegment(withTitle: Localization.lblPink, at: 2, animated: false)
        scColors.insertSegment(withTitle: Localization.lblBlack, at: 3, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColor()
        swAutoPlay.setOn(UserDefaultsManager.autoPlay(), animated: false)
    }
    
    func setColor(){
        scColors.selectedSegmentIndex = UserDefaultsManager.colorNumber()
        self.view.backgroundColor = UIColor(named: SegmentedColors.allValues[UserDefaultsManager.colorNumber()].rawValue )
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        UserDefaultsManager.setColor(to: sender.selectedSegmentIndex)
        self.view.backgroundColor = UIColor(named: SegmentedColors.allValues[UserDefaultsManager.colorNumber()].rawValue )
        
    }
    
    @IBAction func changeAutoPlay(_ sender: UISwitch) {
        UserDefaultsManager.setAutoPlay(to: sender.isOn)
    }
    
}
