set -e # Exit immediately if a command exits with a non-zero status.

WF_BRANCH="main"

XOBJECTS=xsuite:main
   XPART=xsuite:main
   XDEPS=xsuite:main
  XTRACK=xsuite:feature/twiss_ergonomics
 XFIELDS=xsuite:main
   XMASK=xsuite:main
   XCOLL=xsuite:main

pytest_options="$1"

run_tests(){
    local options=$1

    declare -A platform=(
        ["alma"]="cuda"
        ["ubuntu"]="cl"
        ["pcbe-abp-gpu001"]="cpu"
        ["radeon"]="cpu:auto"
        ["alma-cpu-1"]="cpu"
    )

    for platform in "${!platforms[@]}"; do
        context="${platforms[$platform]}"
        echo "Running on $platform with $context and options:'$options'"

        python run_on_test_gh.py --suites xo,xp,xd,xt,xf,xc --platform $platform --ctx $context \ 
            --xo $XOBJECTS --xp $XPART --xd $XDEPS --xt $XTRACK --xf $XFIELDS --xm $XMASK --xc $XCOLL \ 
            --branch $WF_BRANCH --pytest-options"$options"
    done 

    python run_on_gh.py --suites xm --platform pcbe-abp-gpu001 --ctx cpu \
        --xo $XOBJECTS --xp $XPART --xd $XDEPS --xt $XTRACK --xf $XFIELDS --xm $XMASK --xc $XCOLL --branch $WF_BRANCH --pytest-options"$options"
}

run_tests "$pytest_options"
