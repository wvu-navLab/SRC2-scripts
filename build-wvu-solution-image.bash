# Generate "solution" docker image for wvu solution using dockerfile

pushd `pwd` > /dev/null 2>&1
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)
source "docker/scripts/srcp2_setup.bash"

# SOLUTION_NAME="no-repo-specified:test"
PATH_TO_DOCKERFILE="wvu_solution.dockerfile"

function help() {
    echo -e "
${B}Synopsis:${rs}

    very simple tool to build an example solution image for testing and
    illustration. This is a stand-in for the competitors' build systems

${B}Options:${rs}

    ${B}-h${rs} 
        print this message an quit

    ${B}-n${rs}
        fully qualified name of the output image: <docker-repo>:<image-tag>
"
}

while getopts n:h arg; do
    case $arg in
        h)
            help
            quit_with_popd 0
            ;;
        n)
            SOLUTION_NAME=${OPTARG}
            ;;
        *)
        echo -e "$echo_error input option '$arg' is not supported"
        quit_with_popd 1
        ;;
    esac
done

echo -e "${echo_info} building wvu solution..."
if ! docker build --file ${PATH_TO_DOCKERFILE} --tag  ${SOLUTION_NAME} .
then
    echo -e "${echo_error} unable to build wvu solution"
    quit_with_popd 1
fi
echo -e "${echo_ok} ...done"
