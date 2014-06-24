#
# CannyOS Fedora container with epiphany
#
# https://github.com/intlabs/cannyos-application-fedora-gtk3-epiphany
#
# Copyright 2014 Pete Birley
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Pull base image.
FROM intlabs/cannyos-base-fedora-gtk3

# Set environment variables.
ENV HOME /root

# Set the working directory
WORKDIR /

#****************************************************
#                                                   *
#         INSERT COMMANDS BELLOW THIS               *
#                                                   *
#****************************************************




#Install epiphany
WORKDIR /tmp
RUN yum install -y yum-utils rpmdevtools
RUN yum-builddep -y epiphany
RUN rpmdev-setuptree && \
	cd ~/rpmbuild/SRPMS/ && \
	yumdownloader --source epiphany && \
	rpm -ivh epiphany* && \
	cd ~/rpmbuild && \
	tar xf ~/rpmbuild/SOURCES/epiphany-3.12.1.tar.xz && \
	cp -r ~/rpmbuild/SOURCES/epiphany-3.12.1 ~/rpmbuild/SOURCES/epiphany-3.12.1p && \
	rpmbuild -bb SPECS/epiphany.spec && \
	yum localinstall -y --nogpgcheck ~/rpmbuild/RPMS/x86_64/epiphany-3.12.1-2.fc21.x86_64.rpm


#****************************************************
#                                                   *
#         ONLY PORT RULES BELLOW THIS               *
#                                                   *
#****************************************************

#HTTP (broadway)
EXPOSE 80/tcp

#****************************************************
#                                                   *
#         NO COMMANDS BELLOW THIS                   *
#                                                   *
#****************************************************

#Add startup & post-install script
ADD CannyOS /CannyOS
WORKDIR /CannyOS
RUN chmod +x *.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
ENTRYPOINT ["/CannyOS/startup.sh"]