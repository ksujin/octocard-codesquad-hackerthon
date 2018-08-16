//
//  FooterView.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 15..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    @IBOutlet weak var firstLanguage: UILabel!
    @IBOutlet weak var secondLanguage: UILabel!
    @IBOutlet weak var thirdLanguage: UILabel!
    
    class func instanceFromNib() -> FooterView {
        
        return UINib(nibName: "FooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FooterView
    }
   

}
