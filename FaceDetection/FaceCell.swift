//
//  FaceCell.swift
//  FaceDetection
//
//  Created by Jason Kim on 7/13/18.
//  Copyright © 2018 jkLabs. All rights reserved.
//

import UIKit

class FaceCell: UICollectionViewCell {
    
    var face: Face? {
        didSet {
            guard let face = face else { return }
            faceImageView.image = UIImage(named: face.image)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let faceImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        return image
    }()
    
    fileprivate func setupViews() {
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(red: 0, green: 255/255, blue: 255/255, alpha: 0.5)
        
        addSubview(faceImageView)
        faceImageView.anchor(centerX: nil, centerY: nil, top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0, leading: nil, trailing: nil, paddingLeading: 0, paddingTrailing: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
