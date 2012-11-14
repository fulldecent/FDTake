**FDTake**
Helps you quickly take a picture or video like this:

<img src="http://i.stack.imgur.com/OajHy.jpg" alt="screenshot" height=400/>
<img src="http://i.imgur.com/W7XXj.png" alt="screenshot" height=400/>

Behind the scenes we are doing all of this:

 * see if device has camera
 * create action sheet with appropriate options (take photo or select from library)
 * translate "Take Photo" and "Choose from Library" into every language
 * look for response
 * bring up image picker with selected image picking method
 * get response, extract image from a dictionary
 * dismiss picker, get image to delegate

*Status*

 * You can select a photo or video, from iPhone and iPad
 * Supported languages:
   - English
   - Chinese
   - Turkish (thanks Suleyman Melikoglu)
   - Please help translate FDTake.strings for more languages
 * Works on iOS 4 or above, but requires ARC
