# SimpleAppLock
A simple app lock for Linux Distributions

I was wondering if you are using a common single login for your linux machine
Your machine may shared with your friends or siblings without a second user or guest user.
As they may use it infrequently, no additional user my be created
Or may be the second person would just use it for browsing. Or may be a specific app.
At some point, you need some privacy. Like you need an applock
Probably all of them know the main login, it is better to have an applock for important apps.

As name indicates, SimpleAppLock is simple and does the job.
SimpleAppLock doesnot use elevated privileges for the purpose.
However, it uses sudo privileges at the time of setting up of app.

SimpleAppLock is completely made of built-in linux commands.
So, it can be easily integrated with any popular Linux Distributions

#How to Setup

Either clone the repo or download the applock.sh file.
Make it executable and run from terminal
  
  chmod u+x applock.sh && ./applock.sh

Enjoy your applock for linux !

Some known issues are mentioned in knoown_issues.txt

Written by Abhijith S
abhijith.s4395@gmail.com
