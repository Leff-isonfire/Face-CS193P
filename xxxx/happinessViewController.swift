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




