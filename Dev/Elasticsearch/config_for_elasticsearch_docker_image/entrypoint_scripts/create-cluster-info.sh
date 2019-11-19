#!/usr/bin/bash
# Author: care zhang

# Set the env:
#	CURL_CA_BUNDLE: verifying the k8s api server's identity.
#	TOKEN: authenticating with the k8s api server.
export CURL_CA_BUNDLE=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export TOKEN=`cat /var/run/secrets/kubernetes.io/serviceaccount/token`

# Get the elasticsearch pod instance from the k8s api server.
# Note:
# 	1--> curl use cacert in env $CURL_CA_BUNDLE and token in env $TOKEN

#	2--> In kubernetes.
#		   A Service called kubernetes is automatically exposed in the default namespace \
#        and configured to point to the API server.

#	3--> Use query parameter "labelSelector" to restrict the list of returned objects \
#	       The label of the pod is "pod-for" with value of "elasticsearch", \
#	     that means only the elasticsearch pod with this label will be listed.

curl -H "Authorization: Bearer $TOKEN" "https://kubernetes/api/v1/namespaces/default/pods?labelSelector=pod-for=elasticsearch" \
	> /usr/share/elasticsearch/elasticsearch-pod.json

elasticsearch_pod_json=/usr/share/elasticsearch/elasticsearch-pod.json
elasticsearch_config=/usr/share/elasticsearch/config/elasticsearch.yml

elasticsearch_config_create(){
	elasticsearch_args=`${1}`
	
	for elasticsearch_arg in ${elasticsearch_args}
	do
		elasticsearch_arg=${elasticsearch_arg#\"}
		elasticsearch_arg=${elasticsearch_arg%\"}
		echo "   - ${elasticsearch_arg}" >> "${elasticsearch_config}"
	done
}

# Set discovery.seed_hosts in elasticsearch.yml
echo "discovery.seed_hosts:" >> "${elasticsearch_config}"
elasticsearch_config_create "jq .items[].status.podIP ${elasticsearch_pod_json}"

# Set cluster.initial_master_nodes in elasticsearch.yml
echo "cluster.initial_master_nodes:" >> "${elasticsearch_config}"
elasticsearch_config_create "jq .items[].metadata.name ${elasticsearch_pod_json}"
