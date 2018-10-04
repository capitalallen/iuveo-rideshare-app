//
//  RideShareControllerViewController.swift
//  iuvo
//
//  Created by Shobha V J on 2017-12-29.
//  Copyright © 2017 vpicku. All rights reserved.
//
import MessageUI
import Social
import UIKit

class RideShareController: UIViewController,MFMailComposeViewControllerDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var leftMenu: UIBarButtonItem!
    @IBOutlet weak var rightMenu: UIBarButtonItem!
    @IBOutlet weak var headerView: UIView!
    
    var gradientLayer = CAGradientLayer()
    
   // @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var inviteCode: UITextField!
    
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
        inviteCode.delegate = self
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
        self.rightMenu.action = #selector(RideShareController.toMsgBoxVC)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: Any) {
        //Set the default sharing message.
        let message :String = inviteCode.text!
        let message1 = "I'm giving you a free ride on the iuvo app (up to $25). To accept,use code '\(message)' to sign up. Enjoy! Details :https://www.iuvo.com/invite/\(message)"
        //Set the link to share.
        
            let objectsToShare = [message1] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
