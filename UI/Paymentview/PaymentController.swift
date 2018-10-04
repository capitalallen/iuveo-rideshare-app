//
//  PaymentController.swift
//  iuvo
//
//  Created by Shobha V J on 2017-12-28.
//  Copyright © 2017 vpicku. All rights reserved.
//

import UIKit

class PaymentController: UIViewController {
    
    @IBOutlet weak var leftMenu: UIBarButtonItem!
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    
    @IBOutlet weak var headerView: UIView!
    
    var textLayer = CATextLayer()

    let gradientLayer = CAGradientLayer()
    let iuvoBlueColor = UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1)
    let iuvoGreenColor = UIColor(red: 227/225, green: 254/255, blue: 238/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.alpha = 0.0
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        let startColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        let endColor = UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        if let naviRect = self.navigationController?.navigationBar.bounds {
            
            let naviBackImg = CAGradientLayer.imageLayerForGradientBackground(naviBounds: naviRect, startColor: startColor, endColor: endColor)
            
            self.navigationController?.navigationBar.setBackgroundImage(naviBackImg, for: .default)
        }
/*
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 120)
        gradientLayer.colors = [iuvoGreenColor.cgColor,iuvoBlueColor.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 0.15)
        self.view.layer.insertSublayer(gradientLayer,at: 0)
 */
        if self.revealViewController() != nil {
            self.leftMenu.target = self.revealViewController()
            self.leftMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.rightMenu.target = self
        self.rightMenu.action = #selector(PaymentController.toMsgBoxVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func toMsgBoxVC() {
        let storyB = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyB.instantiateViewController(withIdentifier: "msgboxvcSB") as! MsgBoxViewController
        //  controller.role = "buyer"
        if (self.responds(to: #selector(self.show(_:sender:)))) {
            self.show(controller, sender: self)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}
