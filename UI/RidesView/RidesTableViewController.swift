//
//  RidesTableViewController.swift
//  iuvo
//
//  Created by Shobha V J on 2018-01-19.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class RidesTableViewController: UITableViewController {

    @IBOutlet var ridesListTableView: UITableView!
 
    @IBOutlet weak var headerView: UIView!
    
    let gradientLayer = CAGradientLayer()
    let iuvoBlueColor = UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1)
    let iuvoGreenColor = UIColor(red: 227/225, green: 254/255, blue: 238/255, alpha: 1)
    let iuvoLightBlueColor = UIColor(red:173/255,green: 216/255, blue :230/255,alpha: 1)
    let iuvoLightGrayColor = UIColor(red:240/255,green: 240/255,blue:240/255,alpha: 1)
    let cellSpacingHeight: CGFloat = 5
    var imageArray :[String] = []
    var nameArray:[String] = []
    var destinationArray:[String] = []
    var priceArray:[String] = []
    var timeArray:[String] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 120)
        gradientLayer.colors = [iuvoGreenColor.cgColor,iuvoBlueColor.cgColor]
        gradientLayer.locations = [0.0,1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 0.15)
        self.headerView.layer.insertSublayer(gradientLayer,at: 0)
        
        //ridesListTableView.translatesAutoresizingMaskIntoConstraints = false
        ridesListTableView.delegate = self
        ridesListTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            ridesListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            ridesListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ridesListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            ridesListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        self.imageArray = ["kijij","carpool","fbicon"]
        self.priceArray = ["$20","$24","$18"]
        self.destinationArray = ["University of Toronto"]
        self.nameArray = ["Allen"]
        self.timeArray = ["14:30 to 15:00"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = iuvoLightGrayColor
        return headerView
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
        
        cell.carpoolImage.image = UIImage(named:imageArray[indexPath.row])
        cell.nameLbl.text = nameArray[0]
        cell.priceLbl.text = priceArray[indexPath.row]
        cell.destinationLbl.text = destinationArray[0]
        cell.timeLbl.text = timeArray[0]
        cell.backgroundColor = UIColor.white
        return cell
    }
   

   override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let requestAction = UIContextualAction(style:.normal, title:  "Request a ride", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        requestAction.image = UIImage(named: "hammer")
        requestAction.backgroundColor = iuvoBlueColor
        
        let chatAction = UIContextualAction(style:.normal, title:  "Start a chat", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("Update action ...")
            success(true)
        })
        chatAction.image = UIImage(named: "hammer")
        chatAction.backgroundColor = iuvoLightBlueColor
        let swipeConfig = UISwipeActionsConfiguration(actions: [requestAction,chatAction])
        return swipeConfig
    
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
