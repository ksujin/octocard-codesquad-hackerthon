//
//  ViewController.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 14..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import Highlightr
import ActionSheetPicker
import SnapKit

class NameCardVC : UIViewController{
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var languageName: UILabel!
    @IBOutlet weak var themeName: UILabel!
    let pickerView = UIPickerView()
    var toolBar: UIToolbar = UIToolbar()
    var textView : UITextView!
    var highlightr : Highlightr!
    let textStorage = CodeAttributedString()
    var selectedLanguage = ""
    var selectedTheme = ""
    var topLanguages : [String] = []
    var userInfo = ""
    var headerView = HeaderView()
    var footerView = FooterView()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        highlightr = textStorage.highlightr
        makeConstraint()
        //넘겨 받은 데이터
        languageName.text = selectedLanguage
        themeName.text = selectedTheme
        // textStorage.language = languageName.text?.lowercased()
        setTextView()
        setFooterView()
        self.textStorage.language = selectedLanguage
        self.textStorage.highlightr.setTheme(to: selectedTheme)
        updateColors()
    }
    
    
    //공유
    @IBAction func shareBtn(_ sender: Any) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width : 410 , height : 538), false, 0)
        self.view.drawHierarchy(in: CGRect(x: 0, y: -64, width: 410, height: 603), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //share
        var imagesToShare = [AnyObject]()
        imagesToShare.append(image!)
        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        present(activityViewController, animated: true, completion: nil)
    }

    //취소
    @IBAction func cancleBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  
    func updateColors(){
        textView.backgroundColor = highlightr.theme.themeBackgroundColor
        view.backgroundColor = highlightr.theme.themeBackgroundColor
        self.headerView.backgroundColor = highlightr.theme.themeBackgroundColor
        self.footerView.backgroundColor = highlightr.theme.themeBackgroundColor
        navBar.barTintColor = highlightr.theme.themeBackgroundColor
        navBar.tintColor = invertColor(navBar.barTintColor!)
        languageName.textColor = navBar.tintColor
        themeName.textColor = navBar.tintColor.withAlphaComponent(0.5)
    }
    
    func invertColor(_ color: UIColor) -> UIColor{
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return UIColor(red:1.0-r, green: 1.0-g, blue: 1.0-b, alpha: 1)
    }
}

//컨스트레인
extension NameCardVC {
    
    func makeConstraint(){
        headerView = HeaderView.instanceFromNib()
        headerView.redView.makeRounded()
        headerView.yellowView.makeRounded()
        headerView.greenView.makeRounded()
        view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(navBar)
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        footerView = FooterView.instanceFromNib()
        view.addSubview(footerView)
        footerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(navBar)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(61)
        }
        
        
        viewPlaceholder.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.bottom.equalTo(footerView.snp.top)
            
        }
    } //constraint
}

//set textView, footerView
extension NameCardVC {
    
    func setTextView(){
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        textView = UITextView(frame: viewPlaceholder.bounds, textContainer: textContainer)
        textView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.autocapitalizationType = UITextAutocapitalizationType.none
        textView.textColor = UIColor(white: 0.8, alpha: 1.0)
        viewPlaceholder.addSubview(textView)
        textView.isEditable = false
        textView.text = userInfo
        
    } //setTextView
    
    func setFooterView(){
        footerView.firstLanguage.text = topLanguages[0]
        footerView.secondLanguage.text = topLanguages[1]
        footerView.thirdLanguage.text = topLanguages[2]
        
        if topLanguages[2] == "" {
            footerView.thirdLanguage.removeFromSuperview()
        }
        if topLanguages[1] == "" {
            footerView.secondLanguage.removeFromSuperview()
        }
        if topLanguages[0] == "" {
            footerView.firstLanguage.removeFromSuperview()
        }
        
        
    } //setFooterView
}


