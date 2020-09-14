# Generate docker image for wvu solution using dockerfile

source "srcp2-competitors/docker/scripts/srcp2_setup.bash"

SOLUTION_NAME="no-repo-specified:wvu"
PATH_TO_DOCKERFILE="qual_solution_wvu.dockerfile"

echo -e "${echo_info} building wvu solution..."

if ! docker build --file ${PATH_TO_DOCKERFILE} --tag  ${SOLUTION_NAME} .
then
    echo -e "${echo_error} unable to build wvu solution"
    quit_with_popd 1
fi

echo -e "${echo_ok} ...done"
