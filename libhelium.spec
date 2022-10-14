Summary:        The Application Framework for tauOS apps
Name:           libhelium
Version:        1.0
Release:        32%{?dist}
License:        GPLv3
URL:            https://tauos.co
Source0:        %{name}-%{version}.tar.gz
Source1:        README.md
Source2:        COPYING

BuildRequires:  sass
BuildRequires:  meson
BuildRequires:  ninja-build
BuildRequires:  vala
# Needed for wrap
BuildRequires:  git
BuildRequires:  pkgconfig(glib-2.0) >= 2.66.0
BuildRequires:  pkgconfig(gobject-introspection-1.0)
BuildRequires:  pkgconfig(gee-0.8)
BuildRequires:  pkgconfig(gtk4) >= 4.4

Requires: gtk4 >= 4.4
Requires: glib2 >= 2.66.0
Requires: libgee >= 0.20
Requires: tau-helium >= %{version}

%description
The Application Framework for tauOS apps

%package devel
Summary:        Development files for libhelium
Requires:       libhelium = %{version}-%{release}

%description devel
This package contains the libraries and header files that are needed
for writing applications with libhelium.

%prep
%autosetup

%build
%meson \
    -Ddemo=false \
    -Ddocumentation=false \
    --wrap-mode=default
%meson_build

%install
# Install licenses
mkdir -p licenses
install -pm 0644 %SOURCE1 licenses/LICENSE
install -pm 0644 %SOURCE0 README.md
%meson_install

rm -rf %{buildroot}%{_bindir}/blueprint-compiler
rm -rf %{buildroot}%{_datadir}/themes/*

%files
%license licenses/LICENSE
%doc README.md
%{_libdir}/libhelium-1.so*
%{_libdir}/girepository-1.0

%files devel
%{_includedir}/*
%{_datadir}/gir-1.0/*
%{_libdir}/pkgconfig/*
%{_datadir}/vala/*

%changelog
* Tue Jun 14 2022 Jamie Murphy <jamie@fyralabs.com> - 1.0-6
- I think we finally fixed naming

* Sat Jun 4 2022 Jamie Murphy <jamie@fyralabs.com> - 1.0-1
- Initial Release
