//
//  UserInfoVO.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 15..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation


enum LanguageName: String, Codable {
    case JAVA = "JAVA"
    case SWIFT = "SWIFT"
    case JAVASCRIPT = "JAVASCRIPT"
    case PYTHON = "PYTHON"
}


struct UserInfoVO: Codable {
    let info: String
    let language : String
    let topLanguages: [String]
}

