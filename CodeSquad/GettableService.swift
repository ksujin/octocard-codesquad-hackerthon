//
//  PostableService.swift
//  CodeSquad
//
//  Created by 강수진 on 2018. 8. 15..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum Result<T> {
    case success(T)
    case error(String)
    case failure(Error)
}


protocol GettableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func get(_ URL:String, completion : @escaping (Result<networkResult>)->Void)
}

extension GettableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func get(_ URL:String, completion : @escaping (Result<networkResult>)->Void){
        print("chiecknetworkhere")
        
        guard let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("networking - invalid url")
            return
        }
        print(encodedUrl)
        
        Alamofire.request(encodedUrl, method: .get, parameters: nil, headers: nil).responseData {(res) in
            print("encodedURK")
            print(encodedUrl)
            switch res.result {

            case .success :
                if let value = res.result.value {
                    print("networking Here!")
                    print(encodedUrl)
                    print(JSON(value))
                    
                    
                    let decoder = JSONDecoder()
                    do {
                        let resCode = self.gino(res.response?.statusCode)
                        let data = try decoder.decode(NetworkData.self, from: value)
                        
                        let result : networkResult = (resCode, data)
                        completion(.success(result))
                        
                    }catch{
                        completion(.error("에러"))
                    }
                }
                break
            case .failure(let err) :
                print("network~~ error")
                print(err)
                completion(.failure(err))
                break
            }
            
        }
    }
}
