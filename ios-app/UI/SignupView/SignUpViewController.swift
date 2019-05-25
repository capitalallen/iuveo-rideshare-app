//
//  SignUpViewController.swift
//  iuvo
//
//  Created by Shobha V J on 2018-01-11.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmpasswordTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    var isKeyboardisOpen:Bool = false
    
    @IBOutlet var signUpBg: UIView!
    let LoginBackgroundImage = UIImageView()
    
    let iuvoBlueColor = UIColor(red: 0/255, green: 180/255, blue: 255/255, alpha: 1)
    let fbColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
    let iuvoGreenColor = UIColor(red: 227/225, green: 254/255, blue: 238/255, alpha: 1)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        intialSetup()
        
        //getFBUserData()
//        if(UserDefaults.standard.string(forKey: "login_user_name_loginpage") != nil)
//        {
//            let storyboard = UIStoryboard(name: "Story_shobha", bundle: nil)
//            let  loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
//            self.present(loginVC, animated: true, completion: nil)
//            
//        }
        
    }
    func intialSetup(){
        userNameTxt.delegate = self
        emailTxt.delegate = self
        passwordTxt.delegate = self
        confirmpasswordTxt.delegate = self
        
        userNameTxt.setPlaceHolderColor()
        emailTxt.setPlaceHolderColor()
        passwordTxt.setPlaceHolderColor()
        confirmpasswordTxt.setPlaceHolderColor()
        
        signUpBtn.layer.cornerRadius = 15;
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.borderColor = fbColor.cgColor
        signUpBtn.backgroundColor = fbColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        LoginBackgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        LoginBackgroundImage.image = UIImage(named: "Maps")
        LoginBackgroundImage.contentMode = .scaleAspectFill
        LoginBackgroundImage.alpha = 0.22
        self.view.addSubview(LoginBackgroundImage)
        self.view.sendSubview(toBack: LoginBackgroundImage)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
       
         let whitespace = CharacterSet.whitespaces
        let storyBoard = UIStoryboard(name: "Story_shobha", bundle: nil)
        let logInVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
        self.present(logInVC, animated: true, completion: nil)
     if(isValid(emailTxt.text!)){
             if (userNameTxt.text?.trimmingCharacters(in: whitespace).isEmpty)! || (emailTxt.text?.trimmingCharacters(in: whitespace).isEmpty)! || (passwordTxt.text?.trimmingCharacters(in: whitespace).isEmpty)! || (confirmpasswordTxt.text?.trimmingCharacters(in: whitespace).isEmpty)!{

                       let alert = UIAlertController(title: "Try again!!", message: "Please Enter Valid Details!!", preferredStyle: UIAlertControllerStyle.alert)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                  }else {

                       let str = emailTxt.text
                       let userStr = str?.replacingOccurrences(of: " ", with: "")
                       UserDefaults.standard.set(userStr, forKey: "login_user_name")
                       print(userStr!)
                     let storyBoard = UIStoryboard(name: "Story_shobha", bundle: nil)
                     let logInVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
                     self.present(logInVC, animated: true, completion: nil)
                }
            }else{

           }
}
    
    @IBAction func fbLoginBtnPressed(_ sender: Any) {
        
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
    
    func isValid(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(self.view.frame.origin.y)
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height-125
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print(self.view.frame.origin.y)
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0//keyboardSize.height-200
            }
        }
    }
    
    @IBAction func SignInPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Story_shobha", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as! LogInViewController
        self.present(loginVC,animated: true, completion: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        self.topConstraint.constant = self.view.frame.origin.y + 11
    }
}
extension SignUpViewController:UITextFieldDelegate{
    
    //Keyboard return and next functionality
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == userNameTxt){
              emailTxt.becomeFirstResponder()
        }else if(textField == emailTxt){
              passwordTxt.becomeFirstResponder()
        }else if(textField == passwordTxt){
            confirmpasswordTxt.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    //Funcrion to handle the keyboard typenext and done.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == confirmpasswordTxt){
            textField.returnKeyType = .done
            textField.isSecureTextEntry = true
        }else if(textField == passwordTxt){
            textField.returnKeyType = .next
            textField.isSecureTextEntry = true
        }else{
            textField.returnKeyType = .next
            textField.isSecureTextEntry = false
        }
    }
}

