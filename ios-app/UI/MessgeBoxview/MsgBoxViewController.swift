//
//  MsgBoxViewController.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-15.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit

class MsgBoxViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    
    var nameCaps = ["Govind", "David", "John"]
    var locCaps = ["Montreal", "Toronto", "New York"]
    var msgCaps = ["Hi", "Going", "Ok"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chats"
        self.tableView.register(UINib(nibName: "MessagBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageBox")
        self.tableView.separatorColor = UIColor.clear
        self.view.backgroundColor = UIColor.white

        // Do any additional setup after loading the view.
        self.tableView.estimatedRowHeight = 70.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MsgBoxViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameCaps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageBox", for: indexPath) as! MessagBoxTableViewCell
        if(indexPath.row == 1){
            cell.profilePic?.image = #imageLiteral(resourceName: "Mark")
        }
        cell.nameLbl.text = nameCaps[indexPath.row]
        cell.placelbl.text = locCaps[indexPath.row]
        cell.chatLbl.text = msgCaps[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyB = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyB.instantiateViewController(withIdentifier: "ChatView") as! ChatViewController
        //  controller.role = "buyer"
        if (self.responds(to: #selector(self.show(_:sender:)))) {
            self.show(controller, sender: self)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
