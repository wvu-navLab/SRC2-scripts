#! /usr/bin/env bash
#
# Space Robotics Competition 2: NASA JSC
# Copyright (c), 2019 NASA-JSC. All Rights Reserved
# Unauthorized distribution strictly prohibited
#
# Qualification Round Submission Docker Image Build Script
#
pushd `pwd` > /dev/null 2>&1
cd $(cd -P -- "$(dirname -- "$0")" && pwd -P)
# source "../srcp2_setup.bash"
source "docker/scripts/srcp2_setup.bash"

# Mandatory
COMPETITOR_SOLUTION_REPO="scheducation/srcp2_qualification_submissions"
COMPETITOR_SOLUTION_IMAGE_TAG=""
COMPETITOR_INPUT_IMAGE_NAME=""
FINAL_IMAGE_NAME=""

# ROS configurations -- these are the defaults
# ROS_WORKSPACE_PATH="/ros_workspace"
# ROS_PACKAGE="srcp2_qual_rounds"
# ROUND_1_LAUNCHFILE="qual_round_1.launch"
# ROUND_2_LAUNCHFILE="qual_round_2.launch"
# ROUND_3_LAUNCHFILE="qual_round_3.launch"
ROS_WORKSPACE_PATH="/ros_workspace"
ROS_PACKAGE="state_machine"
ROUND_1_LAUNCHFILE="sm_round1.launch"
ROUND_2_LAUNCHFILE="sm_round2.launch"
ROUND_3_LAUNCHFILE="sm_round3.launch"

# Optional
SUBMIT_FINAL_IMAGE="false"
DRY_RUN_ONLY="false"

# Build back-end
# PATH_TO_BUILD_CONTEXT="$(cd ../../scripts && pwd)"
# PATH_TO_DOCKERFILE="$(cd ../../dockerfiles && pwd)/qual_submission.dockerfile"
# ENTRYPOINT_SCRIPT="qual_submission/submission-entrypoint.bash"
PATH_TO_BUILD_CONTEXT="."
PATH_TO_DOCKERFILE="wvu_submission.dockerfile"
ENTRYPOINT_SCRIPT="wvu-submission-entrypoint.bash"

# Encryption
USE_ENCRYPTION="true"

# the public key selected by the user
# USERS_PUBLIC_KEY="$(pwd)/encryption/srcp2-public.pem"
USERS_PUBLIC_KEY="docker/scripts/qual_submission/encryption/srcp2-public.pem"

# need to copy the public key to -here- to be included in the docker context
# PUBLIC_KEY_HOST_DST="$(pwd)/encryption/temp-public-key.pem"
# PUBLIC_KEY_CTX="qual_submission/encryption/temp-public-key.pem"
PUBLIC_KEY_HOST_DST="docker/scripts/qual_submission/encryption/temp-public-key.pem"
PUBLIC_KEY_CTX="docker/scripts/qual_submission/encryption/temp-public-key.pem"

# destination in the container for the public key
PUBLIC_KEY_DST="/srcp2_scripts/keys/public-key.pem"

# destination in the container for the encrypted symmetric password
SYMMETRIC_KEY_DST="/srcp2_scripts/keys/encrypted-symmetric-key"

# how long/secure should the symmetric key be?
SYMMETRIC_KEY_LENGTH="100"

# space separated list of other targets
EXTRA_ENCRYPTION_TARGETS=""


# ======================================================================================================================

