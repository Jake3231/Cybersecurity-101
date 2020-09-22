//: [Previous: Security Patches](@previous)

/*:
 ![macOS Catalina Installer](macOSInstaller.png)
 # Removing Unneccesary Apps
 
 Once you have a secure operating system, the next step is to review and remove any unused or unneccesary applications. Even after closing the castle's gates, a 3rd party app may use a gate with a less secure locking mechanism. Even in well designed apps, an attacker could discover a completely new way to break the lock.
 
 The best way to keep attackers out is to remove some gates and locks completely! In this scene, you can simulate an attack with varying levels of defense. Try changing the type of gate used to protect the castle, as well as the type of malware that will attack.
 
 One of the malware variants you can select is a Zero Day. Zero day exploits are discoverd by attackers and are used against users with zero notice given to the manufactuer, allowing them no time to make an update that would fix the flaw. Because of this, they may be able to bypass defenses on a fully up-to-date operating system.
 
 Try changing the state of the castle gate to see how malware reacts:
 * .open
 * .closed
 * .removed
 */
gateSecurity = .closed


/*: Change the malware type below:
 * normal
 * zeroDay
 */
malwareType = .zeroDay

/*:Once you have set the variables to your desired value, click the play buttom at the bottom of the window to run the simulation.
 
 You may notice that completely removing an app keeps even zero day malware from getting to your data. Removing unneccesary apps closes as many potential weaknesses as possible.
 */

runAppsScene()
//: [Next: Firewall](@next)
