//
//  Meme Model.swift
//  MemeMe
//
//  Created by Hank Wang on 2018/5/3.
//  Copyright © 2018 hanksudo. All rights reserved.
//
import UIKit

struct Meme:Codable {
    var topText: String
    var bottomText: String
    var filename: String
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

extension Meme {
    init(image: UIImage, topText: String, bottomText: String) {
        let filename = String(Date().timeIntervalSince1970)
        self.init(topText: topText, bottomText: bottomText, filename: filename)
        saveImage(image: image, filename: filename)

        save()
    }
    
    func remove() {
        if let index = appDelegate.memes.index(where: {$0.filename == self.filename}) {
            appDelegate.memes.remove(at: index)
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(appDelegate.memes), forKey:"memes")
    }
    
    private func save() {
        appDelegate.memes.insert(self, at: 0)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(appDelegate.memes), forKey:"memes")
    }
    
    private func saveImage(image: UIImage, filename: String) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileURL = documentDirectory.appendingPathComponent(filename)
        
        if let data = UIImageJPEGRepresentation(image, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved", fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func loadImage() -> UIImage! {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentDirectory.appendingPathComponent(filename)
        
        return UIImage(contentsOfFile: imageURL.path)
    }
}
