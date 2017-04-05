//
//  ViewController.swift
//  Example
//
//  Created by Watanabe Toshinori on 4/5/17.
//  Copyright © 2017 Watanabe Toshinori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer: Timer?

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            print("\(Date().description)")
        })
    }

    // MARK: - Switch Action

    @IBAction func changeBackgroundMode(_ sender: UISwitch) {
        UIApplication.shared.isBackgroundModeEnabled = sender.isOn
    }

}

