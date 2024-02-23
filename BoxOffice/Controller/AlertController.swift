//
//  AlertController.swift
//  BoxOffice
//
//  Created by Kim EenSung on 2/21/24.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(with error: Error) {
        let networkError = error as? NetworkError
        let message = networkError != nil ? networkError?.errorDescription : error.localizedDescription
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertViewController.addAction(action)
        self.present(alertViewController, animated: true)
    }
}
