#!/bin/bash

copy () {
    rsync -avzp -e 'ssh' $1 $2
}

run () {
    ssh -o "StrictHostKeyChecking no" -t $SERVER $@
}

run_script () {
    ssh -o "StrictHostKeyChecking no" -t $SERVER 'bash -s' < $1 "$2"
}

clean () {
    # remove remote work dir
    run "rm -rf $REMOTE_WORK_DIR"
}

#make parallelism
NPROC=8

# remote variables
REMOTE_WORK_DIR=$CI_DIR/$CIRCLE_PROJECT_REPONAME-$CIRCLE_BRANCH-$CIRCLE_SHA1-$CIRCLE_JOB
REMOTE_RISCV_DIR=$REMOTE_WORK_DIR/riscv-tools-install
REMOTE_CHIPYARD_DIR=$REMOTE_WORK_DIR/chipyard
REMOTE_VERILATOR_DIR=$REMOTE_WORK_DIR/verilator
REMOTE_SIM_DIR=$REMOTE_CHIPYARD_DIR/sims/verilator

# local variables (aka within the docker container)
LOCAL_CHECKOUT_DIR=$HOME/project
LOCAL_RISCV_DIR=$HOME/riscv-tools-install
LOCAL_CHIPYARD_DIR=$HOME/chipyard
LOCAL_VERILATOR_DIR=$HOME/verilator
LOCAL_SIM_DIR=$LOCAL_CHIPYARD_DIR/sims/verilator

# key value store to get the build strings
declare -A mapping
mapping["smallboom"]="CONFIG=SmallBoomConfig"
mapping["mediumboom"]="CONFIG=MediumBoomConfig"
mapping["largeboom"]="CONFIG=LargeBoomConfig"
mapping["megaboom"]="CONFIG=MegaBoomConfig"
mapping["boomandrocket"]="CONFIG=SmallBoomAndRocketConfig"
mapping["rv32boom"]="CONFIG=SmallRV32BoomConfig"
