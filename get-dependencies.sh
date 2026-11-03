#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	cairo         \
	cmake         \
	expat         \
	gspell        \
	libjpeg-turbo \
	libnotify     \
	libpng        \
	libtiff       \
	libwebp       \
	libx11        \
	libxkbcommon  \
	ninja         \
	pango         \
	pcre2         \
	sdl2          \
	zlib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
git clone https://github.com/aardappel/treesheets.git ./treesheets && (
	cd ./treesheets
	git fetch --tags origin
	TAG=$(git tag --sort=-v:refname | grep -vi 'rc\|alpha\|beta' | head -1)
	git checkout "$TAG"

	cmake \
		-B ./build                        \
		-G Ninja                          \
		-W no-author                      \
		-D CMAKE_BUILD_TYPE=Release       \
		-D CMAKE_INSTALL_PREFIX=/usr      \
		-D TREESHEETS_BUNDLE_WXWIDGETS=ON \
		-D TREESHEETS_VERSION="$TAG"

	cmake --build ./build
	cmake --install ./build

	echo "$TAG" > ~/version
)
