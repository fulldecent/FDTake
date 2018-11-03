//
//  UIImageCropper.swift
//  UIImageCropper
//
//  Created by Jari Kalinainen jari@klubitii.com
//
//  Licensed under MIT License 2017
//

import UIKit

@objc public protocol UIImageCropperProtocol: class {
    /// Called when user presses crop button (or when there is unknown situation (one or both images will be nil)).
    /// - parameter originalImage
    ///   Orginal image from camera/gallery
    /// - parameter croppedImage
    ///   Cropped image in cropRatio aspect ratio
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?)
}

public class UIImageCropper: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var presenting = false
    /// Aspect ratio of the cropped image
    public var cropRatio: CGFloat = 1
    /// delegate that implements UIImageCropperProtocol
    public weak var delegate: UIImageCropperProtocol?
  
    /// Crop button text
    public var cropButtonText: String = "Crop"
    /// Retake/Cancel button text
    public var cancelButtonText: String = "Retake"
    
    /// original image from camera or gallery
    public var image: UIImage? {
        didSet {
            guard let image = self.image else {
                return
            }
            layoutDone = false
            ratio = image.size.height / image.size.width
            imageView.image = image
            self.view.layoutIfNeeded()
        }
    }
    /// cropped image
    public var cropImage: UIImage? {
        return crop()
    }

    
    private let topView = UIView()
    private let fadeView = UIView()
    private let imageView: UIImageView = UIImageView()
    private let cropView: UIView = UIView()
    
    private var topConst: NSLayoutConstraint?
    private var leadConst: NSLayoutConstraint?
    
    private var imageHeightConst: NSLayoutConstraint?
    private var imageWidthConst: NSLayoutConstraint?
    
    private var ratio: CGFloat = 1
    private var layoutDone: Bool = false
    
    private var orgHeight: CGFloat = 0
    private var orgWidth: CGFloat = 0
    private var topStart: CGFloat = 0
    private var leadStart: CGFloat = 0
    private var pinchStart: CGPoint = .zero
    
    private let cropButton = UIButton(type: .custom)
    private let cancelButton = UIButton(type: .custom)
    
    //MARK: - inits
    /// initializer
    /// - parameter cropRatio
    /// Aspect ratio of the cropped image
    convenience public init(cropRatio: CGFloat) {
        self.init()
        self.cropRatio = cropRatio
    }
    
    //MARK: - overrides
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        //main views
        topView.backgroundColor = UIColor.clear
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalTopConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": topView])
        let horizontalBottomConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": bottomView])
        let verticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top]-(0)-[bottom(70)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["bottom": bottomView, "top": topView])
        self.view.addConstraints(horizontalTopConst + horizontalBottomConst + verticalConst)
        
        // image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(imageView)
        topConst = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1, constant: 0)
        topConst?.priority = .defaultHigh
        leadConst = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1, constant: 0)
        leadConst?.priority = .defaultHigh
        imageWidthConst = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 1)
        imageWidthConst?.priority = .required
        imageHeightConst = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1)
        imageHeightConst?.priority = .required
        imageView.addConstraints([imageHeightConst!, imageWidthConst!])
        topView.addConstraints([topConst!, leadConst!])
        imageView.image = self.image
        
        // imageView gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        imageView.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.addGestureRecognizer(panGesture)
        imageView.isUserInteractionEnabled = true
        
        //fade overlay
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.isUserInteractionEnabled = false
        fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        topView.addSubview(fadeView)
        let horizontalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": fadeView])
        let verticalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": fadeView])
        topView.addConstraints(horizontalFadeConst + verticalFadeConst)
        
        // crop overlay
        cropView.translatesAutoresizingMaskIntoConstraints = false
        cropView.isUserInteractionEnabled = false
        topView.addSubview(cropView)
        let centerXConst = NSLayoutConstraint(item: cropView, attribute: .centerX, relatedBy: .equal, toItem: topView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConst = NSLayoutConstraint(item: cropView, attribute: .centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConst = NSLayoutConstraint(item: cropView, attribute: .width, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: 0.9, constant: 0)
        widthConst.priority = .defaultHigh
        let heightConst = NSLayoutConstraint(item: cropView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: topView, attribute: .height, multiplier: 0.9, constant: 0)
        let ratioConst = NSLayoutConstraint(item: cropView, attribute: .width, relatedBy: .equal, toItem: cropView, attribute: .height, multiplier: cropRatio, constant: 0)
        cropView.addConstraints([ratioConst])
        topView.addConstraints([widthConst, heightConst, centerXConst, centerYConst])
        cropView.layer.borderWidth = 1
        cropView.layer.borderColor = UIColor.white.cgColor
        cropView.backgroundColor = UIColor.clear
        
        // control buttons
        let cropCenterXMultiplier: CGFloat = 1.0
         /*
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cropCancel), for: .touchUpInside)
        bottomView.addSubview(cancelButton)
        let centerCancelXConst = NSLayoutConstraint(item: cancelButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: 0.5, constant: 0)
        let centerCancelYConst = NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCancelXConst, centerCancelYConst])
        cropCenterXMultiplier = 1.5 */
        
        cropButton.translatesAutoresizingMaskIntoConstraints = false
        cropButton.addTarget(self, action: #selector(cropDone), for: .touchUpInside)
        bottomView.addSubview(cropButton)
        let centerCropXConst = NSLayoutConstraint(item: cropButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: cropCenterXMultiplier, constant: 0)
        let centerCropYConst = NSLayoutConstraint(item: cropButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCropXConst, centerCropYConst])
        
        self.view.bringSubviewToFront(bottomView)
        
        bottomView.layoutIfNeeded()
        topView.layoutIfNeeded()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cancelButton.setTitle(cancelButtonText, for: .normal)
        self.cropButton.setTitle(cropButtonText, for: .normal)
        
        if image == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !layoutDone else {
            return
        }
        layoutDone = true
        
        if ratio < 1 {
            imageWidthConst?.constant = cropView.frame.height / ratio
            imageHeightConst?.constant = cropView.frame.height
        } else {
            imageWidthConst?.constant = cropView.frame.width
            imageHeightConst?.constant = cropView.frame.width * ratio
        }
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(<=\(cropView.frame.origin.x))-[view]-(<=\(cropView.frame.origin.x))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": imageView])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(<=\(cropView.frame.origin.y))-[view]-(<=\(cropView.frame.origin.y))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": imageView])
        topView.addConstraints(horizontal + vertical)
        
        maskFadeView()
        orgWidth = imageWidthConst!.constant
        orgHeight = imageHeightConst!.constant
    }
    
    private func maskFadeView() {
        let path = UIBezierPath(rect: cropView.frame)
        path.append(UIBezierPath(rect: fadeView.frame))
        let mask = CAShapeLayer()
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        mask.path = path.cgPath
        fadeView.layer.mask = mask
    }
    
    //MARK: - button actions
    @objc func cropDone() {
        presenting = false
            self.dismiss(animated: false, completion: {
               
                self.delegate?.didCropImage(originalImage: self.image, croppedImage: self.cropImage)
            })
        
    }
    
    @objc func cropCancel() {
        presenting = false
        self.dismiss(animated: true, completion: nil)
        //self.delegate?.didCancelCrop()
       
    }
    
    //MARK: - gesture handling
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        if pinch.state == .began {
            orgWidth = imageWidthConst!.constant
            orgHeight = imageHeightConst!.constant
            pinchStart = pinch.location(in: self.view)
        }
        let scale = pinch.scale
        let height = max(orgHeight * scale, cropView.frame.height)
        let width = max(orgWidth * scale, cropView.frame.height / ratio)
        imageHeightConst?.constant = height
        imageWidthConst?.constant = width
    }
    
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            topStart = topConst!.constant
            leadStart = leadConst!.constant
        }
        let trans = pan.translation(in: self.view)
        leadConst?.constant = leadStart + trans.x
        topConst?.constant = topStart + trans.y
    }
    
    //MARK: - cropping done here
    private func crop() -> UIImage? {
        guard let image = self.image else {
            return nil
        }
        let imageSize = image.size
        let width = cropView.frame.width / imageView.frame.width
        let height = cropView.frame.height / imageView.frame.height
        let x = (cropView.frame.origin.x - imageView.frame.origin.x) / imageView.frame.width
        let y = (cropView.frame.origin.y - imageView.frame.origin.y) / imageView.frame.height
        
        let cropFrame = CGRect(x: x * imageSize.width, y: y * imageSize.height, width: imageSize.width * width, height: imageSize.height * height)
        if let cropCGImage = image.cgImage?.cropping(to: cropFrame) {
            let cropImage = UIImage(cgImage: cropCGImage, scale: 1, orientation: .up)
            return cropImage
        }
        return nil
    }
    
}

extension UIView {
    func constraintToFill(superView view: UIView?) {
        guard let view = view else {
            assertionFailure("superview is nil")
            return
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
