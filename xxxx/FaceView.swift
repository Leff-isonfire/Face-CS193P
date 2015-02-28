//
//  FaceView.swift
//  TryThingsOut
//
//  Created by Leff on 15/2/25.
//  Copyright (c) 2015年 JasonPan. All rights reserved.
//

import UIKit

protocol ViewControlerDataSource:class{
    func smilinessForFaceView(sender:FaceView) -> Double?
}

class FaceView: UIView {
    
    let scale:CGFloat = 0.9
    var lineWidth: CGFloat = 3 {didSet{setNeedsDisplay()}}
    //    var color:UIColor = UIColor.blueColor(){didSet{setNeedsDisplay()}}

    var faceCenter:CGPoint{
        return convertPoint(center, fromView:superview)
    }
    
    var faceRadius:CGFloat{
        return min(bounds.size.width, bounds.size.width)/2*scale
    }
    
    private struct Scaling {
        static let eyeRadiusFromFaceRadius:CGFloat = 1/6
        static let eyeHorizonalOffsetCoefficient:CGFloat = 1/3
        static let eyeVerticalOffsetCoeffcient:CGFloat = 1/3
        static let mouthVerticalOffsetCoeffcient:CGFloat = 1/2
        
    }
    
    weak var dataSource:ViewControlerDataSource?
    
    enum eye{case left,right}
    
    private func bezierPathForEye(sideOfEye:eye) -> UIBezierPath{
        let eyeRadius = faceRadius * Scaling.eyeRadiusFromFaceRadius
        let eyeHorizonalOffset = faceRadius * Scaling.eyeHorizonalOffsetCoefficient
        let eyeVerticalOffset = faceCenter.y - faceRadius * Scaling.eyeVerticalOffsetCoeffcient
        
        var eyeCenter = faceCenter
        
        eyeCenter.y = eyeVerticalOffset
        
        switch sideOfEye{
        case .left:
            eyeCenter.x -= eyeHorizonalOffset
        case .right:
            eyeCenter.x += eyeHorizonalOffset
        }
        
        
        return UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
    }
    
    
    private func bezierPathForSmile(fractionOfSmile:Double) -> UIBezierPath{
        let centerOfMouth = faceCenter.y - faceRadius * Scaling.mouthVerticalOffsetCoeffcient
        let startPoint:CGPoint = CGPoint(
            x:faceCenter.x - faceRadius / 2
            ,y:faceCenter.y + faceRadius * Scaling.mouthVerticalOffsetCoeffcient
        )
        let endPoint:CGPoint = CGPoint(
            x:faceCenter.x + faceRadius / 2
            ,y:faceCenter.y + faceRadius * Scaling.mouthVerticalOffsetCoeffcient
        )
        
        var happinessValue = CGFloat(min(max(-1, fractionOfSmile),1))
            * faceRadius/2 //This line it's the coeffcient determine how cruve the smile is.
        
        let cp1:CGPoint = CGPoint(x: startPoint.x, y: startPoint.y + happinessValue)
        let cp2:CGPoint = CGPoint(x: endPoint.x, y: startPoint.y + happinessValue)

        
        var smile = UIBezierPath()
        smile.moveToPoint(startPoint)
        smile.addCurveToPoint(endPoint, controlPoint1: cp1, controlPoint2: cp2)
        smile.lineWidth = lineWidth
        
        
        return smile
    }
    
    private func setEyeFillAndStroke(EYE:UIBezierPath){
        EYE.fill()
        EYE.stroke()
    }
    

   
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        let smilinessValue:Double =
        dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smilinessValue)
        
        //try to draw a line represent smile from here.
        
//        let drawALine = UIBezierPath()
//        var startPoint:CGPoint = CGPoint(
//            x:faceCenter.x - faceRadius / 2
//            ,y:faceCenter.y + faceRadius * Scaling.mouthVerticalOffsetCoeffcient
//        )
//        var endPoint:CGPoint = CGPoint(
//            x:faceCenter.x + faceRadius / 2
//            ,y:faceCenter.y + faceRadius * Scaling.mouthVerticalOffsetCoeffcient
//        )
//        drawALine.moveToPoint(startPoint)
//        drawALine.addLineToPoint(endPoint)
//        drawALine.stroke()
//        
        //end drawing

        UIColor.blueColor().setStroke()

        facePath.stroke()
        smilePath.stroke()
        
        let transparentBlue:Void = UIColor.blueColor().colorWithAlphaComponent(0.5).setStroke()
        let setFill:Void = UIColor.blueColor().colorWithAlphaComponent(0.5).setFill()
        
        setEyeFillAndStroke(bezierPathForEye(.left))
        setEyeFillAndStroke(bezierPathForEye(.right))

//        bezierPathForEye(.left).stroke()
//        bezierPathForEye(.left).fill()
//        bezierPathForEye(.right).stroke()
        
    }

}