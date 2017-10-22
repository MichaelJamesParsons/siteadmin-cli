# Siteadmin CLI

A CLI installer/environment management tool for eLink Design's content management system, Siteadmin 3.

## Dependencies
 MySQL 5.7.6

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

    $ vagrant ssh   //SSH into vagrant box
    $ yum upgrade   //upgrade OS packages

    $ exit          //close ssh connection

    $ vagrant halt  //stop vagrant box
    $ vagrant plugin install vagrant-vbguest //install vbguest plugin
    $ vagrant up
    
##### Alternate Solution
If the solution above  does not work, install the latest version of VirtualBox and Vagrant.
