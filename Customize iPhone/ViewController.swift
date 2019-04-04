//
//  ViewController.swift
//  Customize iPhone
//
//  Created by 劉玟慶 on 2019/4/3.
//  Copyright © 2019 劉玟慶. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var iPhoneViewGradientBackground: UIView!
    @IBOutlet weak var iPhoneView: UIImageView!
    
    @IBOutlet weak var color1Preview: UIImageView!
    @IBOutlet weak var color1RLabel: UILabel!
    @IBOutlet weak var color1GLabel: UILabel!
    @IBOutlet weak var color1BLabel: UILabel!
    @IBOutlet weak var color1AlphaLabel: UILabel!
    @IBOutlet weak var color1RSlider: UISlider!
    @IBOutlet weak var color1GSlider: UISlider!
    @IBOutlet weak var color1BSlider: UISlider!
    @IBOutlet weak var color1AlphaSlider: UISlider!
    
    @IBOutlet weak var color2Preview: UIImageView!
    @IBOutlet weak var color2RLabel: UILabel!
    @IBOutlet weak var color2GLabel: UILabel!
    @IBOutlet weak var color2BLabel: UILabel!
    @IBOutlet weak var color2AlphaLabel: UILabel!
    @IBOutlet weak var color2RSlider: UISlider!
    @IBOutlet weak var color2GSlider: UISlider!
    @IBOutlet weak var color2BSlider: UISlider!
    @IBOutlet weak var color2AlphaSlider: UISlider!
    
    @IBOutlet weak var gradientDegreeLabel: UILabel!
    @IBOutlet weak var gradientSlider: UISlider!
    
    private var gradientSwitchState = true // switch default is on
    private var color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    private var color2 = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    private var gradientDegree: Float = 0.0
    private var coordinate = CoordinateCalculator()
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iPhoneView.backgroundColor = UIColor(red: CGFloat(color1RSlider.value / 255), green: CGFloat(color1GSlider.value / 255), blue: CGFloat(color1BSlider.value / 255), alpha: CGFloat(color1AlphaSlider.value)) // initialization
    }
    
    @IBAction func changeColor(_ sender: Any)
    {
        color1 = UIColor(red: CGFloat(color1RSlider.value / 255), green: CGFloat(color1GSlider.value / 255), blue: CGFloat(color1BSlider.value / 255), alpha: CGFloat(color1AlphaSlider.value))
        color2 = UIColor(red: CGFloat(color2RSlider.value / 255), green: CGFloat(color2GSlider.value / 255), blue: CGFloat(color2BSlider.value / 255), alpha: CGFloat(color2AlphaSlider.value))
        gradientDegree = gradientSlider.value
        color1Preview.backgroundColor = color1
        color2Preview.backgroundColor = color2
        color1RLabel.text = String(Int(color1RSlider.value))
        color1GLabel.text = String(Int(color1GSlider.value))
        color1BLabel.text = String(Int(color1BSlider.value))
        color1AlphaLabel.text = String(format: "%.2f", color1AlphaSlider.value)
        color2RLabel.text = String(Int(color2RSlider.value))
        color2GLabel.text = String(Int(color2GSlider.value))
        color2BLabel.text = String(Int(color2BSlider.value))
        color2AlphaLabel.text = String(format: "%.2f", color2AlphaSlider.value)
        gradientDegreeLabel.text = String(format: "%.2f", gradientSlider.value)
        if gradientSwitchState
        {
            switchOnAction()
        }
        else
        {
            switchOffAction()
        }
    }
    
    @IBAction func gradientSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            switchOnAction()
            gradientSwitchState = true
        }
        else
        {
            switchOffAction()
            gradientSwitchState = false
        }
    }
    func switchOnAction()
    {
        iPhoneView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        gradientLayer.frame = iPhoneViewGradientBackground.bounds
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        coordinate.setDegree(Degree: gradientDegree)
        gradientLayer.startPoint = CGPoint(x: coordinate.getStartPointX(), y: coordinate.getStartPointY())
        gradientLayer.endPoint = CGPoint(x: coordinate.getEndPointX(), y: coordinate.getEndPointY())
        iPhoneViewGradientBackground.layer.addSublayer(gradientLayer)
        iPhoneViewGradientBackground.bringSubviewToFront(iPhoneView)
    }
    func switchOffAction()
    {
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = iPhoneViewGradientBackground.bounds
        iPhoneView.backgroundColor = color1Preview.backgroundColor
    }
    class CoordinateCalculator
    {
        private var degree: Float
        private var startPointX: Double
        private var startPointY: Double
        private var endPointX: Double
        private var endPointY: Double
        
        init()
        {
            degree = 0.0
            startPointX = 0.0
            startPointY = 0.0
            endPointX = 0.0
            endPointY = 0.0
        }
        
        func setDegree(Degree: Float)
        {
            degree = Degree
            if (Degree >= 0 && Degree <= 45) || (Degree >= 315 && Degree <= 360)
            {
                startPointY = 0
                endPointY = 1
                startPointX = Double(0.5 + 0.5 * tan(Double(degree) * Double.pi / 180.0))
                endPointX = 1 - startPointX
            }
            else if Degree >= 45 && Degree <= 135
            {
                startPointX = 1
                endPointX = 0
                startPointY = Double(0.5 - 0.5 * tan(Double(90.0 - degree) * Double.pi / 180.0))
                endPointY = 1 - startPointY
            }
            else if Degree >= 135 && Degree <= 225
            {
                startPointY = 1
                endPointY = 0
                startPointX = Double(0.5 + 0.5 * tan(Double(180.0 - degree) * Double.pi / 180.0))
                endPointX = 1 - startPointX
            }
            else if Degree >= 225 && Degree <= 315
            {
                startPointX = 0
                endPointX = 1
                startPointY = Double(0.5 + 0.5 * tan(Double(270.0 - degree) * Double.pi / 180.0))
                endPointY = 1 - startPointY
            }
            print("Degree: " + String(degree))
            print("start X: " + String(startPointX))
            print("start Y: " + String(startPointY))
            print("end X: " + String(endPointX))
            print("end Y: " + String(endPointY))
        }
        
        func getStartPointX() -> Double
        {
            return startPointX
        }
        func getStartPointY() -> Double
        {
            return startPointY
        }
        func getEndPointX() -> Double
        {
            return endPointX
        }
        func getEndPointY() -> Double
        {
            return endPointY
        }
        
    }
}

