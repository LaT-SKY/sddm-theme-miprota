# Maintainer: Neo <liujunzhe070611@gmail.com>
# Contributor: Claude <noreply@anthropic.com>

pkgname=sddm-theme-miprota
pkgver=0.1
pkgrel=1
pkgdesc="Material Design 3 SDDM login theme — blurred background, session switcher, smooth animations"
arch=('any')
url="https://github.com/LaT-SKY/sddm-theme-miprota"
license=('MIT')
depends=('sddm')
source=("${pkgname}-${pkgver}.tar.gz::${url}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    install -dm755 "${pkgdir}/usr/share/sddm/themes/miprota"
    cp -r "${srcdir}/${pkgname}-${pkgver}/"* "${pkgdir}/usr/share/sddm/themes/miprota/"
}
