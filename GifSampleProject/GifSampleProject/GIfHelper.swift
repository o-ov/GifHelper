//
//  GIfHelper.swift
//  GifSampleProject
//
//  Created by Stan Zhang on 2017/2/9.
//  Copyright © 2017年 Stan Zhang. All rights reserved.
//

import Foundation
import UIKit
import ImageIO
import MobileCoreServices


struct GifHelper {
   static func seperateGifIntoImages(fileName:String, saveFiles:Bool) throws -> [UIImage]? {
        if let gifPath = Bundle.main.path(forResource: fileName, ofType: ".gif") {
            do {
                let gifData = try Data(contentsOf: URL(fileURLWithPath: gifPath))
                do {
                    return try seperateGifDataIntoImages(gifData: gifData, saveFiles:saveFiles, fileName: fileName)
                } catch {
                    throw error
                }
            } catch {
                throw error
            }
        } else {
        return nil
        }
    }
    
   static func seperateGifDataIntoImages(gifData:Data, saveFiles:Bool, fileName:String) throws -> [UIImage]? {
        if let gifSourceData = CGImageSourceCreateWithData(gifData as CFData, nil) {
            let gifCounts = CGImageSourceGetCount(gifSourceData)
            var images = [UIImage]()
            for i in 0 ..< gifCounts {
                if let imageRef = CGImageSourceCreateImageAtIndex(gifSourceData, i, nil) {
                    let image = UIImage(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
                    images.append(image)
                    if saveFiles {
                        let imageData = UIImagePNGRepresentation(image)
                        var docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let documentsDirectory = docs[0]
                        let imagePath = documentsDirectory + "/\(fileName)No\(i).png"
                        do {
                            try imageData?.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
                        } catch {
                            throw error
                        }
                    }
                }
            }
            if images.count > 0 {
                return images
            }
        }
        return nil
    }
    
    static func makeGifPic(images: [UIImage], fileName:String) {
        var docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = docs[0]
        let gifPath = documentsDirectory + "/\(fileName).gif"
      
        if let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, CFURLPathStyle.cfurlposixPathStyle, false){
            /*
             public func CGImageDestinationCreateWithURL(_ url: CFURL, _ type: CFString, _ count: Int, _ options: CFDictionary?) -> CGImageDestination?
             CGImageDestinationCreateWithURL方法的作用是创建一个图片的目标对象，图片目标对象可以看做一个集合体。包含图片的URL地址、图片类型、图片帧数、配置参数等。
             参数1传递给这个图片目标对象，参数2描述了图片的类型为GIF图片，参数3表明当前GIF图片构成的帧数，参数4为可选参数暂时给它一个空值。
            */
            let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil)

            let cgimagePropertiesDic = [kCGImagePropertyGIFDelayTime as String : 0.1]//设置GIF图片属性，设置当前GIF中每帧图片展示时间间隔为0.1s
            let cgimageDestinationDic = [kCGImagePropertyGIFDictionary as String : cgimagePropertiesDic] //构建一个GIF图片属性字典，字典使用GIF每帧之间的时间间隔初始化。
            for image in images {//使用遍历的方法将已经准备好的图片快速追加到GIF图片的Destination中
                CGImageDestinationAddImage(destination!, image.cgImage!, cgimageDestinationDic as CFDictionary?)//初始化一个可变字典对象，该字典对象主要用于设置GIF图片中每帧图片属性
            }
            let gifPropertiesDic = NSMutableDictionary()
            gifPropertiesDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)//设置图片彩色空间格式为RGB（Red Green Blue三基色）类型
            gifPropertiesDic.setValue(16, forKey: kCGImagePropertyDepth as String)//设置图片颜色深度。一般来说黑白图像也称为二值图像，颜色深度为1，表示2的一次方，即两种颜色：黑和白。灰度图像一般颜色深度为8，表示2的8次方，共计256种颜色，即从黑色到白色的渐变过程有256种。对于彩色图片来说一般有16位深度和32位深度之说，这里设置为16位深度彩色图片
            gifPropertiesDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String)//设置GIF图片执行的次数
            let gifDictionaryDestDic = [kCGImagePropertyGIFDictionary as String : gifPropertiesDic]
            CGImageDestinationSetProperties(destination!, gifDictionaryDestDic as CFDictionary?)//添加到GIF的Destination目标中
            
            CGImageDestinationFinalize(destination!)//完成GIF的Destination目标文件构建
        }
    }

}
