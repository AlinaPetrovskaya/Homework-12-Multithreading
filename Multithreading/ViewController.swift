//
//  ViewController.swift
//  Multithreading
//
//  Created by Виктор Петровский on 06.12.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var leftTopImage: UIImageView!
    @IBOutlet weak var rightTopImage: UIImageView!
    @IBOutlet weak var leftBottomImage: UIImageView!
    @IBOutlet weak var rightBottomImage: UIImageView!
    
    private var imageBrain = ImageBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }
    
  private func setImage() {
        imageBrain.getImage {[weak self] (img1, img2, img3, img4) in
            DispatchQueue.main.async {
                self?.leftTopImage.image = img1 != nil ? UIImage(data: img1!) : self?.leftTopImage.image
                self?.rightTopImage.image = img2 != nil ? UIImage(data: img2!) : self?.rightTopImage.image
                self?.leftBottomImage.image = img3 != nil ? UIImage(data: img3!) : self?.leftBottomImage.image
                self?.rightBottomImage.image = img4 != nil ? UIImage(data: img4!) : self?.rightBottomImage.image
            }
        }
    }
}

