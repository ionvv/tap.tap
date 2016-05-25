import UIKit

var displayTimeLabel = UILabel();
var startTime = NSTimeInterval();
var timer = NSTimer();
var userLevel: Int = 1;
var bestScore: NSTimeInterval = 0.0;
var currentElapsedTime: NSTimeInterval = 0.0;
var bannerView: GADBannerView! = GADBannerView();

var cbX:CGFloat = 0;
var cbWidth:CGFloat = 0;
var level1Unlocked: Bool = true;
var level2Unlocked: Bool = false;
var level3Unlocked: Bool = false;
var level4Unlocked: Bool = false;
var level5Unlocked: Bool = false;
var level1TimeToUnlock: NSTimeInterval = 60.0;
var level2TimeToUnlock: NSTimeInterval = 120.0;
var level3TimeToUnlock: NSTimeInterval = 180.0;
var level4TimeToUnlock: NSTimeInterval = 240.0;
var level5TimeToUnlock: NSTimeInterval = 320.0;
var currentTimeToUnlockLevel: NSTimeInterval = 60.0;
var nextLevelUnlocked: Bool = false;

var colorBar = UIView();
var blueBar = UIView();
var bestScoreLabel = UILabel();

var windowBounds: CGSize!;

class GameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var leftButton = UIView();
    var rightButton = UIView();
    
    var backButton = UIButton();
    var resetButton = UIButton();
    var bestScoreTitle = UILabel();
    
    var tapMeLeft = UILabel();
    var tapMeRight = UILabel();
    
    let buttonsHeight: CGFloat = 104;
    let buttonsWidth: CGFloat = 90;
    
    var gameOver: Bool = false;

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createGameElements();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGameElements(){
        view.backgroundColor = UIColor.init(netHex: 0xd8f0fc)
        windowBounds = self.view.bounds.size;
        cbWidth = windowBounds.width;
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, windowBounds.width, 4)
        gradientLayer.colors = [cgColorForRed(238.0, green: 239.0, blue: 214.0),
                                cgColorForRed(202.0, green: 216.0, blue: 225.0),
                                cgColorForRed(211.0, green: 232.0, blue: 237.0),
                                cgColorForRed(172.0, green: 209.0, blue: 218.0),
                                cgColorForRed(119.0, green: 161.0, blue: 199.0),
                                cgColorForRed(61.0, green: 94.0, blue: 139.0),
                                cgColorForRed(58.0, green: 123.0, blue: 151.0)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradientLayer)
        
        // reset button
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(UIColor.init(netHex: 0x002f49), forState: .Normal)
        backButton.titleLabel!.font = UIFont(name: "Avenir-Light", size: 18)
        backButton.frame = CGRectMake(20, 20, 75, 20)
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        backButton.addTarget(self, action: #selector(GameViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        // reset button
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.setTitleColor(UIColor.init(netHex: 0x002f49), forState: .Normal)
        resetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        resetButton.frame = CGRectMake(windowBounds.width-95, 20, 75, 20)
        resetButton.titleLabel!.textAlignment = .Right;
        resetButton.addTarget(self, action: #selector(GameViewController.resetButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton)
        
        bestScoreTitle.frame = CGRectMake(windowBounds.width/2-80, windowBounds.height-160, 160, 25)
        bestScoreTitle.font = UIFont(name: "Avenir", size: 20)
        bestScoreTitle.textAlignment = .Center
        bestScoreTitle.text = "Best score:";
        self.view.addSubview(bestScoreTitle)
        bestScoreLabel.frame = CGRectMake(windowBounds.width/2-80, windowBounds.height-130, 160, 25)
        bestScoreLabel.font = UIFont(name: "Avenir", size: 20)
        bestScoreLabel.textAlignment = .Center
        self.view.addSubview(bestScoreLabel)
        userDB().getBestScore()
        displayBestScore()
        
        // full width bar
        switch userLevel {
        case 1:
            cbX = 0;
            cbWidth = windowBounds.width;
            currentTimeToUnlockLevel = level1TimeToUnlock;
        case 2:
            cbX = (windowBounds.width*0.25)/2;
            cbWidth = windowBounds.width*0.75;
            currentTimeToUnlockLevel = level2TimeToUnlock;
        case 3:
            cbX = windowBounds.width*0.50/2;
            cbWidth = windowBounds.width*0.50;
            currentTimeToUnlockLevel = level3TimeToUnlock;
        case 4:
            cbX = windowBounds.width*0.70/2;
            cbWidth = windowBounds.width*0.30;
            currentTimeToUnlockLevel = level4TimeToUnlock;
        case 5:
            cbX = windowBounds.width*0.80/2;
            cbWidth = windowBounds.width*0.20;
            currentTimeToUnlockLevel = level5TimeToUnlock;
        default:
            break;
        }
        
        colorBar.frame = CGRect(x: cbX, y: windowBounds.height/5, width: cbWidth, height: windowBounds.height/4)
        colorBar.backgroundColor = UIColor.init(netHex: 0x3fb0c2);
        colorBar.layer.zPosition = 3;
        
        // blue bar
        blueBar.frame = CGRect(x: cbWidth/2, y: 0, width: cbWidth/2, height: windowBounds.height/4)
        blueBar.backgroundColor = UIColor.init(netHex: 0x0288d1);
        
        // add elements to view
        colorBar.addSubview(blueBar)
        self.view.addSubview(colorBar)
        
        // buttons
        leftButton.frame = CGRect(x: 25, y: windowBounds.height-buttonsHeight-50, width: buttonsWidth, height: buttonsHeight)
        leftButton.backgroundColor = UIColor.init(netHex: 0x3fb0c2);
        leftButton.layer.cornerRadius = 45;
        leftButton.transform = CGAffineTransformMakeRotation(CGFloat(55*M_PI/180))
        let tapNo = UITapGestureRecognizer(target: self, action: #selector(GameViewController.noTapped(_:)))
        tapNo.delegate = self
        leftButton.addGestureRecognizer(tapNo)
        rightButton.frame = CGRect(x: windowBounds.width-buttonsWidth-25, y: windowBounds.height-buttonsHeight-50, width: buttonsWidth, height: buttonsHeight)
        rightButton.backgroundColor = UIColor.init(netHex: 0x0288d1);
        rightButton.layer.cornerRadius = 45;
        rightButton.transform = CGAffineTransformMakeRotation(-CGFloat(55*M_PI/180))
        let tapYes = UITapGestureRecognizer(target: self, action: #selector(GameViewController.yesTapped(_:)))
        tapYes.delegate = self
        rightButton.addGestureRecognizer(tapYes)
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
        tapMeLeft.text = "Tap Me";
        tapMeLeft.font = UIFont(name: "Avenir-Light", size: 18)
        tapMeLeft.textColor = UIColor.whiteColor()
        tapMeLeft.frame = CGRectMake(-22, leftButton.frame.size.height/2-24, leftButton.frame.size.width, 20)
        tapMeLeft.textAlignment = .Center
        tapMeLeft.transform = CGAffineTransformMakeRotation(-CGFloat(55*M_PI/180))
        leftButton.addSubview(tapMeLeft)
        tapMeRight.text = "Tap Me";
        tapMeRight.font = UIFont(name: "Avenir-Light", size: 18)
        tapMeRight.textColor = UIColor.whiteColor()
        tapMeRight.frame = CGRectMake(-22, leftButton.frame.size.height/2-24, leftButton.frame.size.width, 20)
        tapMeRight.textAlignment = .Center
        tapMeRight.transform = CGAffineTransformMakeRotation(CGFloat(55*M_PI/180))
        rightButton.addSubview(tapMeRight)
        
        // add timer label
        displayTimeLabel.text = "00:00:00"
        displayTimeLabel.frame = CGRectMake(windowBounds.width/2-50, 20, 100, 20)
        displayTimeLabel.font = UIFont(name: "Avenir-Light", size: 18)
        displayTimeLabel.textColor = UIColor.init(netHex: 0x002f49)
        displayTimeLabel.textAlignment = .Center
        self.view.addSubview(displayTimeLabel)
        
    }
    
    func noTapped(sender: UITapGestureRecognizer! = nil){
        stopBarAnimations()
        setPercentageInBar(0,votesTotal: 1)
        tapMeRight.text = "";
        tapMeLeft.text = "";
    }
    
    func yesTapped(sender: UITapGestureRecognizer! = nil){
        stopBarAnimations()
        setPercentageInBar(1,votesTotal: 1)
        tapMeRight.text = "";
        tapMeLeft.text = "";
        
    }
    
    func stopBarAnimations(){
        let layer = blueBar.layer.presentationLayer() as! CALayer
        let frame = layer.frame
        blueBar.layer.removeAllAnimations()
        blueBar.frame = frame
    }
    
    func setPercentageInBar(votesPro: Float, votesTotal: Float){
        if (self.gameOver == false) {
            gameTimer().startTimer()
            let screenWidth = cbWidth;
            var percent:CGFloat = 0.5;
            if (votesTotal > 0) {
                percent = CGFloat(votesPro/votesTotal);
            }
            
            if (currentElapsedTime > currentTimeToUnlockLevel && currentElapsedTime < currentTimeToUnlockLevel+1.0 && !nextLevelUnlocked) {
                print("best score")
                nextLevelUnlocked = true;
                userDB().markNextLevelAsUnlocked();
            } else if (currentElapsedTime < currentTimeToUnlockLevel && nextLevelUnlocked) {
                print("reset level")
                nextLevelUnlocked = false;
            }
            
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
                blueBar.frame = CGRectMake(screenWidth-screenWidth*percent, 0, screenWidth*percent, blueBar.frame.size.height);
                }, completion: { (finished: Bool) -> Void in
                    if (finished) {
                        self.gameOver = true;
                        gameTimer().stopTimer();
                        
                        // function to check for best result goes next
                        if (currentElapsedTime > bestScore) {
                            userDB().setBestScore(Double(currentElapsedTime))
                            bestScore = currentElapsedTime;
                            self.displayBestScore();
                        }
                    }
            })
        }
        
    }
    
    func resetButtonPressed(sender: UITapGestureRecognizer! = nil){
        userDB().setLevel(1);
        userLevel = 1;
        level2Unlocked = false;
        level3Unlocked = false;
        level4Unlocked = false;
        level5Unlocked = false;
        cbWidth = windowBounds.width
        currentTimeToUnlockLevel = level1TimeToUnlock;
        nextLevelUnlocked = false;
        
        let screenWidth = cbWidth;
        let percent:CGFloat = 0.5;
        UIView.animateWithDuration(0.15, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            colorBar.frame = CGRect(x: 0, y: windowBounds.height/5, width: cbWidth, height: windowBounds.height/4)
            blueBar.frame = CGRectMake(screenWidth/2, 0, screenWidth*percent, blueBar.frame.size.height);
            }, completion: { (finished: Bool) -> Void in
                self.gameOver = false;
                self.tapMeRight.text = "Tap Me";
                self.tapMeLeft.text = "Tap Me";
        })
    }
    
    func backButtonPressed(sender: UITapGestureRecognizer! = nil){
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    func displayBestScore(){
        var elapsedTime = bestScore;
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        bestScoreLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)";
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func cgColorForRed(red: CGFloat, green: CGFloat, blue: CGFloat) -> AnyObject {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0).CGColor as AnyObject
    }

}


