#!/usr/bin/env bats

if [ ! -x "../install_puppet.sh" ]; then
    printf "No executable ../install_puppet.sh found.\n" >&2
    printf "It's either been renamed or something terrible has happened...\n" >&2
    exit 1
fi

if [ -z "$HAS_JOSH_K_SEAL_OF_APPROVAL" ]; then
    echo "These bats tests currently only work in Travis..."
    echo "Feel free to fix them so they do! ;)"
    exit 1
fi  

pi="../install_puppet.sh"

@test "sanity" {
    run true
    [ "$status" -eq 0 ]
    [ "$output" = "" ]
}

@test "helper option" {
    run "$pi" -h
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "install_puppet.sh - A shell script to install Puppet, asumming no dependancies" ]
}

@test "illegal option" {
    run "$pi" -x
    [ "$status" -eq 1 ]
    echo "${lines[0]}"
    [ "${lines[0]}" = "Illegal option -x" ]
}