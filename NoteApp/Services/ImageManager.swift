//
//  ImageManager.swift
//  NoteApp
//
//  Created by asbul on 16.06.2022.
//

import UIKit
import Kingfisher

class NoteIconImageView: UIImageView {
    func set(from userShareIcon: String?) {
        guard let imageURL = URL(string: userShareIcon ?? "") else { return }
        self.kf.setImage(with: imageURL)
    }
}
