//
//  UserImage.swift
//  Memoria
//
//  Created by Sagar on 2021-08-07.
//

import SwiftUI

struct UserImage: View {
    @State var image: Image?

    var body: some View {
        if image != nil {
            image?
                .resizable()
                .interpolation(.none)
                .scaledToFill()
                .clipShape(Circle())
        } else {
            Image("profile")
                .resizable()
                .interpolation(.none)
                .scaledToFill()
                .clipShape(Circle())
        }
    }
}

class userImages {
    func loadImage(url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url), let loaded = UIImage(data: data) {
            return loaded
        } else {
            return nil
        }
    }

    func saveImage(_ image: UIImage?) {
        if let data = image?.pngData() {
            // Create URL
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("profile.png")

            do {
                // Write to Disk
                try data.write(to: url)

                // Store URL in User Defaults
                UserDefaults.standard.set(url, forKey: "userPhoto")

            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
}

struct UserImage_Previews: PreviewProvider {
    static var previews: some View {
        UserImage()
    }
}
