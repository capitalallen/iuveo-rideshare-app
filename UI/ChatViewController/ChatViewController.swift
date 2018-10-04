//
//  ChatViewController.swift
//  iuvo
//
//  Created by boqian cheng on 2018-01-30.
//  Copyright © 2018 vpicku. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices

class ChatViewController: JSQMessagesViewController {
    
    var photoAlbum: UIImagePickerController?
    var camera: UIImagePickerController?
    
    var pickedLargeImg: UIImage?
    var imgData: Data?
    
    var msgsJSQ = [JSQMessage]()
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "David"
        // Do any additional setup after loading the view.
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.senderId = "12345"
        self.senderDisplayName = "Robert"
        
        self.addMessage(withId: "328", name: "11:04 AM", text: "Hello Robert Can we make ride.")
        self.addMessage(withId: "12345", name: "18:30 PM", text: "Hi Mark ,Yes sure ,wher do you wwant to go.")
        self.addMessage(withId: "328", name: "6:18 AM", text: "I wanted to move to downtown")
        self.addMessage(withId: "12345", name: "6:35 AM", text: "I will be there In a 10 minutes.")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        self.keyboardController.endListeningForKeyboard()
        if (self.inputToolbar.contentView.textView.isFirstResponder) {
            self.inputToolbar.contentView.textView.resignFirstResponder()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.keyboardController.beginListeningForKeyboard()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.keyboardController.beginListeningForKeyboard()
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            msgsJSQ.append(message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return msgsJSQ.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return msgsJSQ[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = msgsJSQ[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubble
        } else {
            return incomingBubble
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message = msgsJSQ[indexPath.item]
        if message.senderId == senderId {
            return NSAttributedString(string: msgsJSQ[indexPath.item].senderDisplayName)
        } else {
            return NSAttributedString(string: msgsJSQ[indexPath.item].senderDisplayName)
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return 20.0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = msgsJSQ[indexPath.item]
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        let dateFormatString = "yyyy-MM-dd'-'HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        
        self.addMessage(withId: senderId, name: dateFormatter.string(from: date), text: text)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        choosePhoto()
    }
    
    func choosePhoto() {
        
        typealias Handler = (UIAlertAction?) -> Void
        
        let handlerAlbums: Handler = {action in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)) {
                self.photoAlbum = UIImagePickerController()
                self.photoAlbum!.allowsEditing = true
                self.photoAlbum!.mediaTypes = [kUTTypeImage as String]
                self.photoAlbum!.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.photoAlbum!.delegate = self
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(self.photoAlbum!, animated: true, completion: nil)
                } else {
                    self.photoAlbum!.modalPresentationStyle = UIModalPresentationStyle.popover
                    self.present(self.photoAlbum!, animated: true, completion: nil)
                    
                    let popController = self.photoAlbum!.popoverPresentationController
                    popController!.permittedArrowDirections = UIPopoverArrowDirection.any
                    popController!.sourceView = self.view
                    popController!.sourceRect = CGRect(x: 10, y: 10, width: 10, height: 10)
                    popController!.delegate = self
                    
                }
            }
        }
        
        let handlerCamera: Handler = {action in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                self.camera = UIImagePickerController()
                self.camera!.allowsEditing = true
                self.camera!.mediaTypes = [kUTTypeImage as String]
                self.camera!.sourceType = UIImagePickerControllerSourceType.camera
                self.camera!.delegate = self
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(self.camera!, animated: true, completion: nil)
                } else {
                    self.camera!.modalPresentationStyle = UIModalPresentationStyle.popover
                    self.present(self.camera!, animated: true, completion: nil)
                    
                    let popController = self.camera!.popoverPresentationController
                    popController!.permittedArrowDirections = UIPopoverArrowDirection.any
                    popController!.sourceView = self.view
                    popController!.sourceRect = CGRect(x: 10, y: 10, width: 10, height: 10)
                    popController!.delegate = self
                    
                }
            }
        }
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let albumAct = UIAlertAction(title: "Choose from Album", style: .default, handler: handlerAlbums)
        let cameraAct = UIAlertAction(title: "Take a Photo", style: .default, handler: handlerCamera)
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(albumAct)
        alert.addAction(cameraAct)
        alert.addAction(cancelAct)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            self.present(alert, animated: true, completion: nil)
        } else {
            alert.modalPresentationStyle = UIModalPresentationStyle.popover
            let popPresenter = alert.popoverPresentationController
            popPresenter!.permittedArrowDirections = UIPopoverArrowDirection.any
            popPresenter!.sourceView = self.view
            popPresenter!.sourceRect = self.view.bounds
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func sendPhotoMessage() {
        
        let dateFormatString = "yyyy-MM-dd'-'HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatString
        let now = Date()
        
        let qqqq: JSQPhotoMediaItem = JSQPhotoMediaItem(maskAsOutgoing: true)
        qqqq.image = self.pickedLargeImg
        
        let message = JSQMessage(senderId: self.senderId, displayName: dateFormatter.string(from: now), media: qqqq)
        
        self.msgsJSQ.append(message!)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    fileprivate func presentAlert(aTitle: String?, withMsg: String?, confirmTitle: String?) {
        
        let alert = UIAlertController(title: aTitle, message: withMsg, preferredStyle: .alert)
        let enterPWAct = UIAlertAction(title: confirmTitle, style: .default, handler: nil)
        alert.addAction(enterPWAct)
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            //  self.pickedLargeImg = info[UIImagePickerControllerEditedImage] as! UIImage?
            self.pickedLargeImg = info[UIImagePickerControllerOriginalImage] as? UIImage
            // if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL
            if self.pickedLargeImg != nil {
                self.sendPhotoMessage()
            } else {
                self.presentAlert(aTitle: nil, withMsg: "Error.", confirmTitle: "OK")
            }
        } else if mediaType == (kUTTypeMovie as String) {
            self.presentAlert(aTitle: nil, withMsg: "Not supported.", confirmTitle: "OK")
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            picker.dismiss(animated: true, completion: nil)
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            picker.dismiss(animated: true, completion: nil)
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.title = "Albums"
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        
    }
}


