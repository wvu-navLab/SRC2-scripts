# wvuMountaineers .dockerfile for generating "submission" docker image

#default for solution image argument modified
# ARG origin_image="ros:melodic-ros-core-bionic"
ARG origin_image="no-repo-specified:no-tage-specified"
FROM ${origin_image}

#default for arguments modified
# ARG ros_workspace="/srcp2_ros_workspace"
# ARG ros_package="srcp2_solution"
# ARG round_1_launchfile="qual_round_1.launch"
# ARG round_2_launchfile="qual_round_2.launch"
# ARG round_3_launchfile="qual_round_3.launch"
# ARG entrypoint_script="qual_submission/submission-entrypoint.bash"
ARG ros_workspace="/ros_workspace"
ARG ros_package="state_machine"
ARG round_1_launchfile="sm_round1.launch"
ARG round_2_launchfile="sm_round2.launch"
ARG round_3_launchfile="sm_round3.launch"
ARG entrypoint_script="wvu-submission-entrypoint.bash"

#
ARG use_encryption="true"
ARG encryption_script="docker/scripts/qual_submission/encryption/encrypt.bash"
ARG decryption_script="docker/scripts/qual_submission/encryption/decrypt.bash"
#
ARG symmetric_password=""
ARG symmetric_password_dst=""
ARG encryption_targets=""
ARG public_key_src=""
ARG public_key_dst="/srcp2_scripts/keys/srcp2-public.pem"

# MANDATORY Environment Variables. You must define these to valid paths, packages and launchfiles
# You can use these defaults, or you can reset them in a subsiquent docker file
ENV ROS_WORKSPACE_PATH=${ros_workspace}
ENV SRCP2_MASTER_ROS_PACKAGE=${ros_package}
ENV SRCP2_QUAL_ROUND_1_LAUNCHFILE="${round_1_launchfile}"
ENV SRCP2_QUAL_ROUND_2_LAUNCHFILE="${round_2_launchfile}"
ENV SRCP2_QUAL_ROUND_3_LAUNCHFILE="${round_3_launchfile}"
ENV SRCP2_RUN_COMMAND=""
#
# Encryption Extension
ENV SRCP2_USE_ENCRYPTION=${use_encryption}
ENV SRCP2_ENCRYPTION_TARGETS=${encryption_targets}
ENV SRCP2_PUBLIC_KEY_FILE=${public_key_dst}
ENV SRCP2_SYMMETRIC_PASSWORD_FILE=${symmetric_password_dst}

# These volumes must exist with appropriate read-write permissions
# yes, we know; 'chmod 777' is terrible practice. But it's robust in this context
RUN mkdir -p "/srcp2_volumes/build"
RUN mkdir -p "/srcp2_volumes/logs/.ros"
RUN if [ $(stat -c "%a" "/srcp2_volumes") != "777" ]; then \
    chmod -R 777 "/srcp2_volumes"; \
    fi
#
VOLUME [ "/srcp2_volumes/build" "/srcp2_volumes/logs" ]

# ROS logging env vars
ENV ROS_HOME="/srcp2_volumes/logs"
ENV ROS_LOG_DIR="/srcp2_volumes/logs"

# These scripts will respond to our commands to stand up your sollution
# yes, we know; 'chmod 777' is terrible practice. But it's robust in this context
RUN mkdir -p "/srcp2_scripts"
RUN mkdir -p "/srcp2_scripts/keys" 
#
# COPY "srcp2_setup.bash" "/srcp2_scripts"
COPY "docker/scripts/srcp2_setup.bash" "/srcp2_scripts"
COPY ${entrypoint_script} "/srcp2_scripts/entrypoint.bash"
COPY ${encryption_script} "/srcp2_scripts/encrypt.bash"
COPY ${decryption_script} "/srcp2_scripts/decrypt.bash"
#
RUN if [ $(stat -c "%a" "/srcp2_scripts") != "777" ]; then \
        chmod -R 777 "/srcp2_scripts"; \
    fi

# Do Encryption
COPY ${public_key_src} ${public_key_dst}
RUN apt-get install -y tar openssl
#
RUN /bin/bash /srcp2_scripts/encrypt.bash \
    "${SRCP2_USE_ENCRYPTION}"      \
    "${SRCP2_PUBLIC_KEY_FILE}"     \
    "${symmetric_password}"        \
    "${SRCP2_SYMMETRIC_PASSWORD_FILE}" \
    "${SRCP2_ENCRYPTION_TARGETS}"

WORKDIR /
CMD ["none"]
ENTRYPOINT [ "/bin/bash", "-c", "/srcp2_scripts/entrypoint.bash" ]
