//
//  GitHubQRCodeManager.swift
//  HubHub
//
//  Created by jaroshevskii on 20.11.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

/// A manager for generating QR codes representing GitHub profiles.
struct GitHubQRCodeManager {
    /// The shared instance of `GitHub QR code manager`.
    static let shared = GitHubQRCodeManager()
    
    /// Generates a QR code representing the GitHub profile for a given user login.
    ///
    /// - Parameter login: The GitHub login for which to generate the QR code.
    /// - Returns: The generated QR code as a `UIImage`, or `nil` if generation fails.
    ///
    /// This method takes a GitHub user login as input and generates a QR code
    /// that, when scanned, directs to the GitHub profile of the specified user.
    ///
    /// If the generation fails for any reason, such as an invalid login or
    /// network issues, the method returns `nil`.
    func generate(for login: String) -> UIImage? {
        guard let userURL = GitHubConstants.homeURL?.appendingPathComponent(login) else { return nil }

        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(userURL.absoluteString.utf8)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
