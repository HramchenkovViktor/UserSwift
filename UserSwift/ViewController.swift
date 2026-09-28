//
//  ViewController.swift
//  UserSwift
//
//  Created by Виктор on 28.09.2026.
//

import UIKit
import SnapKit

struct User: Decodable {
    let name: String
    let age: Int?
}

class ViewController: UIViewController {

    private let nameLabel = UILabel()
    private let ageLabel = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        Task {
            await loadUser()
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(ageLabel)
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.layer.cornerRadius = 10
        nameLabel.textColor = .black
        
        ageLabel.font = .systemFont(ofSize: 20, weight: .bold)
        ageLabel.numberOfLines = 0
        ageLabel.textAlignment = .center
        ageLabel.layer.cornerRadius = 10
        ageLabel.textColor = .black
        
    }
    
    func setupConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
    }

    func loadUser() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/1") else { return }
        
        do {
            let (data, response ) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard (200..<300).contains(httpResponse.statusCode) else { return }
            
            let user = try JSONDecoder().decode(User.self, from: data)
            print(user)
            
            await MainActor.run {
                self.nameLabel.text = user.name
                if let age = user.age {
                    self.ageLabel.text = "Возраст: \(age)"
                } else {
                    self.ageLabel.text = "Возраст неизвестен"
                }
            }
            
        } catch {
            print(error)
        }
        
    }


}

