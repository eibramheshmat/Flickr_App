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
import Kingfisher

class AllPhotosListViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var photosTableView: UITableView!
    @IBOutlet weak var fullImageView: UIView!
    @IBOutlet weak var fullScreenImage: UIImageView!
    
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
            cell.setData(dataObj: elment)
        }.disposed(by: viewModel.disposeBag)
        
        photosTableView.rowHeight = 220
        
        photosTableView.rx.modelSelected(Photo.self).subscribe { (photo) in
            let url = URL(string: "https://farm\(photo.element?.farm ?? 0).static.flickr.com/\(photo.element?.server ?? "")/\(photo.element?.id ?? "")_\(photo.element?.secret ?? "").jpg")
            self.fullScreenImage.kf.setImage(with: url)
            self.fullImageView.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        photosTableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.photosTableView.contentOffset.y
            let contentHeight = self.photosTableView.contentSize.height

            if offSetY > (contentHeight - self.photosTableView.frame.size.height - 100) {
                let currentPage = Int(PhotoListAPI.currentPage) ?? 0
                let currentShouldBe = currentPage + 1
                PhotoListAPI.currentPage = "\(currentShouldBe)"
                self.viewModel.getAllPhotos()
            }
        }
        .disposed(by: viewModel.disposeBag)
    }
    
    @IBAction func closeFullScreenImgAction(_ sender: UIButton) {
        fullImageView.isHidden = true
    }
    
    
}
