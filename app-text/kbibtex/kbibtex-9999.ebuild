# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="optional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="BibTeX editor to edit bibliographies used with LaTeX"
HOMEPAGE="https://userbase.kde.org/KBibTeX"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/KBibTeX/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/jfmcarreira/kbibtex.git"
fi

LICENSE="GPL-2"
IUSE="webengine webkit zotero"

REQUIRED_USE="?? ( webengine webkit )"

DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	app-text/poppler
	dev-libs/icu:=
	virtual/tex-base
	webengine? ( $(add_qt_dep qtwebengine 'widgets') )
	webkit? ( $(add_qt_dep qtwebkit) )
	zotero? (
		app-crypt/qca
		dev-libs/qoauth:5
	)
"
RDEPEND="${DEPEND}
	!app-text/kbibtex:4
	dev-tex/bibtex2html
	x11-misc/shared-mime-info
"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package webengine Qt5WebEngineWidgets)
		$(cmake-utils_use_find_package webkit Qt5WebKitWidgets)
		$(cmake-utils_use_find_package zotero Qca-qt5)
	)

	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "kde-apps/okular:${SLOT}" ; then
		elog "For PDF or PostScript document preview support, please install kde-apps/okular:${SLOT}"
	fi
}
