//
//  Titleable.swift
//  HubHub
//
//  Created by Saha Jaroshevskii on 14.11.2023.
//

import Foundation

/// A protocol for objects that have a title.
///
/// Conforming types, such as enums or structs, should implement the `title`
/// property to provide a human-readable title for instances of the type.
///
/// The protocol includes a default implementation that generates a title
/// based on the capitalized description of the conforming type:
///
///     enum BookGenre: Titleable {
///         case mystery, romance, scienceFiction
///     }
///
///     let bookGenres: [BookGenre] = [.mystery, .romance, .scienceFiction]
///     let genreTitles = bookGenres.map { $0.title }
///
///     print(genreTitles)
///     // Prints "Mystery, Romance, Science Fiction"
///
protocol Titleable {
    /// The title of the object.
    var title: String { get }
}

// MARK: - Default Implementation
extension Titleable {
    /// Default implementation for the title property, using the description of the object in capitalized form.
    var title: String {
        var result = ""

        for (index, char) in String(describing: self).enumerated() {
            if char.isUppercase {
                result += index == 0 ? String(char) : " \(char)"
            } else {
                result += String(char)
            }
        }

        return result.capitalized.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
