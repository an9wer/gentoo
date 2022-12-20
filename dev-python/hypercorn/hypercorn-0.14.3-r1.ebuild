# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="A ASGI Server based on Hyper libraries and inspired by Gunicorn"
HOMEPAGE="
	https://github.com/pgjones/hypercorn/
	https://pypi.org/project/hypercorn/
"
SRC_URI="
	https://github.com/pgjones/hypercorn/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-python/h11[${PYTHON_USEDEP}]
	>=dev-python/h2-3.1.0[${PYTHON_USEDEP}]
	dev-python/priority[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.{8..10})
	>=dev-python/wsproto-0.14.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-trio[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${P}-tomli.patch
	)

	sed -i -e 's:--no-cov-on-fail::' pyproject.toml || die
	distutils-r1_src_prepare
}
