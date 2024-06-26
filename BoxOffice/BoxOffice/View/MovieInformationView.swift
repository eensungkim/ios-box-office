//
//  MovieInformationView.swift
//  BoxOffice
//
//  Created by Kim EenSung on 3/8/24.
//

import UIKit

final class MovieInformationView: UIView {
    
    private let loadingIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let scrollView: UIScrollView = UIScrollView()
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailInformationStackView: UIStackView = UIStackView(axis: .vertical, distribution: .fill)
    
    private let directorStackView: InformationStackView = InformationStackView(titleText: "감독")
    private let productionYearStackView: InformationStackView = InformationStackView(titleText: "제작년도")
    private let openDateStackView: InformationStackView = InformationStackView(titleText: "개봉일")
    private let showTimeStackView: InformationStackView = InformationStackView(titleText: "상영시간")
    private let auditsStackView: InformationStackView = InformationStackView(titleText: "관람등급")
    private let nationsStackView: InformationStackView = InformationStackView(titleText: "제작국가")
    private let genresStackView: InformationStackView = InformationStackView(titleText: "장르")
    private let actorsStackView: InformationStackView = InformationStackView(titleText: "배우")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        loadingIndicatorView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieInformationView {
    func setData(movieInformationData data: MovieDataProvider.Movie, posterData: Data) {
        directorStackView.contentLabel.text = data.directors
        productionYearStackView.contentLabel.text = data.productionYear
        openDateStackView.contentLabel.text = data.openDate
        showTimeStackView.contentLabel.text = data.showTime
        auditsStackView.contentLabel.text = data.audits
        nationsStackView.contentLabel.text = data.nations
        genresStackView.contentLabel.text = data.genres
        actorsStackView.contentLabel.text = data.actors
        
        setImage(posterData)
    }
    
    private func setImage(_ data: Data) {
        loadingIndicatorView.stopAnimating()
        let image = UIImage(data: data)
        imageView.image = image?.resize(newWidth: bounds.width * 0.9)
    }
}

extension MovieInformationView {
    private func setDetailInformationStackViewSubview() {
        detailInformationStackView.spacing = 7
        
        detailInformationStackView.addArrangedSubview(imageView)
        detailInformationStackView.addArrangedSubview(directorStackView)
        detailInformationStackView.addArrangedSubview(productionYearStackView)
        detailInformationStackView.addArrangedSubview(openDateStackView)
        detailInformationStackView.addArrangedSubview(showTimeStackView)
        detailInformationStackView.addArrangedSubview(auditsStackView)
        detailInformationStackView.addArrangedSubview(nationsStackView)
        detailInformationStackView.addArrangedSubview(genresStackView)
        detailInformationStackView.addArrangedSubview(actorsStackView)
    }
    
    private func setConstraints() {
        self.backgroundColor = .systemBackground
        self.addSubview(scrollView)
        
        scrollView.addSubview(detailInformationStackView)
        
        imageView.addSubview(loadingIndicatorView)
        setDetailInformationStackViewSubview()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        detailInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: 0.5),
            
            detailInformationStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            detailInformationStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            loadingIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: detailInformationStackView.topAnchor),
            scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: detailInformationStackView.bottomAnchor),
        ])
    }
}
