

import UIKit
import Moscapsule
import RxSwift

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var viewModel: HomeViewModelProtocol!
    
    
    var LEDView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9294, green: 0.9294, blue: 0.9176, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var LEDButton: UIButton = {
        let button = UIButton()
        button.addTarget( self, action: #selector(triggerLED), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icons8-light-on-50"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icons8-light-on-50"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var temperatureView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9294, green: 0.9294, blue: 0.9176, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var celsiusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperature in °C:"
        return label
    }()
    
    var farenheitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperature in °F: "
        return label
    }()
    
    var humidityLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Humidity:  "
        return label
    }()
    
    var temperatureLabelC : UILabel = {
        let label = UILabel()
        label.text = "-.-°C"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var temperatureLabelF : UILabel = {
        let label = UILabel()
        label.text = "-.-°F"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var humidityLabel : UILabel = {
        let label = UILabel()
        label.text = "- %"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureImageView : UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icons8-temperature-50")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()

    var stackViewHorizontal: UIStackView = {
        let view = UIStackView()
        view.axis  = NSLayoutConstraint.Axis.horizontal
        view.distribution  = UIStackView.Distribution.fill
        view.alignment = UIStackView.Alignment.center
        view.spacing   = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackViewVertical: UIStackView = {
        let view = UIStackView()
        view.axis  = NSLayoutConstraint.Axis.vertical
        view.distribution  = UIStackView.Distribution.equalSpacing
        view.alignment = UIStackView.Alignment.center
        view.spacing   = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var fanSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var fanImage: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "icons8-fan-50")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        eventListener()
       setupView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func eventListener() {
        
        self.viewModel.temperatureC
            .asObservable()
            .map { (text) -> String in
                return text
        }
            .bind(to: self.temperatureLabelC.rx.text)
            .disposed(by: disposeBag)
        
        
        self.viewModel.temperatureF
            .asObservable()
            .map { (text) -> String in
                return text
            }
            .bind(to: self.temperatureLabelF.rx.text)
            .disposed(by: disposeBag)
        
        
        self.viewModel.humidity
            .asObservable()
            .map { (text) -> String in
                return text
            }
            .bind(to: self.humidityLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    
    
    func setupView(){
    fanSlider.addTarget(self, action: #selector(self.changeVlaue(_:)), for: .valueChanged)
        self.view.addSubview(stackViewVertical)
        stackViewVertical.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        stackViewVertical.frame = view.bounds
        stackViewVertical.addArrangedSubview(stackViewHorizontal)
        stackViewHorizontal.addArrangedSubview(LEDView)
        LEDView.addSubview(LEDButton)
        LEDView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        LEDView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        LEDButton.centerXAnchor.constraint(equalTo: LEDView.centerXAnchor).isActive = true
        LEDButton.centerYAnchor.constraint(equalTo: LEDView.centerYAnchor).isActive = true
        stackViewHorizontal.addArrangedSubview(temperatureView)
        temperatureView.addSubviews(temperatureImageView, celsiusLabel, farenheitLabel, humidityLbl, temperatureLabelC, temperatureLabelF, humidityLabel)
        temperatureView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        temperatureView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        temperatureImageView.centerYAnchor.constraint(equalTo: temperatureView.centerYAnchor).isActive = true
        temperatureImageView.leadingAnchor.constraint(equalTo: temperatureView.leadingAnchor, constant: 3).isActive = true
        celsiusLabel.topAnchor.constraint(equalTo: temperatureView.topAnchor, constant: 8).isActive = true
        celsiusLabel.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        temperatureLabelC.topAnchor.constraint(equalTo: celsiusLabel.bottomAnchor, constant: 8).isActive = true
        temperatureLabelC.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        farenheitLabel.topAnchor.constraint(equalTo: temperatureLabelC.bottomAnchor, constant: 8).isActive = true
        farenheitLabel.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        temperatureLabelF.topAnchor.constraint(equalTo: farenheitLabel.bottomAnchor, constant: 8).isActive = true
        temperatureLabelF.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        humidityLbl.topAnchor.constraint(equalTo: temperatureLabelF.bottomAnchor, constant: 8).isActive = true
        humidityLbl.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        humidityLabel.topAnchor.constraint(equalTo: humidityLbl.bottomAnchor, constant: 8).isActive = true
        humidityLabel.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: 3).isActive = true
        stackViewVertical.addArrangedSubview(fanImage)
        stackViewVertical.addArrangedSubview(fanSlider)
        fanSlider.widthAnchor.constraint(equalTo: stackViewVertical.widthAnchor, constant: -8).isActive = true

    }
    

    @objc func changeVlaue(_ sender: UISlider) {
        print("value is" , Int(sender.value));
        self.viewModel.triggerFanSpeed(speed: sender.value)
    }
    
    @objc func triggerLED() {
        self.viewModel.triggerLED()
    }

}


