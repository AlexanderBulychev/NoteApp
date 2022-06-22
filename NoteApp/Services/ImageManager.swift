import UIKit
import Kingfisher

class NoteIconImageView: UIImageView {
    func set(from userShareIcon: String?) {
        guard let imageURL = URL(string: userShareIcon ?? "") else { return }
        self.kf.setImage(with: imageURL)
    }
}
