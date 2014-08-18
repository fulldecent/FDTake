FDTake [![Build Status](https://travis-ci.org/fulldecent/FDTake.svg?branch=master)](https://travis-ci.org/fulldecent/FDTake)
================
Helps you quickly take a picture or video like this:

<img src="http://i.imgur.com/HPY1taI.png" alt="screenshot" height=400/>
<img src="http://i.imgur.com/zEtLoZR.png" alt="screenshot" height=400/>
<img src="http://i.imgur.com/Brq6ojq.png" alt="screenshot" height=400/>

What you do
----------------
 1. Make a `FDTakeController` and call `- (void)takePhotoOrChooseFromLibrary`<br>
 2. Implement `FDTakeDelegate` and handle `- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info`
 3. Implement anything else you want in <a href="https://github.com/fulldecent/FDTake/blob/master/FDTakeExample/FDTakeController.h">`FDTakeController.h`</a>

See also: <a href="http://cocoadocs.org/docsets/FDTake/0.2.1/">CocoaDocs for FDTake</a>.

What we do
----------------
 1. See if device has camera
 2. Create action sheet with appropriate options ("Take Photo" or "Choose from Library"), as available
 3. Localize "Take Photo" and "Choose from Library" into user's language
 4. Wait for response
 5. Bring up image picker with selected image picking method
 6. Default to selfie mode if so configured
 7. Get response, extract image from a dictionary
 8. Dismiss picker, send image to delegate

Project status
----------------
 * Works with photo and videos; the camera and photo roll; iPhones, iPods and iPads
 * Supported languages:
   - English
   - Chinese Simplified
   - Turkish (thanks Suleyman Melikoglu)
   - French (thanks Guillaume Algis)
   - Dutch (thanks Mathijs Kadijk)
   - Chinese Traditional (thanks Qing Ao)
   - German (thanks Lars Häuser)
   - Russian (thanks Alexander Zubkov)
   - Norwegian (thanks Sindre Sorhus)
   - Arabic (thanks HadiIOS)
   - Polish (thanks Jacek Kwiecień)
   - Spanish (thanks David Jorge)
   - Hebrew (thanks Asaf Siman-Tov)
   - Danish (thanks kaspernissen)
   - Sweedish (thanks Paul Peelen)
   - Portugese (thanks Natan Rolnik)
   - Greek (thanks Konstantinos)
   - Please help translate <a href="https://github.com/fulldecent/FDTake/blob/master/FDTakeExample/en.lproj/FDTake.strings">`FDTake.strings`</a> to more languages
 * Works on iOS 4 or above, but requires ARC

