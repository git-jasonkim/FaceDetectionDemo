//
//  FacesCollectionView.swift
//  FaceDetection
//
//  Created by Jason Kim on 7/13/18.
//  Copyright © 2018 jkLabs. All rights reserved.
//

import UIKit

struct Face {
    let image: String
    let faceCoverage: CGFloat
    
    init(imageName: String, faceCoverage: CGFloat) {
        self.image = imageName
        self.faceCoverage = faceCoverage
    }
}

class FacesCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var cameraController: CameraController? {
        didSet {
            
        }
    }
    
    let facesArray = [Face(imageName: "face_botBender", faceCoverage: 1.5), Face(imageName: "face_botEve", faceCoverage: 1.5), Face(imageName: "face_botRobo", faceCoverage: 1.5), Face(imageName: "face_botStarWars", faceCoverage: 1.5), Face(imageName: "face_bulbasaur", faceCoverage: 1.5), Face(imageName: "face_charmander", faceCoverage: 1.5), Face(imageName: "face_cyclops", faceCoverage: 1.5), Face(imageName: "face_dog", faceCoverage: 1.5), Face(imageName: "face_emojiDead", faceCoverage: 1.2), Face(imageName: "face_emojiEmbarrassed", faceCoverage: 1.2), Face(imageName: "face_emojiHilarious", faceCoverage: 1.2), Face(imageName: "face_emojiLove", faceCoverage: 1.2), Face(imageName: "face_emojiThief", faceCoverage: 1.2), Face(imageName: "face_happyPixel", faceCoverage: 1.2), Face(imageName: "face_madPink", faceCoverage: 1.5), Face(imageName: "face_monsterBlue", faceCoverage: 1.7), Face(imageName: "face_monsterDots", faceCoverage: 137), Face(imageName: "face_monsterGreen", faceCoverage: 1.7), Face(imageName: "face_monsterPink", faceCoverage: 1.7), Face(imageName: "face_panda", faceCoverage: 1.5), Face(imageName: "face_pikachu", faceCoverage: 1.7), Face(imageName: "face_poo", faceCoverage: 1.5), Face(imageName: "face_pumpkin", faceCoverage: 1.5), Face(imageName: "face_rainbow", faceCoverage: 1.2), Face(imageName: "face_skull", faceCoverage: 1.2), Face(imageName: "face_snorlax", faceCoverage: 1.5), Face(imageName: "face_squirtle", faceCoverage: 1.5), Face(imageName: "face_toadGreen", faceCoverage: 1.5), Face(imageName: "face_toadRed", faceCoverage: 1.5), Face(imageName: "face_wolverine", faceCoverage: 1.5)]
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCV()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return facesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let faceCell = collectionView.dequeueReusableCell(withReuseIdentifier: faceCellId, for: indexPath) as! FaceCell
        faceCell.face = facesArray[indexPath.item]
        return faceCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        cameraController?.selectedFace = facesArray[index]
    }
    
    let faceCellId = "FaceCellId"
    
    fileprivate func setupCV() {
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .clear
        self.register(FaceCell.self, forCellWithReuseIdentifier: faceCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
