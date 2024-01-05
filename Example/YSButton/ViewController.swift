//
//  ViewController.swift
//  YSButton
//
//  Created by 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 on 01/05/2024.
//  Copyright (c) 2024 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. All rights reserved.
//

import UIKit
import YSButton

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn1 = YSButton(styleType: .default)
        btn1.frame = CGRectMake(100, 100, 130, 50)
        btn1.setTitle("Click Me", for: .normal)
        btn1.addTarget(self, action: #selector(changeStyle(_:)), for: .touchUpInside)
        view.addSubview(btn1)

        let btn2 = YSButton(style: .init(backgroundColor: .red))
        btn2.frame = CGRectMake(100, 200, 130, 50)
        btn2.setTitle("Click Me", for: .normal)
        btn2.addTarget(self, action: #selector(changeStyle(_:)), for: .touchUpInside)
        view.addSubview(btn2)
    }

    @objc func changeStyle(_ btn: YSButton) {
        if btn.styleType == .default {
            btn.styleType = .gray
            return
        }
        if btn.styleType == .gray {
            btn.styleType = .border
            return
        }
        if btn.styleType == .border {
            btn.styleType = .normal
            return
        }
        if btn.styleType == .normal {
            btn.styleType = .default
            return
        }

        if btn.styleType == .custom {
            btn.styleType = .default
        }
    }
}
