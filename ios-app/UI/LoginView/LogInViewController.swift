//
//  LogInViewController.swift
//  iuvo
//
//  Created by Shobha V J on 2018-01-11.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LogInViewController: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
   
    @IBOutlet weak var logInBtn: UIButton!
    
    let fbColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    
    @IBOutlet weak var logInFb: UIButton!
    let LoginBackgroundImage = UIImageView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if(UserDefaults.standard.string(forKey: "login_user_name") != nil)
        {
            let email = UserDefaults.standard.string(forKey: "login_user_name")
            userNameTxt.text = email
        }
        LoginBackgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        LoginBackgroundImage.image = UIImage(named: "Maps")
        LoginBackgroundImage.contentMode = .scaleAspectFill
        LoginBackgroundImage.alpha = 0.19
        self.view.addSubview(LoginBackgroundImage)
        self.view.sendSubview(toBack: LoginBackgroundImage)

        userNameTxt.setPlaceHolderColor()
        passwordTxt.setPlaceHolderColor()
        
        logInBtn.layer.cornerRadius = 15;
        logInBtn.layer.borderWidth = 1
        logInBtn.layer.borderColor = fbColor.cgColor
        logInBtn.backgroundColor = fbColor
       
        
        //logInFb.backgroundColor = fbColor
       // logInFb.layer.borderWidth = 1
        logInFb.layer.cornerRadius = 25;
        //logInFb.layer.borderColor = fbColor.cgColor
        logInFb.contentMode = .scaleAspectFill
        
        self.logInBtn.addTarget(self, action: #selector(LogInViewController.toMainPageVC), for: .touchUpInside)
    }
    
    func toMainPageVC() {
        let storyB = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyB.instantiateViewController(withIdentifier: "mainpagevc") as! MainDrawerViewController
        //  controller.role = "buyer"
        self.present(controller, animated: true, completion: nil)
    }

    @IBAction func loginFbBtnPressed(_ sender: Any) {
     
        if (currentReachabilityStatus == .reachableViaWiFi) || (currentReachabilityStatus == .reachableViaWWAN) {
            
            let fbLogInManager : FBSDKLoginManager = FBSDKLoginManager()
            
            fbLogInManager.logIn(withReadPermissions: ["email","public_profile"], from: self, handler: {
                (result, err) in
                if err != nil {
                    print("Fail")
                    return
                }
                
            })
            
            if (FBSDKAccessToken.current() != nil)
            {
                
                let access = String(format:"%@", FBSDKAccessToken.current().tokenString) as String
                print("\(access)")
                
            }
            
            self.getFBUserData()
            
            
            
        } else {
            
            let alertController = UIAlertController(title: "Connectivity Error", message: "No Internet Connetion. Please connect to the Inernet", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func getFBUserData(){
        
        UserDefaults.standard.removeObject(forKey: "login_user_name")
        if ((FBSDKAccessToken.current()) != nil) {
            
            let access = String(format:"%@", FBSDKAccessToken.current().tokenString) as String
            print("\(access)")
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name,last_name,email"]).start{
                (connection, result, error) in
                if error != nil{
                    
                    print("failed to start graph", error!)
                    return
                }
                print("user data: ", result!)
                let data:[String:AnyObject] = result as! [String : AnyObject]
                // let firstName = data["first_name"]
                // let lastName = data["last_name"]
                let fbemail = data["email"]
                let fbfullName = data["name"]
                
                let userString = fbfullName?.replacingOccurrences(of: " ", with: "")
                UserDefaults.standard.set(userString, forKey: "login_user_name_loginpage")
                UserDefaults.standard.set(userString, forKey: "fb_full_name")
                UserDefaults.standard.set(fbemail, forKey: "password_fb")
                
            }
        }
    }
    
}
extension LogInViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == userNameTxt){
            textField.returnKeyType = .next
            textField.isSecureTextEntry = false

        }else{
            textField.returnKeyType = .done
            textField.isSecureTextEntry = true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == passwordTxt){
            textField.resignFirstResponder()
        }else{
            passwordTxt.becomeFirstResponder()
        }
        return true
    }
}
