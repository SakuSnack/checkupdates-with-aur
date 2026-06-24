# Maintainer: SakuSnack
pkgname=checkupdates-with-aur
pkgver=2.1.0
pkgrel=1
pkgdesc="Helper script to check updates, including AUR updates, nicely formatted"
arch=('any')
url="https://github.com/SakuSnack/checkupdates-with-aur"
license=('GPL-3.0-or-later')
depends=('pacman-contrib' 'aurutils')
source=(
  "${pkgname}.sh"
  "LICENSE"
)
sha256sums=(
  '727c74ac2c1405ef7503bde0646a992588f94302cbe3a2a997e1941e55ecb5e2'
  '3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986')

package() {
  install -Dm755 "${srcdir}/${pkgname}.sh" "${pkgdir}/usr/bin/${pkgname}"
  install -Dm644 "${srcdir}/LICENSE" "${pkgdir}/usr/share/licenses/${pkgname}/LICENSE"
}

# vim:set ts=2 sw=2 et:
