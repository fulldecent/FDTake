==FDTake==

Helps you quickly take a picture or video like this:
<img src="http://i.stack.imgur.com/OajHy.jpg" alt="screenshot" />

Behind the scenes we are doing all of this:

 * see if device has camera
 * create action sheet with appropriate options (take photo or select from library)
 * translate "Take Photo" and "Choose from Library" into every language
 * look for response
 * bring up image picker with selected image picking method
 * get response, extract image from a dictionary
 * dismiss picker, get image to delegate

=Status=

 * Selecting a photo works, video is still in progress
 * Messages are in English, translations welcome

