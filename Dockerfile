#  Cassandra Datastax

# Oracle Linux
FROM oraclelinux:7

MAINTAINER huezohuezo1990 <>

ENV DSC_VERSION 21

ADD datastax.repo /etc/yum.repos.d/

RUN yum clean all && \
    yum update -y 

RUN yum install -y tar \
                   hostname \
                   wget \
                   unzip \
                   dsc$DSC_VERSION \
                   cassandra$DSC_VERSION-tools
        
        
                   
RUN yum install nano -y

                   
RUN yum install java -y


RUN yum clean all

ENV CASSANDRA_CONFIG /etc/cassandra/conf

# listen to all rpc
RUN sed -ri ' \
		s/^(rpc_address:).*/\1 0.0.0.0/; \
	' "$CASSANDRA_CONFIG/cassandra.yaml"

#COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh 

RUN chmod +x /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

#ENTRYPOINT ["/docker-entrypoint.sh"]



VOLUME /var/lib/cassandra/data

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160
CMD ["cassandra", "-f"]
