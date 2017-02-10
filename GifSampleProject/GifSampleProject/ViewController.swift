//
//  ViewController.swift
//  GifSampleProject
//
//  Created by Stan Zhang on 2017/2/7.
//  Copyright © 2017年 Stan Zhang. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices
class ViewController: UIViewController {
    @IBOutlet var GifImageView: UIImageView!

    @IBOutlet var showGif: UIButton!
    @IBOutlet var makeGif: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showGif.addTarget(self, action: #selector(self.showGifPicture), for: .touchUpInside)
        self.makeGif.addTarget(self, action: #selector(self.makeGifPic), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    final func showGifPicture() {
        do {
            let images = try GifHelper.seperateGifIntoImages(fileName: "CartoonCat", saveFiles: false)
                if let _ = images {
                    if images!.count > 0 {
                        self.GifImageView.animationImages = images!
                        self.GifImageView.animationDuration = 1/4
                        self.GifImageView.animationRepeatCount = 0
                        self.GifImageView.startAnimating()
                    }
                }
            } catch  {
            print(error.localizedDescription)
        }
    }
    
    final func makeGifPic() {
        var images = [UIImage]()
        var docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = docs[0]
        for i in 0 ..< 4 {
            let imagePath = documentsDirectory + "/cat\(i).png"
            if let image = UIImage(contentsOfFile: imagePath) {
                images.append(image)
            }
        }
        GifHelper.makeGifPic(images: images, fileName: "myCat")
    }
}

