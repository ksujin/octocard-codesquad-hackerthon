//
//  LoginViewController.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 14..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit
import ActionSheetPicker
import Highlightr

class LoginViewController: UIViewController {
    var keyboardDismissGesture: UITapGestureRecognizer?

    @IBOutlet weak var addressTxtfield: UITextField!
    @IBOutlet weak var languageTxtfield: UITextField!
    @IBOutlet weak var themeTxtField: UITextField!
    var toolBar: UIToolbar = UIToolbar()
    let textStorage = CodeAttributedString()
    var highlightr : Highlightr!
    var topLanguages : [String] = []
    var userInfo = ""
    var selectedTheme : String?
    var selectedLanguage : String?
    lazy var blackView : UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardSetting()
        addressTxtfield.delegate = self
        themeTxtField.delegate = self
        languageTxtfield.delegate = self
        highlightr = textStorage.highlightr
        blackView.isHidden = true
        self.view.addSubview(blackView)
        blackView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        let address = addressTxtfield.text
        selectedTheme = themeTxtField.text
        selectedLanguage = languageTxtfield.text
        if (address == "") || (selectedTheme == "") || (selectedLanguage == "") {
           
            simpleAlert(title: "오류", message: "모든 필드를 입력해주세요")
            return
        }
        
      
        //params
        let lan = languageTxtfield.text!.uppercased()
        let userName = addressTxtfield.text!
        searchUser(url: "http://192.168.43.127:8080/octo-card?lan=\(lan)&username=\(userName)")

    }
   
    
    @objc func okBtnClick(_ sender:UIButton){
        addressTxtfield.resignFirstResponder()
    }

}

//ActionSheetPicker
extension LoginViewController {
    
    func pickTheme(){
        themeTxtField.resign()
       
        self.view.endEditing(true)
        //languageTxtfield.resign()
        
        let themes = highlightr.availableThemes()
        let indexOrNil = themes.index(of: themeTxtField.text!.lowercased())
        let index = (indexOrNil == nil) ? 0 : indexOrNil!
        
        ActionSheetStringPicker.show(withTitle: "Pick a Theme",
                                     rows: themes,
                                     initialSelection: index,
                                     doneBlock:
            { picker, index, value in
                let theme = value! as! String
                //self.textStorage.highlightr.setTheme(to: theme)
                self.themeTxtField.text = theme
                //self.updateColors()
        },
                                     cancel: nil,
                                     origin: toolBar)
    }
    
    func pickLanguage(){
        languageTxtfield.resign()
        
        self.view.endEditing(true)
        //themeTxtField.resign()
        let themes = ["swift", "java", "javascript", "python"]
        let indexOrNil = themes.index(of: themeTxtField.text!.lowercased())
        let index = (indexOrNil == nil) ? 0 : indexOrNil!
        
        ActionSheetStringPicker.show(withTitle: "Pick a Language",
                                     rows: themes,
                                     initialSelection: index,
                                     doneBlock:
            { picker, index, value in
                let theme = value! as! String
                //self.textStorage.highlightr.setTheme(to: theme)
                self.languageTxtfield.text = theme
                //self.updateColors()
        },
                                     cancel: nil,
                                     origin: toolBar)
    }
}

//textFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case languageTxtfield:
            self.pickLanguage()
        case themeTxtField :
            self.pickTheme()
        default:
            break
        }
    }
    
}

//키보드 대응
extension LoginViewController{
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        blackView.isHidden = false
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
         blackView.isHidden = true
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
    }
    
    //화면 바깥 터치했을때 키보드 없어지는 코드
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
    
}


//통신
extension LoginViewController {
     func searchUser(url : String) {
        UserInfoService.shareInstance.getUserInfo(url: url, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let value):
            
                let user = value as! UserInfoVO
               
                if let nameCardVC = self.storyboard?.instantiateViewController(withIdentifier:"NameCardVC") as? NameCardVC {
                    nameCardVC.selectedTheme = self.selectedTheme!
                    nameCardVC.selectedLanguage = self.selectedLanguage!
                    nameCardVC.userInfo = user.info
                    nameCardVC.topLanguages = user.topLanguages
                    
                    self.present(nameCardVC, animated: true, completion: nil)
                }
               
                break
            case .noUser :
                self.simpleAlert(title: "오류", message: "유저 이름을 확인해주세요")
            case .networkFail :
                self.simpleAlert(title: "오류", message: "네트워크 연결을 확인해주세요")
        
            }
            
        })
    }
}
