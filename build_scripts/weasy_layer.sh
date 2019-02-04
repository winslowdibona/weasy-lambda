#!/bin/bash

set -e

export LAMBDA_TASK_ROOT=/opt/python
export PATH=$LAMBDA_TASK_ROOT/bin:/usr/local/bin:/usr/bin/:/bin
export LDFLAGS=-Wl,-rpath=$LAMBDA_TASK_ROOT/lib/
export PKG_CONFIG_PATH=$LAMBDA_TASK_ROOT/lib/pkgconfig
export LD_LIBRARY_PATH=$LAMBDA_TASK_ROOT/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$LAMBDA_TASK_ROOT/include/
export CPLUS_INCLUDE_PATH=$LAMBDA_TASK_ROOT/include/

function lib_install {
    old_dir=$PWD
    cd /tmp
    curl -L $1 -O && \
        archive=$(echo $1 | awk -F "/" '{print $NF}') && \
        tar xf $archive && \
        cd $(echo $archive | sed 's/.tar.*//') && \
        eval $3 && \
        ./configure --prefix=$LAMBDA_TASK_ROOT $2 && \
        make && \
        make install && \
        cd /tmp
    cd $old_dir
}

yum install gcc gcc-c++ tar autoconf automake diffutils libtool bzip2 bzip2-devel python36-devel \
    python36-pip openssl-devel zlib-devel libffi-devel gettext-devel libmount-devel cairo-devel \
    python-cffi python3-cffi


lib_install ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
lib_install ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz
lib_install ftp://xmlsoft.org/libxml2/libxslt-1.1.29.tar.gz
lib_install http://downloads.sourceforge.net/libpng/libpng-1.6.21.tar.xz
lib_install ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.gz '--enable-unicode-properties'
lib_install https://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.2.tar.xz
lib_install http://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz
lib_install https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.3.tar.bz2
rm -rf /tmp/freetype* || true
lib_install http://download.savannah.gnu.org/releases/freetype/freetype-2.7.tar.gz
lib_install https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.0.tar.bz2 '--enable-libxml2'
lib_install http://www.cairographics.org/releases/pixman-0.34.0.tar.gz
lib_install http://cairographics.org/releases/cairo-1.14.6.tar.xz '' 'autoreconf --force --install'
lib_install http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.3.tar.xz


# Setup fonts
curl -L http://sourceforge.net/projects/dejavu/files/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2 -O && \
    tar xf dejavu-fonts-ttf-2.37.tar.bz2 && \
    cd dejavu-fonts-ttf-2.37 && \
    mkdir -p /opt/python/etc/fonts/conf.d
    cp -r fontconfig/* /opt/python/etc/fonts/conf.d/ && \
    mkdir -p /opt/python/share/fonts && \
    mv ttf /opt/python/share/fonts/dejavu && \
    touch /opt/python/etc/fonts/fonts.conf && \
    sed -i 's/usr/var\/task/' /opt/python/etc/fonts/fonts.conf

# Cleanup
cd $LAMBDA_TASK_ROOT
#rm -r dejavu-fonts-ttf-2.37*
mv share/fonts* .
rm -rf ./{bin,include,share,var} || true
mkdir -p share
mv fonts* share/
rm lib/*.{a,la}
strip lib/*.so*


python3 -m pip install weasyprint
cp -a /usr/local/lib/python3.6/site-packages/. .
cp -a /usr/local/lib64/python3.6/site-packages/. .

# cairocffi uses Python's ctypes library finder which doesn't use LD_LIBRARY_PATH
one="cairo = dlopen(ffi, 'cairo', 'cairo-2', 'cairo-gobject-2')"
two="cairo = ffi.dlopen('libcairo.so')"
sed -i "s/$one/$two/" cairocffi/__init__.py
