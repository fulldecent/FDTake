//
//  FDTakeControllerLocalizableStrings.swift
//  FDTake
//
//  Created by Yaroslav Zhurakovskiy on 20.11.2019.
//  Copyright © 2019 William Entriken. All rights reserved.
//
import Foundation

/// User interface strings
enum FDTakeControllerLocalizableStrings: String {
    /// Decline to proceed with operation
    case cancel = "cancel"
    
    /// Option to select photo from library
    case chooseFromLibrary = "chooseFromLibrary"
    
    /// Option to select photo from photo roll
    case chooseFromPhotoRoll = "chooseFromPhotoRoll"
    
    /// There are no sources available to select a photo
    case noSources = "noSources"
    
    /// Option to take photo using camera
    case takePhoto = "takePhoto"
    
    /// Option to take video using camera
    case takeVideo = "takeVideo"
    
    /// Option to choose last taken photo or video
    case lastTakenMedia = "lastTakenMedia"

    var defaultLocalizedString: String {
       switch self {
        case .cancel:
            return "🛑"
        case .chooseFromLibrary:
            return "📕"
        case .chooseFromPhotoRoll:
            return "📒"
        case .noSources:
            return "📵"
        case .takePhoto:
            return "📷"
        case .takeVideo:
            return "🎥"
       case .lastTakenMedia:
            return "📷"
        }
    }
    
    var localizedString: String {
        let bundle = Bundle.resources ?? Bundle.main
        return bundle.localizedString(
            forKey: rawValue,
            value: defaultLocalizedString,
            table: nil
        )
    }
    
    func comment() -> String {
        switch self {
        case .cancel:
            return "Decline to proceed with operation"
        case .chooseFromLibrary:
            return "Option to select photo/video from library"
        case .chooseFromPhotoRoll:
            return "Option to select photo from photo roll"
        case .noSources:
            return "There are no sources available to select a photo"
        case .takePhoto:
            return "Option to take photo using camera"
        case .takeVideo:
            return "Option to take video using camera"
        case .lastTakenMedia:
            return "Option to choose last taken video or photo"
        }
    }
}