function help() {
    echo -e "
${B}Synopsis:${rs}

    Use this tool to wrap your submission image for automated review. This will
    use the 'qual_submission.dockerfile' to generate a new Docker image that 
    contains the necessary hooks for us to build and run your solution to 
    the qualifcation rounds.

    With this approach, we hope to (relatively) seamlessly integrate your work
    into an automation framework.

    This approach has several implicit assumptions. We strongly 
    recommend that you read the details on the wiki thoroughly before 
    completing your submission:
    https://gitlab.com/scheducation/srcp2-competitors/-/wikis/home

    Since release we have added ${B}Encryption${rs} to the submission image
    default structure. By default, the ROS workspace specified by the '-w'
    option will be encrypted. See the wiki and 'Submission Encryption Control'
    (below) for more options on controlling this.

    Overview:
    [Competitor Solution Image] --> build-submission-image.bash --> [Submission Image]


${B}Mandatory Options:${rs}

    ${B}-i | --in-name${rs}
        Fully qualified name of your solution image, as output by your build
        infrastructure. This will be used as the basis (FROM) for the final
        submission image
        ${B}this is a required option${rs}

    ${B}-t | --tag${rs}
        submission image tag, using the team's name is strongly recommended
        ${B}this is a required option${rs}

${B}Submission ROS Packages & Launchfile Config ${rs}

    Use these options to configure which ROS package and launchfiles our
    automated system will use to run your solution. You may choose to
    override these, or use the defaults, but they must be correct for 
    your image!

    ${B}-w | --workspace${rs}
        absolute path (from '/') of your ROS workspace in your container.
        for general submission, we are using this to find your 'install'
        or 'devel' directories (we will search for 'setup.bash' in that order)

        If you are invited to supply a buildable version, then we 
        will expect to be able to run 'catkin_make' your workspace
        and build your solution. 
        ${B}Default:${rs} ${ROS_WORKSPACE_PATH}

    ${B}-p | --package${rs}
        The name of the ROS package in which these launchfiles live.
        Just the package-name, not the path
        ${B}Default:${rs} ${ROS_PACKAGE}

    ${B}-1 | --round-one${rs}
        The name of the launchfile which starts round-one. 
        Just the file-name, not the path
        ${B}Default:${rs} ${ROUND_1_LAUNCHFILE}

    ${B}-2 | --round-two${rs}
        The name of the launchfile which starts round-two. 
        Just the file-name, not the path
        ${B}Default:${rs} ${ROUND_2_LAUNCHFILE}

    ${B}-3 | --round-three${rs}
        The name of the launchfile which starts round-three.
        Just the file-name, not the path
        ${B}Default:${rs} ${ROUND_2_LAUNCHFILE}


${B}Submission Encryption Control${rs}

    ${B}-n | --no-encryption${rs}
        do not use encryption on this image
        ${y}Warning:${rs} If you push an unencrypted image, the data it contains
        will be public to all compeditiors.

    ${B}-k | --public-key${rs}
        For your convenience, you may specify your own public key to perform
        the encryption.
        ${y}Warning:${rs} this is a debug and testing feature. NASA will not be
        able to grade any submission that is not encrypted with the standard
        public key. This is for your competitors' use ONLY.
        ${B}Default:${rs} $ENCRYPTION_KEY_PATH

    ${B}-e | --encrypt-extra${rs}
        By default, only the 'workspace' (see '-w', above) is encrypted. Using
        this option, you may specify more directories to encrypt.
        These directories should be specified as a string list:
        ${B}--encrypt-extra \"/a-directory /home/another-directory\"${rs}

        ${y}Warning:${rs}
        By specifying these directories you are:
            - asserting that these are not critical system directories
            - taking responsibility for ensuring that a non-root user can
              decrypt these (ie: has read-write permission to their parent)
            - taking responsibility for ensuring that these directories do
              not contain system tools pertinant to tar, or pgp

        Note that decryption is performed at runtime by a non-root user!
        Use this --encrypt-extras feature ${B}wholly at your own risk!${rs}


${B}Other Options:${rs}

    ${B}-h | --help${rs}
        print this message and quit

    ${B} -s | --submit${rs}
        Deploy the image to the submission dockerhub repo once the build is complete
        You will need to be logged into your dockerhub account to do this.

        This will push to \"${COMPETITOR_SOLUTION_REPO}/<tag>\"

        ${y}Warning:${rs} If the image name you have chosen is already present
        in the dockerhub repo, you can choose to overwrite it. However, please
        note that clobbering another team's submission is both easy to detect,
        and a disqualifying offence.

    ${B} -d | --dry${rs}
        Marshal and print the options, but do not build or deploy anything.

${B}Copyright${rs}
    
    Space Robotics Challenge, Phase 2
    Copyright (c) 2020, NASA-JSC. All Rights Reserved
    Unauthorized Distribution Strictly Prohibited
"
}

