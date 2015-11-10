# inspiration from https://github.com/kubernetes/kubernetes/tree/master/docs/getting-started-guides/docker-multinode/deployDNS.md
#
# Change the variables to suit your needs. Then run this script, it will generate the 
# yamls for the replication controller and service for DNS
source config.sh

# create yaml files

sed -e "s/{{ pillar\['dns_replicas'\] }}/${DNS_REPLICAS}/g;s/{{ pillar\['dns_domain'\] }}/${DNS_DOMAIN}/g;s/{{ kube_server_url }}/${KUBE_SERVER}/g;" dns/skydns-rc.yaml.in > ./dns/skydns-rc.yaml

sed -e "s/{{ pillar\['dns_server'\] }}/${DNS_SERVER_IP}/g" dns/skydns-svc.yaml.in > ./dns/skydns-svc.yaml