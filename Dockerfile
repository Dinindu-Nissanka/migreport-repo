FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /mnt/mig21_product
RUN mkdir -p /mnt/resources
WORKDIR /mnt/resources

RUN apt-get update 
RUN apt-get install -y apt-utils
RUN apt-get update
RUN apt-get install software-properties-common -y 
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update 
RUN apt-get install ansible -y 
RUN apt-get install unzip  
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get clean
        
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y mysql-server apache2 python python-django \
        python-celery rabbitmq-server git

ADD wso2telcoids-2.0.2-SNAPSHOT.zip /mnt/resources
ADD dbscripts /mnt/resources/dbscripts
ADD prereq /mnt/resources/prereq
ADD hosts /mnt/resources
ADD ansible.cfg /mnt/resources
ADD deploy-v2.yml /mnt/resources

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

EXPOSE 9443
EXPOSE 9763
EXPOSE 6300

CMD service mysql start && ansible-playbook deploy-v2.yml

