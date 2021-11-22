Name:  gatewaycpushare
Version: 1.0.0
Vendor:  ksyun
Release: 1
Summary: GUN gatewaycpushare1.0.0

Source0:    gatewaycpushare-%{version}.tar.gz
License:    GPL

%description
The GNU Tengine WEB Server program. 

%prep
%setup -q -n gatewaycpushare-%{version}

%build

%install
rm -rf %{buildroot}/* 
#mkdir  %{buildroot}/usr
cp -rf usr %{buildroot}/
 
#make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
/usr/lib/systemd/system/gatewaycpushare.service
/usr/sbin/tron_stonet_cg.sh

%changelog
* Mon Oct 4 2021 <schangech@gmail.com>
* Add Tron storage and net gateway cpushare service 
