//
//  BrainTreeViewController.swift
//  iuvo
//
//  Created by Shobha V J on 2018-01-03.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class BrainTreeViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    
    let toKinizationKey = "sandbox_7k2tn33h_xtkkphbmmtt55qx5"
    let gradientLayer = CAGradientLayer()
    let iuvoBlueColor = UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1)
    let iuvoGreenColor = UIColor(red: 227/225, green: 254/255, blue: 238/255, alpha: 1)
    
    override func viewDidLoad() {
       print("dgfh")
     super.viewDidLoad()
     gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 120)
     gradientLayer.colors = [iuvoGreenColor.cgColor,iuvoBlueColor.cgColor]
     gradientLayer.locations = [0.0,1.0]
     gradientLayer.startPoint = CGPoint(x: 0, y: 0)
     gradientLayer.endPoint = CGPoint(x: 1.5, y: 0.15)
     self.view.layer.insertSublayer(gradientLayer,at: 0)
     payBtn.layer.cornerRadius = 16
     payBtn.backgroundColor = iuvoBlueColor
        
    }

    @IBAction func pay(_ sender: Any) {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: toKinizationKey, request: request)
        { [unowned self] (controller, result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                
            } else if (result?.isCancelled == true) {
                // print(message: "Transaction Cancelled")
                
            } else if let nonce = result?.paymentMethod?.nonce, let amount = self.amountTextField.text {
                self.sendRequestPaymentToServer(nonce: nonce, amount: amount)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func sendRequestPaymentToServer(nonce: String, amount: String) {
        let paymentURL = URL(string: "http://localhost/donate/pay.php")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            guard let data = data else {
              // print(message: error!.localizedDescription)
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let success = result?["success"] as? Bool, success == true else {
             print("Transaction failed. Please try again.")
                return
            }
            
           print("Successfully charged. Thanks So Much :)")
            }.resume()
    }
    
   
}
