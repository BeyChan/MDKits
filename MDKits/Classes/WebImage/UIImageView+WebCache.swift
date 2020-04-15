//
//  UIImageView+WebCache.swift
//  MDKit
//
//  Created by  MarvinChan on 2019/10/14.
//

import UIKit
import Kingfisher

extension UIImageView {
    public typealias DownloadProgressBlockClosure = ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)
    
    public typealias ExternalCOmpletionBlock = (UIImage?, Error?) -> ()
    
    public func renderRemoteImage(with url : MDURLConvertible?,
                                  imagePlaceholder : UIImage?,
                                  options : KingfisherOptionsInfo? = [.transition(.fade(1))],
                                  progressBlock : DownloadProgressBlockClosure?=nil,
                                  _ completion: ExternalCOmpletionBlock? = nil) {
        guard let url = url?.urlValue else { return }
        self.kf.setImage(with: url, placeholder: imagePlaceholder, options: options, progressBlock: progressBlock) { (image, error, cacheType, url) in
            completion?(image,error)
        }
    }
}
