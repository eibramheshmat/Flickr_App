//
//  AllPhotosListViewController.swift
//  PhotoList_FlickrApp
//
//  Created by Ibram on 20/05/2022.
//  Copyright © 2022 Ibram. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AllPhotosListViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var photosTableView: UITableView!
    
    var viewModel = PhotoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableCell()
        bindViewModel()
        
    }
    
    func registerTableCell() {
        photosTableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
    }
    
    func bindViewModel() {
        photosTableView.rx.setDelegate(self).disposed(by: viewModel.disposeBag)
        viewModel.photoList.asObservable().bind(to: photosTableView.rx.items(cellIdentifier: "PhotosTableViewCell", cellType: PhotosTableViewCell.self))
        { index, elment, cell in
            cell.title.text = elment.title
            cell.imageView?.load(url: URL(string: "https://farm\(elment.farm).static.flickr.com/\(elment.server)/\(elment.id)_\(elment.secret).jpg"))
        }.disposed(by: viewModel.disposeBag)
        
        photosTableView.rowHeight = 200
    }
    
    
    
}

extension UIImageView {
    func load(url: URL?) {
        DispatchQueue.global().async { [weak self] in
            if let url = url{
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
