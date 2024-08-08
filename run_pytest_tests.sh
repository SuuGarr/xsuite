set -e # Exit immediately if a command exits with a non-zero status.

WF_BRANCH="pytest-csv"

XOBJECTS=SuuGarr:pytest-csv
   XPART=SuuGarr:pytest-csv
   XDEPS=SuuGarr:pytest-csv
  XTRACK=SuuGarr:feature/twiss_ergonomics
 XFIELDS=SuuGarr:pytest-csv
   XMASK=SuuGarr:pytest-csv
   XCOLL=SuuGarr:pytest-csv

platform="$1"
context="$2"
pytest_options="$3"

run_tests(){
    local platform=$1
    local context=$2
    local options=$3

    echo "Running on $platform with $context and options: '$options'"

    python run_on_test_gh.py --suites xo,xp,xd,xt,xf,xc --platform "$platform" --ctx "$context" \
        --xo "$XOBJECTS" --xp "$XPART" --xd "$XDEPS" --xt "$XTRACK" --xf "$XFIELDS" --xm "$XMASK" --xc "$XCOLL" \
        --branch "$WF_BRANCH" --pytest-options "$options"

    python run_on_gh.py --suites xm --platform pcbe-abp-gpu001 --ctx cpu \
        --xo "$XOBJECTS" --xp "$XPART" --xd "$XDEPS" --xt "$XTRACK" --xf "$XFIELDS" --xm "$XMASK" --xc "$XCOLL" \
        --branch "$WF_BRANCH" --pytest-options "$options"
}

run_tests "$platform" "$context" "$pytest_options"
