---
last_verified: 2026-07-21
tool_version: n/a
sources:
  - https://www.xda-developers.com/most-people-install-linux-wrong-and-it-ruins-their-first-impression-forever/
  - https://medium.com/@niranjantk24/how-to-install-ubuntu-linux-a-complete-beginners-guide-with-fixes-for-grub-and-black-screen-1e396ba84c74
  - https://linuxano.com/top-10-linux-hardware-mistakes-beginners-make/
  - https://www.linuxteck.com/linux-quick-start-guide-2026/
  - https://dev.to/techrefreshing/10-linux-mistakes-every-beginner-makes-i-made-all-of-them-4och
  - https://www.howtogeek.com/844799/mistakes-new-linux-users-make/
---

# Install Linux in a VM — what tripped me up

I spun up a Linux VM to practice before touching real hardware. Picked Ubuntu 24.04 LTS because the beginner distro research kept pointing to it as the smoothest starting point.

First attempt failed fast. I skipped the live USB hardware test and went straight to the installer. After reboot I hit a GRUB rescue prompt. The cause: I was dual-booting without disabling Fast Startup or Secure Boot in Windows first.

Fixed those BIOS settings, reinstalled, and got to the desktop. Then I ran `sudo apt update && sudo apt upgrade -y` and watched the terminal scroll for fifteen minutes. After that, the core commands started sticking: `pwd`, `ls -la`, `cd`, `mkdir`, `cp`, `rm`, `man`, `chmod`.

My biggest mistake was using `sudo` for everything. Later when `mkdir project` failed with permission errors, `ls -la` showed the folder was owned by root. Lesson: regular user for daily work, `sudo` only when a command actually needs privilege escalation.
