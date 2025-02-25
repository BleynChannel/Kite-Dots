# Maintainer: Bleyn Channel <bleyn2017@gmail.com>
pkgname=kite-appimage
pkgver=1.0.0
pkgrel=1
pkgdesc="Ground control for unmanned vehicles."
arch=('x86_64')
url="https://github.com/BleynChannel/qgroundcontrol"
license=('GPL3')

depends=( 'bzip2'
		  'dbus'
		  'flac'
		  'gst-plugins-base-libs'
		  'libasyncns'
		  'libffi'
		  'libgcrypt'
		  'libgpg-error'
		  'libogg'
		  'libsndfile'
		  'libsystemd'
		  'libunwind'
		  'libx11'
		  'libxau'
		  'libxcb'
		  'libxdmcp'
		  'libxext'
		  'lz4'
		  'orc'
		  'pcre'
		  'sdl2'
		  'xz'
		  'zlib'
		  'icu' )
options=(!strip)
conflicts=('kite')

source=("file://${startdir}/Kite.AppImage")
noextract=("Kite.AppImage")
sha256sums=('db897a4a0ff06ebf2525a98dd3b5d2850688f4d100d622d6b05670983270b004')

build() {
	echo "[Desktop Entry]
Type=Application
Name=Kite
Comment=Ground control for unmanned vehicles
Path=/opt/${pkgname}/
Exec=/usr/bin/${pkgname}
Terminal=false
Categories=Qt;Utility;" > "$srcdir/${pkgname}.desktop"
}

package() {
  mkdir -p "${pkgdir}/opt/${pkgname}" "${pkgdir}/usr/bin" "${pkgdir}/usr/share/applications"

  install -Dm755 "${srcdir}/Kite.AppImage" "${pkgdir}/opt/${pkgname}/${pkgname}.AppImage"
  cp "$srcdir/${pkgname}.desktop" "${pkgdir}/opt/${pkgname}/"

  ln -s "/opt/${pkgname}/${pkgname}.AppImage" "${pkgdir}/usr/bin/Kite"
  ln -s "/opt/${pkgname}/${pkgname}.desktop" "${pkgdir}/usr/share/applications/Kite.desktop"
}

# vim:set ts=2 sw=2 et: