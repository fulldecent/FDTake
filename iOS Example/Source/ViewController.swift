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
    
    @IBOutlet weak var languageLabel: UILabel!
    var fdTakeController = FDTakeController()
    
    @IBOutlet weak var allowsPhoto: UISwitch!
    @IBOutlet weak var allowsVideo: UISwitch!
    @IBOutlet weak var allowsTake: UISwitch!
    @IBOutlet weak var allowsSelectFromLibrary: UISwitch!
    @IBOutlet weak var allowsEditing: UISwitch!
    @IBOutlet weak var defaultsToFrontCamera: UISwitch!
    @IBOutlet weak var iPadFullScreenCamera: UISwitch!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.languageLabel.text = NSLocale.preferredLanguages.first!
    }
    
    private func resetFDTakeController () -> Void {
        fdTakeController = FDTakeController()
        fdTakeController.allowsPhoto = allowsPhoto.isOn
        fdTakeController.allowsVideo = allowsVideo.isOn
        fdTakeController.allowsTake = allowsTake.isOn
        fdTakeController.allowsSelectFromLibrary = allowsSelectFromLibrary.isOn
        fdTakeController.allowsEditing = allowsEditing.isOn
        fdTakeController.defaultsToFrontCamera = defaultsToFrontCamera.isOn
        fdTakeController.iPadUsesFullScreenCamera = iPadFullScreenCamera.isOn
        fdTakeController.didDeny = {
            let alert = UIAlertController(title: "Denied", message: "User did not select a photo/video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        fdTakeController.didCancel = {
            let alert = UIAlertController(title: "Cancelled", message: "User did cancel while selecting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        fdTakeController.didFail = {
            let alert = UIAlertController(title: "Failed", message: "User selected but API failed", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        fdTakeController.didGetPhoto = {
            (photo: UIImage, info: [AnyHashable : Any]) -> Void in
            let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        fdTakeController.didGetVideo = {
            (video: URL, info: [AnyHashable : Any]) in
            let alert = UIAlertController(title: "Got photo", message: "User selected photo", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // http://stackoverflow.com/a/34487871/300224
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func presentFromButton(_ sender: UIButton) {
        resetFDTakeController()
        fdTakeController.presentingView = sender
        fdTakeController.present()
    }
    
    @IBAction func presentFromWindow() {
        resetFDTakeController()
        fdTakeController.presentingView = self.view
        fdTakeController.present()
    }
}

