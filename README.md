# Siteadmin CLI

A command-line interface for Siteadmin 3.

## Debugging Vagrant?


### Filesystem "vboxsf" is not available
> Vagrant was unable to mount VirtualBox shared folders. This is usually because the filesystem "vboxsf" is not available. This filesystem is made available via the VirtualBox Guest Additions  and kernel module. Please verify that these guest additions are properly installed in the guest. This is not a bug in Vagrant and is usually caused by a faulty Vagrant box. For context, the command attempted was:
>
>     mount -t vboxsf -o uid=1000,gid=1000 vagrant /vagrant
>
> the error output from the command was
>
>     /sbin/mount.vboxsf: mounting failed with the error: No such device

##### Solution

    $ vagrant halt
    $ vagrant plugin install vagrant-vbguest