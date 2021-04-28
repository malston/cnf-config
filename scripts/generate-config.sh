#!/bin/bash

set -e
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

SITE="${1:-ndc}"
CNF="nokia-amf"
CNF_CONFIG="generated-config.yml"
TCA_CONFIG="generated-tca-config.yml"
CLUSTER_TEMPLATE_CONFIG="generated-cluster-template.yml"
CLUSTER_CONFIG="generated-cluster.yml"

ytt -f "config/config.yml" \
  -f "config/${SITE}/tca.yml" \
  -f "config/${SITE}/extension.yml" \
  -f "config/${SITE}/smtp.yml" \
  -f "config/${SITE}/global.yml" > "${TCA_CONFIG}"

echo "tca config:"
echo "---"
cat "${TCA_CONFIG}"
echo ""
echo ""
echo ""

ytt -f "config/${SITE}/${CNF}/cnf.yml" \
  -f "config/${SITE}/${CNF}/params.yml" > "${CNF_CONFIG}"

echo "cnf config:"
echo "---"
cat "${CNF_CONFIG}"
echo ""
echo ""
echo ""

ytt -f "config/cluster-template.yml" \
  -f "config/${SITE}/${CNF}/cluster-values.yml" \
  > "${CLUSTER_TEMPLATE_CONFIG}"

echo "cluster-template:"
echo "---"
cat "${CLUSTER_TEMPLATE_CONFIG}"
echo ""
echo ""
echo ""

ytt -f "config/cluster.yml" \
  -f "config/${SITE}/${CNF}/cluster-values.yml" \
  > "${CLUSTER_CONFIG}"

echo "cluster:"
echo "---"
cat "${CLUSTER_CONFIG}"
