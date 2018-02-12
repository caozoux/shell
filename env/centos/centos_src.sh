wget http://vault.centos.org/7.4.1708/os/Source/SPackages/kernel-3.10.0-693.el7.src.rpm

mkdir -p ~/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
rpm -i kernel-3.10.0-693.el7.src.rpm 2>&1 | grep -v exist
cd ~/rpmbuild/SPECS
rpmbuild -bp --target=$(uname -m) kernel.spec

cd ~/rpmbuild/BUILD/kernel-*/linux-*/
