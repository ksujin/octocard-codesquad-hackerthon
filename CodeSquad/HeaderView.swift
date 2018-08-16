//
//  HeaderView.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 15..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    class func instanceFromNib() -> HeaderView {
        
        return UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
    }

}


