//
//  FollowingListModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class FollowingListModel:NSObject{
    
    var nextCursor:String!
    var userData:[FollowDetailData]!
    
    static func fetchFollowingList(userId:String, params:String, completionHandler: @escaping (FollowingListModel) -> ()){
        let url = "\(Constants.BASE_URL.rawValue)/1.1/friends/list.json?user_id=\(userId)\(params)"
        
        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
        ]
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                let followingModel = FollowingListModel()
                followingModel.nextCursor = data["next_cursor_str"].string
                let users = data["users"]
                var usersData = [FollowDetailData]()
                for i in 0..<users.count {
                    let userData = FollowDetailData()
                    userData.id = users[i]["id_str"].string
                    userData.name = users[i]["name"].string
                    userData.screenName = users[i]["screen_name"].string
                    userData.bio = users[i]["description"].string
                    userData.isVerified = users[i]["verified"].bool
                    userData.profileImage = users[i]["profile_image_url_https"].string
                    usersData.append(userData)
                }
                followingModel.userData = usersData
                
                DispatchQueue.main.async {
                    completionHandler(followingModel)
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
}


