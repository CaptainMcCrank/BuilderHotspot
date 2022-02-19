# BuilderHotspot
A solution for automating Raspberry Pi Development with Ansible from a wifi Hotspot running apt-cacher-ng

---
If you are looking for a better way to automate the development of Raspberry pis, this is the guide for you.
--- 


The Raspberry Pi is an optimal platform for hobbyists who want to build prototypes and learn about computers.  It does not make it easy for people who want to implement the guides they find on the Internet.  Users who follow  Internet-hosted Raspberry pi projects spend almost as much time troubleshooting stale documentation as they do troubleshooting their actual device.  I have fixed this problem by providing Raspberry Pi Developers an easier way to develop and share Raspberry pi IoT projects.  I present to you the Totally Rad Ansible Builder Wifi Hotspot.  You can use this platform in your Continuous development process to create a recipe that enables reproducible builds* of your raspberry pi project.

---

This guide will help you get your own Ansible Builder Hotspot up and running on a raspberry pi.  The builder hotspot’s primary features are:

- **A wifi network which can host target raspberry pis for automation**
- **An easy-to-use Ansible automation environment** that provisions configurations & customizations to raspberry pis attached to the wifi network
- **Build process acceleration** by locally hosting redundant software downloads via apt-cacher-ng 

If you do raspberry pi development, you should consider using this tooling to help you:
- **Start caching redundant package downloads via apt-cacher-ng embedded in the hotspot.**  The builder hotspot does this by caching unchanged Apt-get packages locally.  Apt-cacher-ng watches for updates and stores them local to your network them when they’re available. This means that after you’ve downloaded the packages for one device- they’re faster to be applied to the next device.
- **Make your projects more accessible to other developers via Ansible Build Scripts.**  Build automation helps you get closer to being a 10x developer.  10x developers make it easier for other people to take advantage of your projects.  Many pi projects ask users to install their projects via dangerous combinations of wget’ing a shell script and piping it to the shell. This is DANGEROUS and asks the end-user to extend an unreasonable amount of trust.  (e.g. wget -q -O - example.com/dontrunme.sh | bash).   Ansible scripts are transparent
- **Reduce insecure software embedded in your projects by applying the most recent security patches.**  The builder hotspot uses apt for pulling the most up-to-date software packages in your project.  This will ensure that the most recent versions of software dependencies are installed on your system without modifications to your build scripts or your local store of ready-to-compile packages. 
- **Inspect network traffic during package installs.** Sometimes devices do unexpected things because of software installed on the system.  This environment gives you a simple way to quickly analyze device traffic via common network tools like tcpdump, iptraf-ng, etc. 
- **Deploy dynamic images to multiple raspberry pis concurrently.**  The normal raspberry pi image distribution flow involves downloading an image, ripping it to an sd card and installing it.  If you have only one SDwriter, you’ll have to wait through the writing process for each card and manually intervene for each new device.  With this solution, you install lean Rasbpian images into each device and then push the deployed image to every device simultaneously. 
