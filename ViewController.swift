import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        homescreenFunctionality();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("playGame", sender: self)
    }
    
    func homescreenFunctionality(){
        let windowBounds = view.bounds.size;
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, windowBounds.width, windowBounds.height)
        gradientLayer.colors = [cgColorForRed(211.0, green: 232.0, blue: 237.0),
                                cgColorForRed(172.0, green: 209.0, blue: 218.0)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.zPosition = 0
        view.layer.addSublayer(gradientLayer)
        
        playButton.layer.zPosition = 1;
        playButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 30)
        playButton.titleLabel?.textColor = UIColor.init(netHex: 0x0288d1)
    }
    
    
    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as AnyObject
    }

}

