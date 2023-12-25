//
//  BusinessViewModel.swift
//  NewsApp
//
//  Created by Vitaly on 14.12.2023.
//

import Foundation

protocol BusinessViewModelProtocol {
    var reloadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var reloadCell: ((Int) -> Void)? { get set }
    
    var numberOfCells: Int { get }
    
    func getArticle(for row: Int) -> ArticleCellViewModel
}

final class BusinessViewModel: GeneralViewModelProtocol {
    var reloadData: (() -> Void)?
    var reloadCell: ((Int) -> Void)?
    var showError: ((String) -> Void)?
    
    //MARK: - Properties
    var numberOfCells: Int {
        articles.count
    }
    
    private var articles: [ArticleCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    func getArticle(for row: Int) -> ArticleCellViewModel {
        return articles[row]
    }
    
    init() {
        loadData()
    }
    
    //TODO: Load Data
    private func loadData() {
        ApiManager.getNews(from: .business) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case.success(let articles):
                self.articles = self.convertToCellViewModel(articles)
                self.loadImage()
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showError?(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadImage() {
        for (index, article) in articles.enumerated() {
            ApiManager.getImageData(url: article.imageUrl) { [ weak self ] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.articles[index].imageData = data
                        self?.reloadCell?(index)
                    case .failure(let error):
                        self?.showError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func convertToCellViewModel(_ articles: [ArticleResponceObject]) -> [ArticleCellViewModel] {
        return articles.map { article in
            ArticleCellViewModel(article: article)
        }
    }
    
    private func setupMockObject() {
        articles = [
            ArticleCellViewModel(article: ArticleResponceObject(title: "First Object Title",
                                                                description: "First object description",
                                                                urlToImage: "...",
                                                                date: "23.01.2023"))
        ]
    }
}
