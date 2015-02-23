# iControl
This project is built to demonstrate OpenCV's algorithm to find the brightest point in an image and use this to to move the mouse on the screen. It was created and prototyped to be an additional method of input from the user for the GNOME Mousetrap project (https://wiki.gnome.org/action/show/Projects/MouseTrap?action=show&redirect=MouseTrap)

Requires a semi-bright point object attached to the user's head. For testing and devlopment, I used a simple LED head lamp, covered with a post-it note to make it translucent, and then used duct tape to leave only a small portion of the light shining through. This lead to very good results.

One current drawback to this method is the algorithm currently invoked from OpenCV simply finds the brightest point without looking at the surrounding areas. This can lead to objects other than the wanted apparatus being the detected point, causing erratic behavior. As I continue to develop, I will try and find a method that searches for a point light, taking into account the surrounding area's brightness around the brightest point. 
