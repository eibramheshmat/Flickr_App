//
//  BaseViewController.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 20/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let baseViewModel = PhotoListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bindBaseViewModel()
        // Do any additional setup after loading the view.
    }
    
    func bindBaseViewModel() {
        baseViewModel.loading.asObservable().subscribe { (event) in
            self.showLoading(show: event.element ?? false)
        }.disposed(by: baseViewModel.disposeBag)
    }
    
    func showLoading(show: Bool) {
        DispatchQueue.main.async {
            if show{
                let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

                let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
                loadingIndicator.hidesWhenStopped = true
                loadingIndicator.style = UIActivityIndicatorView.Style.medium
                loadingIndicator.startAnimating();

                alert.view.addSubview(loadingIndicator)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

}
