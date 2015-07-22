//
//  ViewController.swift
//  xxxx
//
//  Created by Leff on 15/2/28.
//  Copyright (c) 2015年 JasonPan. All rights reserved.
//

import UIKit

class happinessViewController: UIViewController,ViewControlerDataSource {

    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
            
        }
    }
    
    private struct Constants{
        static let HappinessGestrueScale:CGFloat = 2.5
    }
    
    @IBAction func adjustmentOfSmile(sender: UIPanGestureRecognizer) {
        switch sender.state{
        case .Ended:fallthrough
        case .Changed:
            let translation = sender.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestrueScale)
            if happinessChange != 0{
                happiness -= happinessChange
                sender.setTranslation(CGPointZero, inView: faceView)
            }
            
        default:break
        }
    }
    
        var happiness:Int = 50 {
            didSet{
                happiness = min(max(happiness, 0), 100)
                println("happiness = \(happiness)")
                updateUI()
    
            }
        }
    
        func smilinessForFaceView(sender: FaceView) -> Double? {
            return Double(happiness-50)/50
        }
    
        private func updateUI(){
            faceView.setNeedsDisplay()
        }

}




