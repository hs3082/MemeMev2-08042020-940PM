//
//  ViewController.swift
//  MemeMe v1
//
//  Created by Howard Snyder on 7/5/20.
//  Copyright © 2020 Howard Snyder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    
    var memes = [Meme]()
    
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTextField(tf: TopTextField, text: "Top")
        setupTextField(tf: BottomTextField, text: "Bottom")
        
        }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = memeTextAttributes
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        //is not running on simulator
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        
        shareButton.isEnabled = false
        
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    @IBAction func pickAnImage(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
        
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func discardMeme(_ sender: Any) {
        shareButton.isEnabled = false
        ImagePickerView.image = nil
        TopTextField.text = "TOP"
        BottomTextField.text = "BOTTOM"
        resetState()
    }
    
    func resetState(){
        ImagePickerView.image = nil
        TopTextField.text = "TOP"
        BottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Erase the default text when editing
        if textField == TopTextField && textField.text == "TOP" {
            textField.text = ""
            
        } else if textField == BottomTextField && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print("pic selected")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
        ImagePickerView.image = image
    
    picker.dismiss(animated: true, completion: nil)
        }
        //Enable Share Button
        shareButton.isEnabled = true
        //Dismiss
        dismiss(animated: true, completion: nil)
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),name: UIResponder.keyboardWillHideNotification,object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if BottomTextField.isEditing, view.frame.origin.y == 0{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    

    @objc func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder() //will return true
    }
    
    
    
    func generateMemedImage() -> UIImage {
        hideControls()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        return memedImage
    }
    
    
    func save() {
        //_ = Meme(
        var meme = Meme(
            topText:self.TopTextField.text!,
            bottomText: self.BottomTextField.text!,
            originalImage: self.ImagePickerView.image!,
            memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate -- Added as part of lesson 8 section 5
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func hideControls() {
        for view in self.view.subviews as [UIView] {
            if let button = view as? UIButton {
                button.isHidden = true
            }
        }
    }
    
    func showControls() {
        for view in self.view.subviews as [UIView] {
            if let button = view as? UIButton {
                button.isHidden = false
            }
        }
    }
    
    
    @IBAction func Share(_ sender: Any) {
        let sharedImage = generateMemedImage()
        // generate the meme
        let activityController = UIActivityViewController(activityItems: [sharedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { (activity, success, items, error) in
                self.save()
        //Added per Francisco G
            if success {
                self.save()
            }
        }
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
        
    }
    
}


