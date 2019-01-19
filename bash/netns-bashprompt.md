Put current Linux network namespace in `bash` prompt:
```
netns=$(ip netns identify)
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]\[\033[33;4m\]@$netns\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
```
