 import UIKit

class ViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    
    //Properties
    let APPLICATION_ID = "75682D86-DADE-F3D7-FF53-D715A16AEF00"
    let API_KEY = "EE64F47F-619D-734E-FF11-AEC37FB38100"
    let SERVER_URL = "https://api.backendless.com"
    let backendless = Backendless.sharedInstance()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backendless.hostURL = SERVER_URL
        backendless.initApp(APPLICATION_ID, apiKey: API_KEY)
        
        buildAgreeTextViewFromString(NSLocalizedString("I agree to the #<ts>terms of service# and #<pp>privacy policy#"))
        
        // Saving test object in the test table
        let testObject = ["foo" : "bar"];
        let dataStore = backendless.data.ofTable("TestTable")
        dataStore?.save(testObject,
                        response: {
                            (result) -> () in
                            print("Object is saved in Backendless. Please check in the console.")
        },
                        error: {
                            (fault : Fault?) -> () in
                            print("Server reported an error: \(String(describing: fault))")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // methods
    
    func buildAgreeTextViewFromString (localizedString: NSString) -> Void
    {
    // 1. Split the localized string on the # sign:
        var localizedStringPieces : [String] = localizedString.components(separatedBy: "#")
    
    // 2. Loop through all the pieces:
        var msgChunkCount = localizedStringPieces.count
        var wordLocation: CGPoint = CGPoint(0.0, 0.0);
    for chunk in localizedStringPieces
    {
    if (chunk == "")
    {
    continue;     // skip this loop if the chunk is empty
    }
    
    // 3. Determine what type of word this is:
        var isTermsOfServiceLink: Bool = chunk.hasPrefix("<ts>");
        var isPrivacyPolicyLink: Bool  = chunk.hasPrefix("<pp>");
        var isLink : Bool = (isTermsOfServiceLink || isPrivacyPolicyLink);
    
    // 4. Create label, styling dependent on whether it's a link:
    registerLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 15.0)
    registerLabel.text = chunk;
    registerLabel.isUserInteractionEnabled = isLink;
    
    if (isLink){
    registerLabel.textColor = UIColor(displayP3Red: 110/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1,0)
    registerLabel.highlightedTextColor = UIColor.yellow
    
    // 5. Set tap gesture for this clickable text:
        var selectorAction: Selector
        if(isTermsOfServiceLink){
            selectorAction = Selector()
        } else if (isPrivacyPolicyLink){
            selectorAction = Selector(tapOnPrivacyPolicyLink)
        }
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selectorAction)
    registerLabel.addGestureRecognizer(tapGesture);
    
    // Trim the markup characters from the label:
    if (isTermsOfServiceLink)
    label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
    if (isPrivacyPolicyLink)
    label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
    }
    else
    {
    label.textColor = [UIColor whiteColor];
    }
    
    // 6. Lay out the labels so it forms a complete sentence again:
    
    // If this word doesn't fit at end of this line, then move it to the next
    // line and make sure any leading spaces are stripped off so it aligns nicely:
    
    [label sizeToFit];
    
    if (self.agreeTextContainerView.frame.size.width < wordLocation.x + label.bounds.size.width)
    {
    wordLocation.x = 0.0;                       // move this word all the way to the left...
    wordLocation.y += label.frame.size.height;  // ...on the next line
    
    // And trim of any leading white space:
    NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
    options:NSRegularExpressionSearch];
    if (startingWhiteSpaceRange.location == 0)
    {
    label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
    withString:@""];
    [label sizeToFit];
    }
    }
    
    // Set the location for this label:
    label.frame = CGRectMake(wordLocation.x,
    wordLocation.y,
    label.frame.size.width,
    label.frame.size.height);
    // Show this label:
    [self.agreeTextContainerView addSubview:label];
    
    // Update the horizontal position for the next word:
    wordLocation.x += label.frame.size.width;
    }
    }
    
    // Gesture Recognizer
    
    func tapOnTermsOfServiceLink (tapGesture: UITapGestureRecognizer ) -> Void
    {
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
    print("User tapped on the Terms of Service link")
    }
    }
    
    
    func tapOnPrivacyPolicyLink(tapGesture: UITapGestureRecognizer) -> Void
    {
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
    print("User tapped on the Privacy Policy link")
    }
    }
    
    //IBActions
    @IBAction func loginAction(_ sender: UIButton) {
    }
    
}
        
