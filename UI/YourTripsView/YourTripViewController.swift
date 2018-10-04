//
//  YourTripViewController.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-30.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class YourTripViewController: UIViewController {
    
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftBtn: UIBarButtonItem!
    @IBOutlet weak var rightBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Your Trips"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let fontDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = fontDictionary
        let startColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        let endColor = UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
        if let naviRect = self.navigationController?.navigationBar.bounds {
            
            let naviBackImg = CAGradientLayer.imageLayerForGradientBackground(naviBounds: naviRect, startColor: startColor, endColor: endColor)
            
            self.navigationController?.navigationBar.setBackgroundImage(naviBackImg, for: .default)
        }

        self.tableView.register(UINib(nibName: "YourTripTableViewCell", bundle: nil), forCellReuseIdentifier: "Tripcell")
        self.tableView.separatorColor = UIColor.clear
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            self.leftBtn.target = self.revealViewController()
            self.leftBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.rightBtn.target = self
        self.rightBtn.action = #selector(YourTripViewController.toMsgBoxVC)
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
extension YourTripViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tripcell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
