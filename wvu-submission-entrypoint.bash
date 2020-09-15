#! /usr/bin/env bash
#
# Space Robotics Competition 2: NASA JSC
# Copyright (c), 2020 NASA-JSC. All Rights Reserved
# Unauthorized distribution strictly prohibited
#
#
# This is the Competitor Container-Side entrypoint script for running the
# competitor's solution ROS packages/launchfiles, and building the 
# source code for the top 25
#
# This code is released, so competitors can build their own submissions.
# However, it is intended to be internal to the submission dockerfile ONLY
# It will not work if run on the host machine
# 
source "/srcp2_scripts/srcp2_setup.bash"
source /opt/ros/melodic/setup.bash


if [  -z $SRCP2_RUN_COMMAND ]; then
    echo -e "$echo_error no input command was provided to the submission entrypoint script"
    exit 1
else
    echo -e "${echo_info} starting SRCP2 submission entrypoint with: \"${SRCP2_RUN_COMMAND}\""
fi


# ---------------------------------------------------------------------------------------------------------------------

function validate_ros_workspace_path(){
    if [ -z ${ROS_WORKSPACE_PATH} ]; then
        echo -e "$echo_error this is a malformed submission: The environment variable \"ROS_WORKSPACE_PATH\" does not exist"
        return 1
    fi
    if [ ! -d ${ROS_WORKSPACE_PATH} ]; then
        echo -e "$echo_error this is a malformed submission: The environment variable \"ROS_WORKSPACE_PATH\" points to \"$ROS_WORKSPACE_PATH\" which is not a directory"
        return 1
    fi
    if [ ! -w ${ROS_WORKSPACE_PATH} ]; then
        echo -e "$echo_warn the ROS_WORKSPACE_PATH is not writable. This may cause build issues"
    fi
    return 0
}

function validate_ros_package_and_launchfile() {
    package=$1
    launchfile=$2
    if ! pack_path=$(rospack find $package); then
        echo -e "$echo_error cannot find ROS package \"$package\""
        return 1
    fi

    launch_path=$(find $pack_path -name $launchfile)
    if [ -z $launch_path ]; then
        echo -e "$echo_error could not find launchfile \"launchfile\" in package \"package\""
        return 1
    else
        echo -e "$echo_ok found \"$package $launchfile\" combination"
        return 0
    fi
}


function build_code() {
    echo -e "$echo_info building code is not supported at this time"
    return 0
}

function run_competitors_solution() {
    round=$1

    #IMPORTANT: The if and elif arguments and code were swapped from original script, so instead 
    #of running source ${ROS_WORKSPACE_PATH}/install/setup.bash by default, we run source 
    #${ROS_WORKSPACE_PATH}/devel/setup.bash by default (if directory exists)
    echo -e "$echo_info looking for and sourcing canonical setup.bash..."
    # if [ -d ${ROS_WORKSPACE_PATH}/install ]; then
    if [ -d ${ROS_WORKSPACE_PATH}/devel ]; then
        source ${ROS_WORKSPACE_PATH}/devel/setup.bash
        echo -e "$echo_ok sourced \"${ROS_WORKSPACE_PATH}/devel/setup.bash\""
        # source ${ROS_WORKSPACE_PATH}/install/setup.bash
        # echo -e "$echo_ok sourced \"${ROS_WORKSPACE_PATH}/install/setup.bash\""

    # elif [ -d ${ROS_WORKSPACE_PATH}/devel ]; then
    elif [ -d ${ROS_WORKSPACE_PATH}/install ]; then
        source ${ROS_WORKSPACE_PATH}/install/setup.bash
        echo -e "$echo_ok sourced \"${ROS_WORKSPACE_PATH}/install/setup.bash\""
        # source ${ROS_WORKSPACE_PATH}/devel/setup.bash
        # echo -e "$echo_ok sourced \"${ROS_WORKSPACE_PATH}/devel/setup.bash\""
    
    else
        echo -e "$echo_error Build path volume \"$build_volume\" has neither \"devel\" nor \"install\" directories. Did you forget to 'catkin_make'?"
        return 1
    fi

    launchfile=""
    case $round in
        1)
            launchfile=${SRCP2_QUAL_ROUND_1_LAUNCHFILE}
            ;;
        2)
            launchfile=${SRCP2_QUAL_ROUND_2_LAUNCHFILE}
            ;;
        3)
            launchfile=${SRCP2_QUAL_ROUND_3_LAUNCHFILE}
            ;;
        *)
            echo -e "$echo_error cannot run solution for round $round."
            return 1
    esac

    if ! validate_ros_package_and_launchfile $SRCP2_MASTER_ROS_PACKAGE $launchfile; then
        echo -e "$echo_error ROS cannot find the launchfile/package combination for round $round"
        return 1
    fi

    roslaunch $SRCP2_MASTER_ROS_PACKAGE $launchfile
    return $?
}

