//
//  BaseViewModel.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 20/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    
    var loading = BehaviorRelay(value: false)
    let disposeBag = DisposeBag()
    
}