function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$COMPETITOR_SUBMISSION_REPO/tags/$COMPETITOR_SOLUTION_IMAGE_TAG > /dev/null
}

function deploy_image() {

    if docker_tag_exists $FINAL_IMAGE_NAME; then

        echo -e "$echo_warn the image with the tag \"$COMPETITOR_SOLUTION_IMAGE_TAG\" "\
                "already exists in the submission repo."

        echo -e "$echo_warn please note that attempting to clobber another "\
                "team's submission is a disqualifying offence. "\
                "Do you wish to re-submit this image?"

        if ! prompt_confirm; then
            echo -e "$echo_info ok, image not pushed"
            return 0
        fi
        echo -e "$echo_info pushing new image, overwriting old..."
    else
        echo -e "$echo_info pushing new image..."
    fi

    if docker push $COMPETITOR_SOLUTION_IMAGE_TAG; then
        echo -e "$echo_error unable to complete docker push! "\
                "You have ${B}${r}NOT${rs} submitted your image"
        return 1
    fi
    echo -e "$echo_ok Dockerhub push complete. Your SRCP2 solution "\
            "has been submitted for grading"
    return 0
}



# ---------------------------------------------------------------------------------------------------------------------
# Parse Input and Build Image

echo_header

# long opts to short ops
for arg in "$@"; do
    shift
    case "$arg" in
        "--in-name")     set -- "$@" "-i" ;;
        "--out-tag")     set -- "$@" "-t" ;;
 
        "--workspace")   set -- "$@" "-w"  ;;
        "--package")     set -- "$@" "-p"  ;;
        "--round-one")   set -- "$@" "-1" ;;
        "--round-two")   set -- "$@" "-2" ;;
        "--round-three") set -- "$@" "-3" ;;

        "--help")        set -- "$@" "-h" ;;
        "--submit")      set -- "$@" "-s" ;;
        "--dry")         set -- "$@" "-d" ;;

        "--no-encryption")  set -- "$@" "-n" ;;
        "--public-key")     set -- "$@" "-k" ;;
        "--encrypt-extras") set -- "$@" "-e" ;; 

        *) set -- "$@" "$arg"
    esac
done

OPTIND=1
while getopts t:i:w:p:1:2:3:dshnk:e: arg; do
    case $arg in
        h)
            help
            quit_with_popd 0
            ;;
        d)
            DRY_RUN_ONLY="true"
            ;;
        s)
            SUBMIT_FINAL_IMAGE="true"
            ;;
        i)
            COMPETITOR_SOLUTION_IMAGE_TAG=$OPTARG
            ;;
        t)
            FINAL_IMAGE_NAME=${COMPETITOR_SOLUTION_REPO}:${OPTARG}
            ;;
        w)
            ROS_WORKSPACE_PATH=$OPTARG
            ;;
        p)
            ROS_PACKAGE=$OPTARG
            ;;
        1)
            ROUND_1_LAUNCHFILE=$OPTARG
            ;;
        2)
            ROUND_2_LAUNCHFILE=$OPTARG
            ;;
        3)
            ROUND_3_LAUNCHFILE=$OPTARG
            ;;
        n)
            USE_ENCRYPTION="false"
            ;;
        k)
            USERS_PUBLIC_KEY=$OPTARG
            ;;
        e)
            EXTRA_ENCRYPTION_TARGETS=$OPTARG
            ;;
        *)
            echo -e "$echo_error input option '$arg' is not supported"
            quit_with_popd 1
            ;;
    esac
done


if [ -z $COMPETITOR_SOLUTION_IMAGE_TAG ]; then
    echo -e "$echo_error Please provide a base image name"
    quit_with_popd 1
fi


# Encryption Checks
if [ "$USE_ENCRYPTION" == "false" ]; then
    echo -e "$echo_warn This image will ${B}NOT${rs} encrypt your workspace."\
            "If you push it, the image will be publicaly readable!\n"
    echo -e "$echo_warn Are you ${B}very${rs} sure you want to do this?"
    echo -e "$echo_warn ${B}Please note:${rs} by agreeing to this, you are implicitly"\
            "agreeing to make all the contents of your submission image public"\
            "to all competitors!"
    echo
    if ! prompt_confirm; then
        exit 0
    fi
    echo
    encrytion_targets=""
