//
//  PhotoListAPI.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 19/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public enum PhotoListAPI {
  // 1
    static private let privateKey = "d17378e37e555ebef55ab86c4180e8dc"
    static public var currentPage = "1"

  // 2
    case getPhotoList
}

extension PhotoListAPI: TargetType {
    
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var baseURL: URL {
        return URL(string: "https://www.flickr.com/services/rest/")!
    }
    
    public var path: String {
        switch self {
        case .getPhotoList:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getPhotoList:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getPhotoList:
            return .requestParameters(parameters: ["method":"flickr.photos.search",
            "format":"json",
            "nojsoncallback":"50",
            "text":"Color",
            "page":PhotoListAPI.currentPage,
            "per_page":"20",
            "api_key": PhotoListAPI.privateKey], encoding: URLEncoding.default)
        }
    }
    
}
