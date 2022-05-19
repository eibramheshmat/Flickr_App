//
//  PhotoListService.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 19/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class PhotoListService {
    let provider = MoyaProvider<PhotoListAPI>()
    
    
    func getPhotoList() -> Single<(String?, Photos?)>{

        return Single.create { single -> Disposable in
            self.provider.request(.getPhotoList) {[weak self] (result) in
                guard self != nil else { return }
                switch result{
                case .success(let response):
                    let jsonDecoder = JSONDecoder()
                    guard let responseRes =  try? jsonDecoder.decode(PhotoResults.self, from: response.data) else {
                        single(.success(("error when data mapping",nil)))
                        return
                    }
                    if let responseValue = responseRes.photos {
                        single(.success((nil,responseValue)))
                    } else {
                        single(.success(("empty data",nil)))
                    }
                case .failure(let error):
                    single(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}


