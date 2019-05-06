FROM ubuntu:18.04

# libvips version
ENV LIBVIPS_VERSION_MAJOR 8
ENV LIBVIPS_VERSION_MINOR 6
ENV LIBVIPS_VERSION_PATCH 5
ENV LIBVIPS_VERSION $LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH

# Install pip
RUN apt-get update && apt-get install -y \
	python python-pip python3-pip python-dev build-essential libssl-dev libffi-dev &&\
	pip install --upgrade setuptools cffi Flask==0.10.1 pyvips

# Install dependencies
RUN apt-get install -y automake build-essential wget \
  	cdbs debhelper dh-autoreconf flex bison \
  	libjpeg-dev libtiff-dev libpng-dev libgif-dev librsvg2-dev libpoppler-glib-dev zlib1g-dev fftw3-dev liblcms2-dev \
  	liblcms2-dev libmagickwand-dev libfreetype6-dev libpango1.0-dev libfontconfig1-dev libglib2.0-dev libice-dev \
  	gettext pkg-config libxml-parser-perl libexif-gtk-dev liborc-0.4-dev libopenexr-dev libmatio-dev libxml2-dev \
	libcfitsio-dev libopenslide-dev libwebp-dev libgsf-1-dev libgirepository1.0-dev gtk-doc-tools

# Install libvips
RUN cd /tmp && \
	wget https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz && \
  	tar xvf vips-$LIBVIPS_VERSION.tar.gz && \
  	cd /tmp/vips-$LIBVIPS_VERSION && \
  	./configure --enable-debug=no --without-python $1 && \
  	make && \
  	make install && \
	ldconfig

# Clean up
RUN \
  	apt-get remove -y automake curl build-essential && \
  	apt-get autoremove -y && \
  	apt-get autoclean && \
  	apt-get clean && \
  	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

 # Install ffmpeg
 RUN apt-get update -y && apt-get install software-properties-common -y && add-apt-repository universe && apt-get install ffmpeg -y && \
 	 pip install ffmpeg-python

# Copy files 
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
RUN mkdir /usr/src/app/static
COPY sample-images /usr/src/app/static

# Tell the port number the container should expose
EXPOSE 5000

# Run the application
CMD ["python", "/usr/src/app/app.py"]