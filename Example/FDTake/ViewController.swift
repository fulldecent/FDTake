//
//  ViewController.swift
//  FDTake
//
//  Created by William Entriken on 12/27/2015.
//  Copyright (c) 2015 William Entriken. All rights reserved.
//

import UIKit
import FDTake

class ViewController: UIViewController {

    var fdTakeController = FDTakeController()
    
    @IBOutlet weak var allowsPhoto: UISwitch!
    @IBOutlet weak var allowsVideo: UISwitch!
    @IBOutlet weak var allowsTake: UISwitch!
    @IBOutlet weak var allowsSelectFromLibrary: UISwitch!
    @IBOutlet weak var allowsEditing: UISwitch!
    @IBOutlet weak var defaultsToFrontCamera: UISwitch!
    @IBOutlet weak var iPadFullScreenCamera: UISwitch!
    
    private func resetFDTakeController () -> Void {
        fdTakeController = FDTakeController()
        fdTakeController.allowsPhoto = allowsPhoto.on
        fdTakeController.allowsVideo = allowsVideo.on
        fdTakeController.allowsTake = allowsTake.on
        fdTakeController.allowsSelectFromLibrary = allowsSelectFromLibrary.on
        fdTakeController.allowsEditing = allowsEditing.on
        fdTakeController.defaultsToFrontCamera = defaultsToFrontCamera.on
        fdTakeController.iPadUsesFullScreenCamera = iPadFullScreenCamera.on
        fdTakeController.didDeny = {
            let alert = UIAlertController(title: "Denied", message: "User did not select a photo/video", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        fdTakeController.didCancel = {
            let alert = UIAlertController(title: "Cancelled", message: "User did cancel while selecting", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        fdTakeController.didFail = {
            let alert = UIAlertController(title: "Failed", message: "User selected but API failed", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        fdTakeController.didGetPhoto = {
            (photo: UIImage, info: [NSObject : AnyObject]) -> Void in
            let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
        fdTakeController.didGetVideo = {
            (video: NSURL, info: [NSObject : AnyObject]) -> Void in
            let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func presentFromButton(sender: UIButton) {
        resetFDTakeController()
        fdTakeController.presentingView = sender
        fdTakeController.present()
    }

    @IBAction func presentFromWindow(sender: UIButton) {
        resetFDTakeController()
        fdTakeController.present()
    }
}

