//
//  BoxOfficeViewController.swift
//  BoxOffice
//
//  Created by kjs on 13/01/23.
//

import UIKit

final class BoxOfficeViewController: UIViewController {
 
    private let boxOfficeView: BoxOfficeView = BoxOfficeView()
    private let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private lazy var dataSource: any LoadDataProtocol = {
        let dataSource = DailyBoxOffice()
        dataSource.delegate = self
        return dataSource
    }()

    override func loadView() {
        view = boxOfficeView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boxOfficeView.delegate = self
        
        loadingIndicatorView.startAnimating()
        
        Task {
            await loadDailyBoxOfficeData()
            boxOfficeView.boxOfficeCollectionView.isScrollEnabled = true
        }
        boxOfficeView.setBoxOfficeCollectionViewProperties(loadingIndicatorView: loadingIndicatorView)
        boxOfficeView.setBoxOfficeCollectionViewDelegate(self)
        boxOfficeView.configureRefreshControl(self)
    }
}

extension BoxOfficeViewController: BoxOfficeCollectionViewDelegate {
    func loadDailyBoxOfficeData() async {
        do {
            try await dataSource.loadData()
        } catch {
            guard let networkError = error as? NetworkError else {
                print(error.localizedDescription)
                return
            }
            self.alert(with: networkError)
        }
        self.loadingIndicatorView.stopAnimating()
    }
}

extension BoxOfficeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = dataSource.loadedData as? [DailyBoxOffice.Movie] else {
            return 0
        }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeCollectionViewCell.className, for: indexPath) as? BoxOfficeCollectionViewCell,
              let movies = dataSource.loadedData as? [DailyBoxOffice.Movie],
              let data = movies[safeIndex: indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = dataSource.loadedData as? [DailyBoxOffice.Movie],
        let movieCode = movies[safeIndex: indexPath.row]?.movieCode else {
            return
        }
        let movieInformationViewController = MovieInformationViewController(movieCode: movieCode)
        present(movieInformationViewController, animated: true)
    }
}

extension BoxOfficeViewController: DataDelegate {
    func reloadView() {
        DispatchQueue.main.async {
            self.boxOfficeView.reloadData()
        }
    }
}
