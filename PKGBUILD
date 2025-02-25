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
sha256sums=('666fa50facc6b90f1fb37fae602efaea6131a25ca46190ff331a944b04a9ef2a')

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