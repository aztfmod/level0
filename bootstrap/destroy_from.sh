set -e

from_step=$1

export tf_command=destroy

echo "Starting ${tf_command}"

function step5 {
    echo " - step5 - ${tf_command}"
    ./step5-simulate_aks_rbac/deploy.sh ${tf_command} -auto-approve
}

function step4 {
    echo " - step4 - ${tf_command}"
    ./step4-simulate_launchpad_opensource/deploy.sh ${tf_command} -auto-approve
}
function step2 {
    echo " - step2 - ${tf_command}"
    ./step2-create_subscription_custom_role/deploy.sh ${tf_command} -auto-approve
}

function step1 {
    echo " - step1 - ${tf_command}"
    ./step1-create_bootstrap_account/deploy.sh ${tf_command} -auto-approve
}

case "${from_step}" in
        "step1")
                step1
                ;;
        "step2")
                step2
                step1
                ;;
        # "step3")
        #         step3
        #         step2
        #         step1
        #         ;;
        "step4")
                step4
                # step3
                step2
                step1
                ;;
        "step5")
                step5
                step4
                # step3
                step2
                step1
                ;;
        *)
                step5
                step4
                # step3
                step2
                step1
                ;;
esac
