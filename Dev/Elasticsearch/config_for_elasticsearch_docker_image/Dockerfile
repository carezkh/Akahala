FROM 192.168.1.64:5000/elasticsearch
RUN	yum install -y epel-release && \
	yum install -y jq && \
	yum clean all 
COPY entrypoint_scripts/ /usr/local/bin/ 
