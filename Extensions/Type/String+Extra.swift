//
//  String+Extra.swift
//  Extensions
//
//  Created by 6 on 27.07.2020.
//  Copyright © 2020 dvcomp. All rights reserved.
//

import Foundation

public extension String {
    
    static func randomText(wordsCount: Int) -> String {
        let words = String.randomTextTemplate.split(separator: " ").shuffled()
        guard words.count > wordsCount else  {
            return words.prefix(words.count - 1).joined(separator: " ")
        }
        return   words.prefix(wordsCount).joined(separator: " ")
    }

    private static let randomTextTemplate = """
            Deltarune is a role-playing video game and a spin-off successor to Undertale, both created by American indie developer Toby Fox.

            The above shows the promotional artwork for Deltarune: Chapter 1, featuring the game’s protagonists: Susie, Kris and Ralsei. Retro Gaming created the font deltarune to imitate the style of the logo. You can access letters with hearts (like the “A” in the logo) by typing their uppercase forms when using the font.

            8-bit Operator by Jayvee Enaguas was used throughout the official website. An updated version of 8-bit Operator under the name “Pixel Operator” can be downloaded here. “Chapter 1” on the artwork above uses 8-bit Operator jve, an old version of 8-bit Operator font.

            If you do not want to download and install the font but just like to create simple text or logos using Deltarune Logo Font, just use the text generator below.
    """


    var isPhoneNumber: Bool {
        let PHONE_REGEX = "^\\+[1-9]{1}[0-9]{3,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: self)
        return result
    }

    func prettyPrintJSONObjectIfPossible() {
        guard let data = self.data(using: .utf8),
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let newData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
            let prettyString = String(data: newData, encoding: .utf8) else {
                return
        }
        print(prettyString)
    }

    func convertToPrettyJsonString() -> String {
        guard let data = self.data(using: .utf8),
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let newData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
            let prettyString = String(data: newData, encoding: .utf8) else {
                return self }
        return prettyString
    }

    var includesWhitespaces: Bool {
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        return range != nil
    }

    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
