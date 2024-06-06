//
//  ViewController.swift
//  modul_19.6
//
//  Created by Admin on 23/05/24.
//

import SnapKit
import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var titleString: String = "text hello"
    
    
    lazy var getCatBreedsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("getCatBreedsButton", for: .normal)
        //button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(getCatBreedsButtonTaped), for: .touchUpInside)
        button.layer.cornerRadius = 6
        return button
    }()
    
    
    lazy var deviceRequestModelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("dataInQueryItemsRequest", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dataInQueryItemsRequestTaped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        return button
    }()
    
    
    var resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .systemGray6
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 8.0
        textView.font = .systemFont(ofSize: 14, weight: .medium)
        return textView
    }()
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "тут результат:"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let result: UILabel = {
        let label = UILabel()
        label.text = "result:"
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 34, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let  activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .red
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .systemGreen
        //jsonSwiftBaseApi()
        //dataInHeadersRequest()
        
        setupUI()
        
        
    }
    
    func setupUI() {
        view.addSubview(getCatBreedsButton)
        view.addSubview(deviceRequestModelButton)
        view.addSubview(resultTextView)
        view.addSubview(textLabel)
        view.addSubview(result)
        view.addSubview(activityIndicator)
        
        
        
        getCatBreedsButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
            //make.trailing.equalTo(-40)
            //make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(165)
        }
        
        deviceRequestModelButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(165)
        }
        
        
        resultTextView.snp.makeConstraints{ make in
            make.top.equalTo(getCatBreedsButton.snp.bottom).offset(195)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(200)
        }
        
        textLabel.snp.makeConstraints{ make in
            make.top.equalTo(getCatBreedsButton.snp.bottom).offset(160)
            //make.trailing.equalToSuperview().offset(-90)
            make.leading.equalTo(result.snp.trailing).offset(30)
        }
        
        result.snp.makeConstraints{ make in
            make.top.equalTo(getCatBreedsButton.snp.bottom).offset(150)
            make.leading.equalToSuperview().offset(30)
            //make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(getCatBreedsButton.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
            //make.bottom.equalTo(resultTextView.snp.top).offset(-3)
        }
    }
    
    
    
    
    // Получение данных из запроса с помощью словаря
    // Получение данных из запроса можно реализовать с помощью метода jsonObject(with:options:) класса JSONSerialization, при использовании которого вы получите объект типа Any, а затем с помощью преобразования типов (as?) — в словарь, в котором значение можно получить по ключу.

    @objc func getCatBreedsButtonTaped() {
        
        
        let link = "https://catfact.ninja/breeds"
        getCatBreeds(link: link)
        
        
        struct CatBreedModel {
            // название пароды
            let name: String?
            
            // страна происхождения
            let countryFrom: String?
            
            // длина шерсти
            let coatLength: String?
            
            // окрас
            let coatColor: String?
        }
        
        
        // Пример кода для получения и декодирования данных:
        func getCatBreeds(link: String) {
            let link = "https://catfact.ninja/breeds"
            
            guard let url = URL(string: link) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            activityIndicator.startAnimating()
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
                DispatchQueue.main.async {
                    self.displaySuccess()
                }
                
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                if let data = data, let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                    
                    let jsonDict = jsonObject as? [String: Any]
                    
                    let breeds = jsonDict?["data"] as? [[String: String]]
                    
                    var breedModels: [CatBreedModel] = []
                    
                    breeds?.forEach { bredInfo in
                        let breed = CatBreedModel(
                            name: bredInfo ["breed"],
                            countryFrom: bredInfo ["counrtry"],
                            coatLength: bredInfo ["coat"],
                            coatColor: bredInfo ["pattern"])
                        
                        breedModels.append(breed)
                    }
                    
                    print( "Получено " + breedModels.count.description + " пород")
                    
                    let totalBreedsNumber = jsonDict?["total"] as? Int
                    
                    print("Всего " + (totalBreedsNumber ?? 0).description  + " пород")
                    
                    DispatchQueue.main.async {
                        self.resultTextView.text = ("Получено " + breedModels.count.description + " пород\n" + "Всего " + (totalBreedsNumber ?? 0).description  + " пород")
                        self.resultTextView.font = .systemFont(ofSize: 24, weight: .semibold)

                    }
                    
                }
                
            }
            task.resume()
        }
        
        }
        
    
    
    
 
    // Получение данных из запроса с помощью Decodable
    // Если класс или структура соответствуют протоколу Decodable, их можно использовать в нативных средствах декодирования полученных данных.
    
    @objc func dataInQueryItemsRequestTaped() {
        
        let link = "https://catfact.ninja/breeds"
        getCatBreedsDecodable(link: link)
        
        
        struct CatBreedList: Decodable {
            
            // полученные породы
            let items: [CatBreedModel]?
            
            // страна происхождения
            let totalBreedsNumber: Int?
            
            private enum CodingKeys: String, CodingKey {
                case items = "data"
                case totalBreedsNumber = "total"
            }
            
        }
        
        struct CatBreedModel: Decodable {
                // название породы
                let name: String?
                
                // страна происхождения
                let countryFrom: String?
                
                // длина шерсти
                let coatLength: String?
                
                // Окрас
                let coatColor: String?
                
                private enum CodingKeys : String, CodingKey {
                    case name = "breed"
                    case countryFrom = "country"
                    case coatLength = "coat"
                    case coatColor = "pattern"
                }
        }
        
        func getCatBreedsDecodable(link: String) {
            let link = "https://catfact.ninja/breeds"
            
            guard let url = URL(string: link) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            activityIndicator.startAnimating()
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
                guard error == nil else {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                if let data = data, let model = try? JSONDecoder().decode(CatBreedList.self, from: data) {
                    print("Получено " + (model.items?.count ?? 0).description + " пород")
                    
                    print("Всего " + (model.totalBreedsNumber ?? 0).description + " пород")
                    
                    
                    DispatchQueue.main.async {
                        self.resultTextView.text = ("Получено " + (model.items?.count ?? 0).description + " пород\n" + "Всего " + (model.totalBreedsNumber ?? 0).description  + " пород")
                        self.resultTextView.font = .systemFont(ofSize: 24, weight: .semibold)

                    }
                }
            }
            task.resume()
        }
        
        
        
        
    }
    
    
    private func displaySuccess() {
        textLabel.textColor = .systemGreen
        textLabel.text = "Success: it's OK! "
        textLabel.font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    private func displayFailure() {
        textLabel.textColor = .systemRed
        textLabel.text = "Success: it's not OK!"
        textLabel.font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    
}

