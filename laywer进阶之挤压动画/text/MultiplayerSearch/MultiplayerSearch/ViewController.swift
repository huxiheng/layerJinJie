import UIKit

//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
  let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
  
  dispatch_after(popTime, dispatch_get_main_queue()) {
    completion()
  }
}

class ViewController: UIViewController {
  
  @IBOutlet var myAvatar: AvatarView!
  @IBOutlet var opponentAvatar: AvatarView!
  
  @IBOutlet var status: UILabel!
  @IBOutlet var vs: UILabel!
  @IBOutlet var searchAgain: UIButton!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    searchForOpponent()//游戏开始过程中搜索对手的动画
  }
  
  @IBAction func actionSearchAgain() {
    UIApplication.sharedApplication().keyWindow!.rootViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
  }
    
    func searchForOpponent(){
        let avatarSize = myAvatar.frame.size
        let bounceXOffset: CGFloat = avatarSize.width/1.9//设置一个水平方向上的反弹偏移量
        let morphSize = CGSize(
            width: avatarSize.width * 0.85,
            height: avatarSize.height * 1.1)//设置了头像的变形大小
      //计算2个头像到达反弹点时发生轻微的碰撞，计算出左右2个反弹点，然后通过动画将其分开
        let rightBouncePoint = CGPoint(
            x: view.frame.size.width/2.0 + bounceXOffset,
            y: myAvatar.center.y)
        let leftBouncePoint = CGPoint(
            x: view.frame.size.width/2.0 - bounceXOffset,
            y: myAvatar.center.y)
        /*第一个参数是头像发生碰撞的点，
         第二个参数是头像发生碰撞时的变形大小*/
        myAvatar.bounceOffPoint(rightBouncePoint, morphSize: morphSize)
        opponentAvatar.bounceOffPoint(leftBouncePoint, morphSize: morphSize)
        
        delay(seconds: 4.0, completion: foundOpponent)
    }
    
    func foundOpponent() {
        status.text = "Connecting..."
        
        opponentAvatar.image = UIImage(named: "avatar-2")
        opponentAvatar.name = "Ray"
        
        delay(seconds: 4.0, completion: connectedToOpponent)
    }
    
    func connectedToOpponent() {
        myAvatar.shouldTransitionToFinishedState = true//为了结束搜索信息完成之后，结束反弹动画
        opponentAvatar.shouldTransitionToFinishedState = true
        
        delay(seconds: 1.0, completion: completed)
    }
    
    func completed() {
        status.text = "Ready to play"
        UIView.animateWithDuration(0.2) {
            self.vs.alpha = 1.0
            self.searchAgain.alpha = 1.0
        }
    }
}

