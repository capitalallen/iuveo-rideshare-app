//
//  DrawerMenuViewController.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-13.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class DrawerMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuTable: UITableView!
    
    var menuCaptions = ["Home", "Membership", "Your Trips", "Payment", "Free Rides", "Help", "Settings", "Legal"]
    var cellArray = [UITableViewCell]()
    var previouslySelectedRow: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userPhoto.layer.cornerRadius = 40.0
        self.userPhoto.clipsToBounds = true
        self.menuTable.delegate = self
        self.menuTable.dataSource = self
        self.menuTable.estimatedRowHeight = 60.0
        self.menuTable.rowHeight = UITableViewAutomaticDimension
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.headerContainer.frame.size
        let startColor = UIColor(red: 227.0/255.0, green: 254.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor
        let endColor = UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        //Use diffrent colors
        //  self.headerContainer.layer.mask = gradientLayer
        self.headerContainer.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuCaptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "captionCell", for: indexPath)
        cell.tag = indexPath.row
        let caption = self.menuCaptions[indexPath.row]
        cellArray.insert(cell, at: indexPath.row)
        if(indexPath.row == 0){
            cell.textLabel?.textColor = UIColor.red
        }
        cell.textLabel?.text = caption
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealController = self.revealViewController()
        let row: Int = indexPath.row
        
        if ( row == previouslySelectedRow ) {
            revealController?.revealToggle(animated: true)
            return
        }
        previouslySelectedRow = row
        
        var frontController: UIViewController? = nil
        if indexPath.row == 0 {
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            frontController = storyB.instantiateViewController(withIdentifier: "homeVCSB")
        } else if indexPath.row == 2 {
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            frontController = storyB.instantiateViewController(withIdentifier: "yourtripsnavi")
        } else if indexPath.row == 3 {
            let storyB = UIStoryboard(name: "Story_shobha", bundle: nil)
            frontController = storyB.instantiateViewController(withIdentifier: "paymentvc")
        } else if indexPath.row == 4 {
            let storyB = UIStoryboard(name: "Story_shobha", bundle: nil)
            frontController = storyB.instantiateViewController(withIdentifier: "ridesharevc")
        } else {
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            frontController = storyB.instantiateViewController(withIdentifier: "homeVCSB")
        }
        revealController?.pushFrontViewController(frontController, animated: true)
        self.cellSelectionChanges(selectedCell: row)
        
    }
    func cellSelectionChanges(selectedCell:Int){
        for cells in cellArray {
            let currentCell = cells as UITableViewCell
            if(currentCell.tag == selectedCell){
              cells.textLabel?.textColor = UIColor.red
            }else{
                cells.textLabel?.textColor = UIColor.black
            }
        }
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
