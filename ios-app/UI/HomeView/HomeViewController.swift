//
//  HomeViewController.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-13.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

let noteCenter = NotificationCenter.default

class HomeViewController: UIViewController {
    
    @IBOutlet weak var leftNaviMenu: UIBarButtonItem!
    @IBOutlet weak var rightNaviMenu: UIBarButtonItem!
    
    @IBOutlet weak var searchTap: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var searchTapBottom: NSLayoutConstraint!
    
    @IBOutlet weak var passageCap: UILabel!
    @IBOutlet weak var driverCap: UILabel!
    @IBOutlet weak var plusMinusContainer: UIView!
    @IBOutlet weak var minusImg: UIImageView!
    @IBOutlet weak var plusImg: UIImageView!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    var passOrDriver: Int = 0
    var initNumber: Int = 0
    
    var searchCardShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            self.leftNaviMenu.target = self.revealViewController()
            self.leftNaviMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.searchTap.layer.cornerRadius = 40.0
        self.searchTap.clipsToBounds = true
        self.view.bringSubview(toFront: searchTap)
        
        let searchAction = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.searchTapped(regognizer:)))
        self.searchTap.isUserInteractionEnabled = true
        self.searchTap.addGestureRecognizer(searchAction)
        
        self.scrollView.isHidden = true
        self.scrollViewWidth.constant = 0
        self.containerWidth.constant = 0
        
        let hS = UIScreen.main.bounds.size.height
        self.scrollViewTop.constant = hS - 468.0
        
        self.rightNaviMenu.target = self
        self.rightNaviMenu.action = #selector(HomeViewController.toMsgBoxVC)
        
        setUpV()
        passageDriverToggle(theCode: 0)
        
        let dismissCard = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.disMissSearchCard))
        self.view.addGestureRecognizer(dismissCard)
        dismissCard.cancelsTouchesInView = false
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        self.scrollView.addGestureRecognizer(dismiss)
        dismiss.cancelsTouchesInView = false
        
        noteCenter.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        noteCenter.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let offset = keyboardSize.size.height
                //- (self.tabBarController?.tabBar.frame.size.height)!
                
                let hS = UIScreen.main.bounds.size.height - 428.0 - offset
                if hS > 0.0 {
                    self.animateOnKeyboardEvent(notification: notification, withOffset: offset + 90.0, topD: hS, tapBottom: offset + 5.0)
                } else {
                    self.animateOnKeyboardEvent(notification: notification, withOffset: offset + 90.0, topD: 0.0, tapBottom: offset + 5.0)
                }
            }
        }
        //  self.scrollToCursorForInputView(inputView: self.currentInputView!)
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification){
        let hS = UIScreen.main.bounds.size.height - 468.0
        self.animateOnKeyboardEvent(notification: notification, withOffset: 0.0, topD: hS, tapBottom: 45.0)
    }
    
    fileprivate func animateOnKeyboardEvent(notification: NSNotification, withOffset offset: CGFloat, topD: CGFloat, tapBottom: CGFloat) {
        let userInfo = notification.userInfo!
        let duration: TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Int
        let options: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: UInt(curve << 16) | UIViewAnimationOptions.beginFromCurrentState.rawValue)
        
        self.view.layoutIfNeeded()
        self.scrollViewBottom.constant = offset
        self.scrollViewTop.constant = topD
        self.searchTapBottom.constant = tapBottom
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: { [weak self] in
            //  self.scrollViewBottomDistance.constant = offset
            self?.view.layoutIfNeeded() ?? ()
            // var currentOffset = self.tableView.contentOffset
            // currentOffset.y = currentOffset.y - 100
            // self.tableView.setContentOffset(currentOffset, animated: false)
            }, completion: nil)
    }
    
    @objc fileprivate func dismissKeyboard() {
        //  self.view.endEditing(true)
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func searchTapped(regognizer: UITapGestureRecognizer) {
        
        if self.searchCardShowing {
            self.disMissSearchCard()
            
        } else {
            self.scrollView.isHidden = false
            let widthS = UIScreen.main.bounds.size.width
            
            self.view.layoutIfNeeded()
            
            self.scrollViewWidth.constant = widthS
            self.containerWidth.constant = widthS
            UIView.animate(withDuration: 1.0, animations: { [weak self] in
                self?.view.layoutIfNeeded() ?? ()
                }, completion: nil)
            self.searchCardShowing = true
        }
    }
    
    func disMissSearchCard() {
        
        self.dismissKeyboard()
        
        self.view.layoutIfNeeded()
        
        self.scrollViewWidth.constant = 0.0
        self.containerWidth.constant = 0.0
        UIView.animate(withDuration: 1.0, animations: { [weak self] in
            self?.view.layoutIfNeeded() ?? ()
            }, completion: { [weak self] (finished) in
                self?.scrollView.isHidden = true
        })
        self.searchCardShowing = false
    }
    
    func setUpV() {
        
        self.plusMinusContainer.layer.cornerRadius = 22
        self.plusMinusContainer.layer.borderColor = (UIColor(red: 67.0/255, green: 67.0/255, blue: 67.0/255, alpha: 1.0)).cgColor
        self.plusMinusContainer.layer.borderWidth = 1.0
        self.plusMinusContainer.layer.masksToBounds = true
        
        let minusAction = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.minusTapped(regognizer:)))
        self.minusImg.isUserInteractionEnabled = true
        self.minusImg.addGestureRecognizer(minusAction)
        
        let plusAction = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.plusTapped(regognizer:)))
        self.plusImg.isUserInteractionEnabled = true
        self.plusImg.addGestureRecognizer(plusAction)
        
        let passAction = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.passagerChosen))
        self.passageCap.isUserInteractionEnabled = true
        self.passageCap.addGestureRecognizer(passAction)
        
        let driverAction = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.driverChosen))
        self.driverCap.isUserInteractionEnabled = true
        self.driverCap.addGestureRecognizer(driverAction)
    }
    
    func passagerChosen() {
        passageDriverToggle(theCode: 0)
    }
    
    func driverChosen() {
        passageDriverToggle(theCode: 1)
    }
    
    func minusTapped(regognizer: UITapGestureRecognizer) {
        if initNumber > 0 {
            initNumber = initNumber - 1
            if passOrDriver == 0 {
                self.numberLabel.text = "Passager" + " " + "\(initNumber)"
            } else {
                self.numberLabel.text = "Driver" + " " + "\(initNumber)"
            }
        }
    }
    
    func plusTapped(regognizer: UITapGestureRecognizer) {
        initNumber = initNumber + 1
        if passOrDriver == 0 {
            self.numberLabel.text = "Passager" + " " + "\(initNumber)"
        } else {
            self.numberLabel.text = "Driver" + " " + "\(initNumber)"
        }
    }
    
    func passageDriverToggle(theCode: Int) {
        if theCode == 0 {
            self.passageCap.backgroundColor = UIColor.white
            self.driverCap.backgroundColor = UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1.0)
            passOrDriver = 0
            initNumber = 0
            self.numberLabel.text = "Passager 0"
            self.searchTap.image = UIImage(named: "pen")
        } else {
            self.passageCap.backgroundColor = UIColor(red: 220.0/255, green: 220.0/255, blue: 220.0/255, alpha: 1.0)
            self.driverCap.backgroundColor = UIColor.white
            passOrDriver = 1
            initNumber = 0
            self.numberLabel.text = "Driver 0"
            self.searchTap.image = UIImage(named: "searchicon")
        }
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
