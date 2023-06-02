
process RUN_WGET {

    tag "${meta.source}|${meta.type}"
    label 'process_single'

    conda "bioconda::gnu-wget=1.18"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/gnu-wget:1.18--h7132678_6' :
        'quay.io/biocontainers/gnu-wget:1.18--h7132678_6' }"

    input:
    tuple val(meta), val(url)


    output:
    tuple val(meta), path("result.${meta.ext}") , emit:  file_path
    path "versions.yml"                         , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
        if  [[ ${meta.source} == 'GOAT' ]]
        then
            wget --no-check-certificate -c -O result.${meta.ext} '${url}'
        else
            wget -c -O result.${meta.ext} '${url}'
        fi

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            wget: \$(wget --version | head -n 1 | cut -d' ' -f3)
        END_VERSIONS
    """
}