else
    encryption_targets="${ROS_WORKSPACE_PATH} ${EXTRA_ENCRYPTION_TARGETS}"
fi
if [ ! -f $USERS_PUBLIC_KEY ]; then
    echo -e "$echo_error unable to find public key: \"$USERS_PUBLIC_KEY\""
    exit 1
fi

# create symmetric key and copy in asymmetric key
symmetric_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${SYMMETRIC_KEY_LENGTH} | head -n 1)
#
# copy whatever key has been specified by the user to the docker build context
cp ${USERS_PUBLIC_KEY} ${PUBLIC_KEY_HOST_DST}

# ======================================================================================================================

echo -e "${B}Build Submission Image -- Summary:${rs}"
echo -e "
$echo_info ${B}Image Meta Information:${rs}
$echo_info input competitor image: \"$COMPETITOR_SOLUTION_IMAGE_TAG\"
$echo_info submition final image:  \"$FINAL_IMAGE_NAME\"

$echo_info ${B}ROS Paths, Packages and Launchfiles:${rs}
$echo_info container ros workspace path: \"$ROS_WORKSPACE_PATH\"
$echo_info container ros package:        \"$ROS_PACKAGE\"
$echo_info round 1 launchfile: \"$ROUND_1_LAUNCHFILE\"
$echo_info round 2 launchfile: \"$ROUND_2_LAUNCHFILE\"
$echo_info round 3 launchfile: \"$ROUND_3_LAUNCHFILE\""

if [ "$USE_ENCRYPTION" == "true" ]; then
    echo -e "
    $echo_info ${B}Encryption Targets:${rs}
    $echo_info submission encryption password pub-key: \"$USERS_PUBLIC_KEY\"
    $echo_info symmetric password ${B}(Keep This Private!)${rs}: \"${symmetric_password}\"
    $echo_info will be encrypting the following targets: "
    for target in $encryption_targets; do
        echo -e "$echo_info >\t$target"
    done
fi
echo

if [[ "$DRY_RUN_ONLY" == "true" ]]; then
    echo -e "$echo_ok this is a dry run, exiting"
    quit_with_popd 0
else
    echo -e "${B}Build Submission Image -- Docker Build:${rs}\n"
fi

# Build the Image
#
docker build \
    \
    --file ${PATH_TO_DOCKERFILE} \
    --tag  ${FINAL_IMAGE_NAME} \
    \
    --build-arg origin_image=${COMPETITOR_SOLUTION_IMAGE_TAG} \
    --build-arg ros_workspace=${ROS_WORKSPACE_PATH} \
    --build-arg ros_package=${ROS_PACKAGE} \
    \
    --build-arg round_1_launchfile=${ROUND_1_LAUNCHFILE} \
    --build-arg round_2_launchfile=${ROUND_2_LAUNCHFILE} \
    --build-arg round_3_launchfile=${ROUND_3_LAUNCHFILE} \
    \
    --build-arg entrypoint_script=${ENTRYPOINT_SCRIPT} \
    \
    --build-arg use_encryption=${USE_ENCRYPTION}              \
    --build-arg encryption_targets="${encryption_targets}"    \
    \
    --build-arg public_key_src="${PUBLIC_KEY_CTX}" \
    --build-arg public_key_dst="${PUBLIC_KEY_DST}" \
    \
    --build-arg symmetric_password="$symmetric_password"      \
    --build-arg symmetric_password_dst="${SYMMETRIC_KEY_DST}" \
    \
    ${PATH_TO_BUILD_CONTEXT}

if [ $? -ne 0 ]; then
    echo -e "$echo_error unable to build submission image!"
    rm -f $PUBLIC_KEY_HOST_DST
    quit_with_popd 1
fi
echo -e "\n$echo_ok Build of \"${FINAL_IMAGE_NAME}\" complete"

if [[ "$SUBMIT_FINAL_IMAGE" == "true" ]]; then
    deploy_image
fi

rm -f $PUBLIC_KEY_HOST_DST
quit_with_popd 0