class gameTimer: NSObject{
    
    func startTimer(){
        if !timer.valid {
//            let aSelector : Selector = Selector("updateTime")
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(gameTimer.updateTime),     userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        currentElapsedTime = elapsedTime;
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        if (currentElapsedTime > bestScore) {
            bestScoreLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)";
        }
        
    }
}

class userDB{
    let defaults = NSUserDefaults.standardUserDefaults();
    
    func getCurrentLevel() {
        let uLevel = defaults.integerForKey("userLevel") as? Int;
        if (uLevel > 0) {
            userLevel = uLevel!;
        }
    }
    
    func setLevel(level: Int){
        defaults.setInteger(level, forKey: "userLevel");
        defaults.synchronize();
    }
    
    func getBestScore(){
        let bScore = defaults.doubleForKey("\(userLevel)bestScore") as? Double;
        if (bScore > 0) {
            bestScore = bScore!;
        }
    }
    func setBestScore(interval: Double){
        defaults.setDouble(interval, forKey: "\(userLevel)bestScore");
        defaults.synchronize();
    }
    
    func markNextLevelAsUnlocked(){
        let nextLevel = userLevel+1;
        setLevel(nextLevel);
        userLevel = nextLevel;
        changeLevel(nextLevel);
    }
    
    func changeLevel(levelToDispay: Int){
        switch levelToDispay {
        case 2:
            level2Unlocked = true;
            currentTimeToUnlockLevel = level2TimeToUnlock;
            cbX = (windowBounds.width*0.25)/2;
            cbWidth = windowBounds.width*0.75;
        case 3:
            level3Unlocked = true;
            currentTimeToUnlockLevel = level3TimeToUnlock;
            cbX = windowBounds.width*0.50/2;
            cbWidth = windowBounds.width*0.50;
        case 4:
            level4Unlocked = true;
            currentTimeToUnlockLevel = level4TimeToUnlock;
            cbX = windowBounds.width*0.70/2;
            cbWidth = windowBounds.width*0.30;
        case 5:
            level5Unlocked = true;
            currentTimeToUnlockLevel = level5TimeToUnlock;
            cbX = windowBounds.width*0.80/2;
            cbWidth = windowBounds.width*0.20;
        default:
            break;
        }
        blueBar.frame = CGRect(x: cbWidth/2, y: 0, width: cbWidth/2, height: windowBounds.height/4)
        colorBar.frame.size = CGSize(width: cbWidth, height: windowBounds.height/4)
        UIView.animateWithDuration(0.30, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            colorBar.frame.origin = CGPoint(x: cbX, y: windowBounds.height/5)
            }, completion: { (finished: Bool) -> Void in
        })

        
        
        
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}