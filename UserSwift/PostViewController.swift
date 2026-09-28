//
//  PostViewController.swift
//  UserSwift
//
//  Created by Виктор on 28.09.2026.
//

import UIKit
import SnapKit

class PostViewController: UIViewController {

    
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        
        Task {
            await loadPost()
        }
    }
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(bodyLabel)
        
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        bodyLabel.font = .systemFont(ofSize: 18, weight: .regular)
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            
        }
        bodyLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
    }
    func loadPost() async  {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200..<300).contains(httpResponse.statusCode) else { return }
            
            let post = try JSONDecoder().decode(Post.self, from: data)
        
            
            await MainActor.run {
                self.titleLabel.text = post.title
                self.bodyLabel.text = post.body
            }
             
        } catch {
            print(error)
        }
    }

    
}