function decrypt_protected_directories() {

    if [ -z $SRCP2_USE_ENCRYPTION ]; then
        echo -e "$echo_warn Encryption status is ambiguious. Some directories may still be encrypted!"
        return 0
    fi
    if [ "$SRCP2_USE_ENCRYPTION" == "false" ]; then
        echo -e "$echo_info SRPC2_USE_ENCRYPTION flag not set. Encryption is presumably not used in this submission."
        return 0
    fi
    if [ "$SRCP2_ENCRYPTION_TARGETS" == "" ]; then
        echo -e "$echo_warn No decryption targets specified, although encryption flag was set. This may perform strangely..."
        return 0
    fi
    if [ -z "$SRCP2_PRIVATE_KEY" ]; then
        echo -e "$echo_error no private key set!"
        return 1
    fi
    if [ -z $SRCP2_SYMMETRIC_PASSWORD_FILE ]; then
        echo -e "$echo_error no symmetric password file set!"
        return 1
    fi

    private_key_file="/tmp/private-key"
    touch $private_key_file
    echo "$SRCP2_PRIVATE_KEY" > $private_key_file

    if ! /srcp2_scripts/decrypt.bash \
            $SRCP2_USE_ENCRYPTION \
            $private_key_file \
            $SRCP2_SYMMETRIC_PASSWORD_FILE \
            "${SRCP2_ENCRYPTION_TARGETS}"; then
        return 1
    fi
    rm -f $private_key_file
    # unset $SRCP2_PRIVATE_KEY
    echo -e "$echo_ok decryption complete, private key has been purged from this container"
    return 0
}


# ---------------------------------------------------------------------------------------------------------------------
# Main Program

echo -e "$echo_info decrypting protected directories. This could take some time..."
if ! decrypt_protected_directories; then
    echo -e "$echo_error unable to decrypt protected directories"
    exit 1
fi

if ! validate_ros_workspace_path; then
    echo -e "$echo_error unable to validate ROS workspace path"
    exit 1
fi

if [[ "$SRCP2_RUN_COMMAND" == "build" ]]; then
    if ! build_code; then
        echo -e "$echo_error unable to build solution from source"
        exit 1
    fi

elif [[ "$SRCP2_RUN_COMMAND" == "round-one" ]]; then
    if ! run_competitors_solution 1; then
        echo -e "$echo_error unable to run solution for round one"
        exit 1
    fi

elif [[ "$SRCP2_RUN_COMMAND" == "round-two" ]]; then
    if ! run_competitors_solution 2; then
        echo -e "$echo_error unable to run solution for round two"
        exit 1
    fi

elif [[ "$SRCP2_RUN_COMMAND" == "round-three" ]]; then
    if ! run_competitors_solution 3; then
        echo -e "$echo_error unable to run solution for round three"
        exit 1
    fi


else
    echo -e "$echo_error The SRCP2 command \"$SRCP2_RUN_COMMAND\" is not supported at this time or is not set!"
    exit 1
fi
