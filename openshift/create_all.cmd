# create project
oc login -u developer -p developer
oc new-project gravitee

# add service account for host path
oc create serviceaccount gravitee -n gravitee

# affect policy
oc login -u system:admin
oc project gravitee
oc adm policy add-scc-to-user anyuid -z gravitee

oc login -u developer -p developer

# gateway
oc new-build ../ --name=gateway --context-dir=images/gateway/ --strategy=docker
oc start-build gateway --from-dir ../images/gateway/ --build-arg=GRAVITEEIO_VERSION=1.10.4

# management-api
oc new-build ../ --name=management-api --context-dir=images/management-api/ --strategy=docker
oc start-build management-api --from-dir ../images/management-api/ --build-arg=GRAVITEEIO_VERSION=1.10.4

# management-ui
oc new-build ../ --name=management-ui --context-dir=images/management-ui/ --strategy=docker
oc start-build management-ui --from-dir ../images/management-ui/

# import OpenShift Template
oc process -f .\template-graviteeapim.yaml | oc create -f -



