# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils git-r3

DESCRIPTION="plaYUVer is an open-source QT based raw video player"
HOMEPAGE="https://github.com/pixlra/playuver"
LICENSE="GPL-2"

EGIT_REPO_URI="https://github.com/pixlra/playuver.git"
EGIT_COMMIT="${PV}"

SLOT=0
KEYWORDS="~amd64"

X86_CPU_FEATURES="cpu_flags_x86_sse"
IUSE="+qt5 -qt4 ffmpeg opencv -static-libs $X86_CPU_FEATURES"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtprintsupport:5
		dev-qt/qtdbus:5
		dev-qt/qtconcurrent:5
	)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtdbus:4
	)
	ffmpeg? ( virtual/ffmpeg )
	opencv? ( media-libs/opencv )
"

RDEPEND="${DEPEND}"

REQUIRED_USE="
	?? ( qt5 qt4 )
	qt4? ( !opencv )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_SSE=$(usex cpu_flags_x86_sse)
		-DUSE_QT4=$(usex qt4)
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}