FROM nvidia/cuda:11.8.0-devel-rockylinux8

ENV PG_MAJOR_VERSION 15
ENV PG_MINOR_VERSION 15.0-1

# Explicitly set the user/group IDs
RUN set -eux; \
	groupadd -r postgres --gid=5432; \
	useradd -r -g postgres --uid=5432 --home-dir=/var/lib/postgresql --shell=/bin/bash postgres; \ 
	mkdir -p /var/lib/postgresql; \
	chown -R postgres:postgres /var/lib/postgresql

RUN mkdir /docker-entrypoint-initdb.d

RUN dnf update -y
RUN dnf module list postgresql
RUN dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN dnf -qy module disable postgresql

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --set-enabled powertools

# Install PostGIS and additional packages that will be needed to run
RUN dnf install -y postgresql$PG_MAJOR_VERSION postgresql$PG_MAJOR_VERSION-devel postgresql$PG_MAJOR_VERSION-server

# Install some utilities for convenience for things like loading the Tiger dataset from within the container
RUN dnf install -y ca-certificates findutils wget curl unzip nano git redhat-rpm-config


ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:/usr/local/cuda/lib64
ENV PATH $PATH:/usr/pgsql-$PG_MAJOR_VERSION/bin
ENV PGDATA /var/lib/postgresql/data


# Install PG-Strom
COPY pg-strom /build/pg-strom
RUN cd /build/pg-strom && \
    make -j $(nproc) && \
    make install

# gosu
COPY gosu /usr/bin/gosu
RUN chmod a+x /usr/bin/gosu


# This 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"

### VOLUME ["/var/lib/postgresql/data"]

COPY docker-entrypoint.sh /usr/local/bin/

# Copy the PG-Strom customized 'postgresql.conf' to a custom location
COPY postgresql.conf /etc/postgresql/postgresql.conf 

RUN ["chmod", "+x", "/usr/local/bin/docker-entrypoint.sh"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
STOPSIGNAL SIGINT
EXPOSE 5432
CMD ["postgres","-c","config_file=/etc/postgresql/postgresql.conf"]
