//
//  ViewController.swift
//  FacebookSignInExampleWithParse
//
//  Created by Sergey Kargopolov on 2015-07-27.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
//class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        if (PFUser.currentUser() == nil) {
//            print("not yet logged in")
//            
//            let logInViewController = PFLogInViewController()
//            logInViewController.facebookPermissions = ["public_profile", "email", "user_friends"]
//            
//            
//            //This is new syntax of Swift 2 (Xcode7)
//            logInViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.Facebook]
//            logInViewController.delegate = self
//
//            let signUpViewController = PFSignUpViewController()
//            signUpViewController.delegate = self
//            
//            logInViewController.signUpController = signUpViewController
//            //logInViewController.
//            // arise the Parse login screen.
//            self.presentViewController(logInViewController, animated: true, completion: nil)
//            
//        } else {
//            print("log in as \(PFUser.currentUser())")
//            //discoveryTeachersAroundYou()
//            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
//            
//            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
//            
//            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//            
//            appDelegate.window?.rootViewController = protectedPageNav
//        }
//    }
    
    // Success at log in
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        print("log in as \(PFUser.currentUser())")
        //discoveryTeachersAroundYou()
        let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
        
        let protectedPageNav = UINavigationController(rootViewController: protectedPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = protectedPageNav
    }
    // Failure at log in
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Login failed...")
    }
    
    // Sign up
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        if let _ = info["password"] as? String {
            return true
        } else {
            return false
        }
    }
    // Success at sign up
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Failure at sign up
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Failed to sign up...")
    }


    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
            
            if(error != nil)
            {
              //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
                return
            }
            
            print(user)
            print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
            
            print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
            
            if(FBSDKAccessToken.currentAccessToken() != nil)
            {
               let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProtectedPageViewController") as! ProtectedPageViewController
                
                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = protectedPageNav
                
                
            }
            
            
            
            
        })
        
    }

}

