//
//  UserInfoService.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 15..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkResult<T> {
    case networkSuccess(T)
    case noUser
    case networkFail
  
}

struct UserInfoService : GettableService {
    
    typealias NetworkData = UserInfoVO
    
    static let shareInstance = UserInfoService()
    func getUserInfo(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case 200 : completion(.networkSuccess(networkResult.resResult))
                default :
                 
                    break
                }
                break
            case .error(_) :
                completion(.noUser)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
        
    }
}
